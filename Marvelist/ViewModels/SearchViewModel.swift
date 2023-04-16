//
//  SearchViewModel.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 16.04.2023.
//

import Foundation
import CryptoKit
import Combine

class SearchViewModel: ObservableObject {
    @Published var filterCharacter = ""
    @Published var searchedCharacters = [Character]()
    
    let limit = 20
    var page = 1
    
    init() {
        
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
    
    func searchCharacters() async {
        let offset = page * limit
        
        let ts = String(Date().timeIntervalSince1970)
        let hashValue = MD5("\(ts)\(privateApiKey)\(publicApiKey)")
        
        let searchText = filterCharacter.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?nameStartsWith=\(searchText)limit=\(limit)&offset=\(offset)&ts=\(ts)&apikey=\(publicApiKey)&hash=\(hashValue)"
        
        do {
            guard let url = URL(string: urlString) else {return}
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let dataModel = try JSONDecoder().decode(DataModel.self, from: data)
            
            DispatchQueue.main.async {
                for character in dataModel.data.results {
                    self.searchedCharacters.append(character)
                }
            }
            self.page += 1
            
        } catch {
            print("unable to read the data")
        }
    }
    
    func MD5(_ data: String) -> String {
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
