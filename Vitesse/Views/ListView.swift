//
//  ListView.swift
//  Vitesse
//
//  Created by Alassane Der on 08/09/2024.
//


import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewmodel: ListViewModel
    
    @State var isEditing: Bool = false
    @State var isDeleting: Bool = false
    
    
    
    var body: some View {
        
        NavigationStack {
            // MARK: search Bar
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title)
                        TextField("Search candidates", text: $viewmodel.searchText)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .frame(height: 45)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
                    }
                    if viewmodel.issearching {
                        Button {
                            viewmodel.searchText = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
            .padding(.top, 15)
            .padding(.horizontal, 15)
            .padding(.bottom, 10)
            
            
            // MARK: liste des candidats
            List {
                ForEach(viewmodel.applyFilter(), id: \.id) { candidat in
                    HStack {
                        if !isEditing {
                            NavigationLink(value: candidat) {
                                HStack {
                                    Text("\(viewmodel.getFirstLetter(item: candidat))")
                                        .padding(10)
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(Color(hex: "#BDBDBD").opacity(0.9)))
                                    Text(candidat.firstName)
                                    Text(candidat.lastName)
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(candidat.isFavorite ? Color.black : Color(hex: "#BDBDBD").opacity(0.4))
                                }
                                .foregroundStyle(Color.black)
                            }
                            // Supprime le fond gris après sélection
//                            .listRowBackground(Color.clear)
                        } else {
                            Button {
                                // selection de candidats
                                viewmodel.selectCandidates(by: candidat)
                            } label: {
                                HStack {
                                    Image(systemName: viewmodel.selectedCandidatIDs.contains(candidat) ? "checkmark.circle.fill" : "circle")
                                    Text("\(viewmodel.getFirstLetter(item: candidat))")
                                        .padding(10)
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(Color(hex: "#BDBDBD").opacity(0.9)))
                                    Text(candidat.firstName)
                                    Text(candidat.lastName)
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(candidat.isFavorite ? Color.black : Color(hex: "#BDAEC2"))
                                }
                                .foregroundStyle(Color.black)
                            }
                        }
                    }
                }
            }
            .refreshable(action: {  // rafraichi la liste en glissant vers le bas
                await viewmodel.loadList()
            })
            .navigationTitle("Candidates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                if !isEditing {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isEditing.toggle()
                            
                        } label: {
                            Text("Edit")
                                .foregroundStyle(Color.black)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // filter by favorit
                            viewmodel.isSelectingFavorits.toggle()
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(viewmodel.isSelectingFavorits ? Color.black : Color(hex: "#BDBDBD").opacity(0.2))
                        }
                        
                    }
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isEditing = false
                            viewmodel.selectedCandidatIDs = []
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(Color.black)
                        }
                        
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // perform deletion
                            isDeleting = true
                            Task {
                                await viewmodel.deleteAndReloadList(selectedCandidatIDs: viewmodel.selectedCandidatIDs)
                                isDeleting = false
                            }
                        } label: {
                            Text("Delete")
                                .foregroundStyle(Color.black)
                        }
                        
                    }
                }
            })
            .task {
                await viewmodel.loadList()
            }
            .navigationDestination(for: CandidateItem.self) { candidat in
                DetailsView(viewmodel: DetailsViewModel(), candidatID: candidat.id)
            }
            
        }
    }
}

#Preview {
    ListView(viewmodel: ListViewModel())
}


/*
 
 if isEditing {
     Spacer()
     Text("\(viewmodel.selectedCandidatIDs.count) selected")
 }
 
 */
