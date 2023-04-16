//
//  SearchView.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 16.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                List(viewModel.searchedCharacters) { character in
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
                        
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(viewModel.isSaved(character) ? K.onColor : K.offColor)
                            .padding(.leading)
                            .onTapGesture {
                                viewModel.addToFavorites(character)
                            }
                        
                    }
                    
                }
                .searchable(text: $viewModel.filterCharacter )
                .navigationTitle("Marvelist")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
