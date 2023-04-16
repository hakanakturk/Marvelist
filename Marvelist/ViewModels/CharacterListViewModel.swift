//
//  CharacterListViewModel.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 14.04.2023.
//


import SwiftUI
import CryptoKit
import Combine

@MainActor class CharacterListViewModel: ObservableObject {
    

    @Published var characterList = [Character]()
    @Published var savedCharacterList = [Character]()
    @Published var selectedCharacter: Character?
    
    @Published var isShowingFavorite = false
    @Published var isShowingGridView = false
    
    @Published var comicsList = [ComicsDetail]()
    @Published var savedComicsList = [ComicsDetail]()
    
    @Published var seriesList = [ComicsDetail]()
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    let limit = 20
    var page = 1
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedCharacters")
    let savePathForComics = FileManager.documentsDirectory.appendingPathComponent("SavedComics")
    let savePathForSeries = FileManager.documentsDirectory.appendingPathComponent("SavedSeries")
    
    
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
    
    var favoriteCharacters: [Character] {
        if isShowingFavorite{
            return savedCharacterList
        }else {
            return characterList
        }
    }
    
    
    func switchToFavoriteCharacters(){
        isShowingFavorite.toggle()
    }
    
    func switchToGridView(){
        isShowingGridView.toggle()
    }
    

    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let comicsData = try Data(contentsOf: savePathForComics)
            savedCharacterList = try JSONDecoder().decode([Character].self, from: data)
            savedComicsList = try JSONDecoder().decode([ComicsDetail].self, from: comicsData)
        }catch {
            savedCharacterList = []
            savedComicsList = []
        }

    }
    
    private func save(){
        do{
            let data = try JSONEncoder().encode(savedCharacterList)
            let comicsData = try JSONEncoder().encode(savedComicsList)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            try comicsData.write(to: savePathForComics, options: [.atomicWrite, .completeFileProtection])
        }catch{
            print("Unable to save data.")
        }
    }
    
    func addToFavorites(_ character: Character){
        if !isSaved(character){
            savedCharacterList.append(character)
            save()
            print("Character is saved to favorites")
        } else {
            if let index = savedCharacterList.firstIndex(of: character) {
                savedCharacterList.remove(at: index)
                save()
                print("Character is deleted from favorites")
            }
        }
    }
    
    func isSaved(_ character: Character) -> Bool {
        savedCharacterList.contains(character)
    }
    
    func getCharacters() async {
        
        let offset = page * limit
        
        let ts = String(Date().timeIntervalSince1970)
        let hashValue = MD5("\(ts)\(privateApiKey)\(publicApiKey)")
        let urlString = "https://gateway.marvel.com/v1/public/characters?limit=\(limit)&offset=\(offset)&ts=\(ts)&apikey=\(publicApiKey)&hash=\(hashValue)"
        
        do {
            let url = URL(string: urlString)!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let dataModel = try JSONDecoder().decode(DataModel.self, from: data)
            
            DispatchQueue.main.async {
                for character in dataModel.data.results {
                    self.characterList.append(character)
                }
            }
            
            self.page += 1
            
        } catch {
            print("unable to read the data")
        }
    }

    
    func getComicsDetail(_ comics: String?) async {
        let ts = String(Date().timeIntervalSince1970)
        let hashValue = MD5("\(ts)\(privateApiKey)\(publicApiKey)")
        let comicsUrl = "\(comics ?? "")?ts=\(ts)&apikey=\(publicApiKey)&hash=\(hashValue)"
        
        do {
            let url = URL(string: comicsUrl)!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let comicsModel = try JSONDecoder().decode(ComicsData.self, from: data)
            
            comicsList = comicsModel.data.results
            
        } catch {
            print("Unable to read comics data. ")
        }
    }
    
    func getSeriesDetail(_ series: String?) async {
        let ts = String(Date().timeIntervalSince1970)
        let hashValue = MD5("\(ts)\(privateApiKey)\(publicApiKey)")
        let seriesUrl = "\(series ?? "")?ts=\(ts)&apikey=\(publicApiKey)&hash=\(hashValue)"
        
        do {
            let url = URL(string: seriesUrl)!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let comicsModel = try JSONDecoder().decode(ComicsData.self, from: data)
            
            seriesList = comicsModel.data.results
            
        } catch {
            print("Unable to read comics data. ")
        }
    }

    func MD5(_ data: String) -> String {
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    
}
