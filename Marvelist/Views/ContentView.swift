//
//  ContentView.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 13.04.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CharacterListViewModel()
    var body: some View {
        TabView {
            CharacterListView()
                .tabItem {
                    Label("Characters", systemImage: "person.3.sequence.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .environmentObject(CharacterListViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
