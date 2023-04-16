//
//  SearchView.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 16.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.filterCharacter.isEmpty {
                    Label("Start searching", systemImage: "photo.fill")
                } else {
                    List {
                        ForEach(viewModel.searchedCharacters) { character in
                            HStack {
                                WebImage(url: URL(string: "\(character.thumbnail?.path ?? "").\(character.thumbnail?.extension ?? "")"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(39)
                                    .padding(.trailing)
                                    .onTapGesture {
                                        viewModel.selectedCharacter = character
                                    }
                                
                                VStack {
                                    Text(character.name ?? "")
                                        .padding(.bottom)
                                    
                                    Text("Series: \(character.series?.items?.count ?? 0)")
                                }
                                .frame(width: 150, height: 80)
                                .onTapGesture {
                                    viewModel.selectedCharacter = character
                                }
                            }
                        }
                        switch viewModel.state {
                        case .good:
                            Color.clear
                                .onAppear {
                                    viewModel.searchCharacters(viewModel.filterCharacter)
                                }
                        case .loading:
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(maxWidth: .infinity)
                        case .loaded:
                            EmptyView()
                        case .error(let message):
                            Text(message)
                                .foregroundColor(.secondary)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $viewModel.filterCharacter )
            .navigationTitle("Marvelist")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $viewModel.selectedCharacter) { character in
            CharacterDetailView(character: character)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

