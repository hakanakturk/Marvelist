//
//  CharacterListView.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 13.04.2023.
//

import SwiftUI
import CryptoKit
import SDWebImageSwiftUI

struct CharacterListView: View {
    @EnvironmentObject var viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                if viewModel.isShowingGridView {
                    ScrollView() {
                        LazyVGrid(columns: viewModel.columns) {
                            ForEach(viewModel.favoriteCharacters) { character in
                                VStack(){
                                    Text("\(character.name ?? "")")
                                        .font(.headline)
                                        .frame(width: 70, height: 20)
                                        .padding(.top)
                                        .onTapGesture {
                                            viewModel.selectedCharacter = character
                                        }
                                    
                                    WebImage(url: URL(string: "\(character.thumbnail?.path ?? "").\(character.thumbnail?.extension ?? "")"))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(39)
                                        .onTapGesture {
                                            viewModel.selectedCharacter = character
                                        }
                                    
                                    Text("Series \(character.series?.items?.count ?? 0)")
                                        .font(.footnote)
                                        .frame(width: 70, height: 20)
                                        .onTapGesture {
                                            viewModel.selectedCharacter = character
                                        }
                                    
                                    Image(systemName: "star.fill")
                                        .foregroundColor(viewModel.isSaved(character) ? K.onColor : K.offColor)
                                        .padding()
                                        .frame(width: 40, height: 20)
                                        .onTapGesture {
                                            viewModel.addToFavorites(character)
                                        }
                                }
                            }
                        }
                    }
                } else {
                    List{
                        ForEach(viewModel.favoriteCharacters){ character in
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
                        ProgressView()
                            .progressViewStyle(.circular)
                            .task {
                                await viewModel.getCharacters()
                            }
                    }
                    .listStyle(.plain)
                    
                }
            }
            .navigationTitle("Marvelist")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        viewModel.switchToFavoriteCharacters()
                    } label: {
                        Image(systemName: "star.fill")
                            .foregroundColor(viewModel.isShowingFavorite ? K.onColor : K.offColor)
                            .padding()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(){
                        viewModel.switchToGridView()
                    } label: {
                        Image(systemName: "square.grid.2x2.fill")
                            .foregroundColor(viewModel.isShowingGridView ? K.gridOnColor : K.offColor)
                            .padding()
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedCharacter) { character in
            CharacterDetailView(character: character)
        }
        .task {
            await viewModel.getCharacters()
        }
    }
}


struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
            .environmentObject(CharacterListViewModel())
    }
}
