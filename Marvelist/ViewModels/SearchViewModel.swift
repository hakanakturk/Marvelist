//
//  SearchViewModel.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 16.04.2023.
//

import SwiftUI
import CryptoKit
import Combine

class SearchViewModel: ObservableObject {
    @Published var filterCharacter = ""
    @Published var searchedCharacters = [Character]()
    @Published var selectedCharacter: Character?
    
    let limit = 20
    var page = 1
    
    enum State: Comparable {
        case good
        case loading
        case loaded
        case error(String)
    }
    
    @Published var state: State = .good {
        didSet {
            print("State is now: \(state)")
        }
    }
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        $filterCharacter
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink{ [weak self] filter in
                self?.state = .good
                self?.searchedCharacters = []
                self?.searchCharacters(filter)
            }.store(in: &cancellable)
    }
    
    var publicApiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
                fatalError("Couldn't find file")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "PUBLIC_API_KEY") as? String else {
                fatalError("Couldn't find key")
            }
            return value
        }
    }
    
    var privateApiKey: String {
        get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
                fatalError("Couldn't find file")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "PRIVATE_API_KEY") as? String else {
                fatalError("Couldn't find key")
            }
            return value
        }
    }
    
    func search() {
        searchCharacters(filterCharacter)
    }
    
    func searchCharacters(_ character: String) {
        
        guard !filterCharacter.isEmpty else {return}
        
        guard state == State.good else {return}
        
        let offset = page * limit
        let ts = String(Date().timeIntervalSince1970)
        let hashValue = MD5("\(ts)\(privateApiKey)\(publicApiKey)")
        
        guard let urlString = URL(string: "https://gateway.marvel.com/v1/public/characters?nameStartsWith=\(character)&limit=\(limit)&offset=\(offset)&ts=\(ts)&apikey=\(publicApiKey)&hash=\(hashValue)") else {return}
        
        print("Starting to search for \(character)")
        state = .loading
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlString) { [weak self] data, response , error in
            
            if let error = error {
                print("URL Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.state = .error("searching characters are failed \(error.localizedDescription)")
                }
            } else if let returnData = data {
                do {
                    let allData = try JSONDecoder().decode(DataModel.self, from: returnData)
                    DispatchQueue.main.async {
                        for character in allData.data.results {
                            self?.searchedCharacters.append(character)
                            self?.state = (allData.data.count == self?.limit) ? .good : .loaded
                        }
                        self?.page += 1
                    }
                } catch {
                    print("Decode error \(error)")
                    DispatchQueue.main.async {
                        self?.state = .error("Failed to get the data: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()

    }
    
    func MD5(_ data: String) -> String {
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
