//
//  CharacterDetailView.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 15.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterDetailView: View {
    @EnvironmentObject var viewModel: CharacterListViewModel
    var character: Character
    
    var body: some View {
        ScrollView{
            VStack{
                HStack {                    
                    WebImage(url: URL(string: "\(character.thumbnail?.path ?? "").\(character.thumbnail?.extension ?? "")"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .cornerRadius(30)
                        .padding()
                    
                    Spacer()
                    
                    Text(character.name ?? "")
                        .padding(.bottom)
                        .font(.title2)
                        .frame(width: 150, height: 100)
                    
                    Spacer()
                    
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(viewModel.isSaved(character) ? K.onColor : K.offColor)
                        .padding(.leading)
                        .onTapGesture {
                            viewModel.addToFavorites(character)
                        }
                    
                    
                    Spacer()
                }
                
                Text("About: \(character.description ?? "")")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Text("Series of \(character.name ?? ""): ")
                    .font(.title3)
                    .padding()
                
                LazyVGrid(columns: viewModel.columns, spacing: 20) {
                    ForEach(viewModel.seriesList) { series in
                        VStack {
                            
                            WebImage(url: URL(string: "\(series.thumbnail?.path ?? "").\(series.thumbnail?.extension ?? "")"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .cornerRadius(30)
                                .padding()
                            
                            Text("\(series.title)")
                                .font(.footnote)
                                .lineLimit(3)
                                .padding(.bottom, 3)
                            
                        }
                    }
                }
                
                Group {
                    Text("Story Involvements: ")
                        .font(.title3)
                        .padding()
                    
                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                        ForEach(character.stories?.items ?? [], id: \.name) { story in
                            VStack {
                                Image(systemName: "photo.fill")
                                
                                Text("\(story.name ?? "")")
                                    .font(.footnote)
                                    .lineLimit(2)
                                    .padding(1)
                            }
                        }
                    }
                }
                
                Group{
                    Text("Important Events:")
                        .font(.title3)
                        .padding()
                    
                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                        ForEach(character.events?.items ?? [], id: \.name) { event in
                            VStack {
                                Image(systemName: "photo.fill")
                                
                                Text("\(event.name ?? "")")
                                    .font(.footnote)
                                    .lineLimit(2)
                                    .padding(1)
                            }
                        }
                    }
                }
                
                Text("Comics of \(character.name ?? ""):")
                    .font(.title3)
                    .padding()
                
                LazyVGrid(columns: viewModel.columns, spacing: 20) {
                    ForEach(viewModel.comicsList) { comics in
                        VStack {
                            
                            WebImage(url: URL(string: "\(comics.thumbnail?.path ?? "").\(comics.thumbnail?.extension ?? "")"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .cornerRadius(30)
                                .padding()
                            
                            Text("\(comics.title)")
                                .font(.footnote)
                                .lineLimit(3)
                                .padding(.bottom, 3)
                            
                        }
                    }
                } 
            }
            .navigationTitle("Marvelist")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.getComicsDetail(character.comics?.collectionURI ?? "")
                await viewModel.getSeriesDetail(character.series?.collectionURI ?? "")
            }
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharacterDetailView(character: Character.example)
            .environmentObject(CharacterListViewModel())
    }
}
