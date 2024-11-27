//
//  ListView.swift
//  Vitesse
//
//  Created by Alassane Der on 08/09/2024.
//


import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel
    
    @State var isEditing: Bool = false
    @State var isDeleting: Bool = false
    
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        
        NavigationStack {
            // MARK: search Bar
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title)
                        TextField("Search candidates", text: $viewModel.searchText)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .frame(height: 45)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
                    }
                    if viewModel.issearching {
                        Button {
                            viewModel.searchText = ""
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
            
            if !viewModel.loadListMessage.isEmpty {
                Text("\(viewModel.loadListMessage)")
            }
            // MARK: liste des candidats
            List {
                ForEach(viewModel.applyFilter(), id: \.id) { candidat in
                    HStack {
                        if !isEditing {
                            NavigationLink(value: candidat) {
                                HStack {
                                    Text("\(viewModel.getFirstLetter(item: candidat))")
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
                        } else {
                            Button {
                                // selection de candidats
                                viewModel.selectCandidates(by: candidat)
                            } label: {
                                HStack {
                                    Image(systemName: viewModel.selectedCandidatIDs.contains(candidat) ? "checkmark.circle.fill" : "circle")
                                    Text("\(viewModel.getFirstLetter(item: candidat))")
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
                await viewModel.loadList()
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
                            viewModel.isSelectingFavorits.toggle()
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(viewModel.isSelectingFavorits ? Color.black : Color(hex: "#BDBDBD").opacity(0.2))
                        }
                        
                    }
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isEditing = false
                            viewModel.selectedCandidatIDs = []
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(Color.black)
                        }
                        
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showConfirmation = true
                        } label: {
                            Text("Delete")
                                .foregroundStyle(Color.black)
                        }
                        
                    }
                }
            })
            .task {
                await viewModel.loadList()
            }
            .alert("Are you sure?", isPresented: $showConfirmation, actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        isDeleting = true
                        await viewModel.deleteCandidateAndReloadList(selectedCandidatIDs: viewModel.selectedCandidatIDs)
                        isDeleting = false
                    }
                }
            }, message: {
                Text("This action is irreversible and the item will be permanently deleted.")
            })
            .navigationDestination(for: CandidateItem.self) { candidat in
                CandidateDetailsView(viewModel: DetailsViewModel(), candidatID: candidat.id)
            }
            
        }
    }
}

#Preview {
    ListView(viewModel: ListViewModel())
}

/*
 
 .overlay {
     if !viewModel.deleteCandidateMessage.isEmpty {
         ToastView(errorMessage: viewModel.deleteCandidateMessage)
             .onAppear {
                 viewModel.showTemporaryToast()
             }
     }
 }
 
 */
