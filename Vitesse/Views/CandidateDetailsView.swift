//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Alassane Der on 25/11/2024.
//

import SwiftUI

struct CandidateDetailsView: View {
    
    @ObservedObject var viewModel: DetailsViewModel
    
    var candidatID: String
    @State var isUpdating: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if !isUpdating {
                if viewModel.id.isEmpty {
                    ProgressView("Loading Candidate details...")
                } else {
                    ScrollView {
                        HStack {
                            Text("\(viewModel.firstName) \(viewModel.lastName)")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: {
                                Task {
                                    try await viewModel.setAsFavorite(candidatID: candidatID)
                                }
                            }, label: {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(viewModel.isFavorite ? .yellow : Color(hex: "#BDBDBD"))
                            })
                            .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
                        }
                        .padding()
                        
                        DetailsSection(title: "Phone", icon: "phone.fill") {
                            Text(viewModel.phone)
                        }
                        
                        DetailsSection(title: "Email", icon: "envelope.fill") {
                            Text(viewModel.email)
                        }
                        
                        DetailsSection(title: "LinkedInURL", icon: "globe") {
                            if !viewModel.linkedinURL.isEmpty {
                                Link("LinkedIn URL", destination: URL(string: viewModel.linkedinURL)!)
                            } else {
                                Text("No linkedIn URL")
                                    .foregroundStyle(Color(hex: "#BDBDBD").opacity(0.4))
                            }
                        }
                        
                        DetailsSection(title: "Note", icon: nil) {
                            Text(viewModel.note)
                                .padding()
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, minHeight: dynamicHeight(for: viewModel.note))
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .overlay(content: {
                        if !viewModel.message.isEmpty {
                            ToastView(errorMessage: viewModel.message)
                                .onAppear {
                                    viewModel.showTemporaryToast()
                                }
                        }
                    })
                    .padding(.horizontal, 40)
                }
            } else {
                Form(content: {
                    
                    EditableField(title: "Firstname", icon: "person.fill", text: $viewModel.firstName)
                    
                    EditableField(title: "Lastname", icon: "person.fill", text: $viewModel.lastName)
                    
                    EditableField(title: "Phone", icon: "phone.fill", text: $viewModel.phone)
                    
                    EditableField(title: "Email", icon: "envelope.fill", text: $viewModel.email)
                    
                    EditableField(title: "LinkedInURL", icon: "globe", text: $viewModel.linkedinURL)
                    
                    VStack(alignment: .leading) {
                        Text("Note")
                            .fontWeight(.semibold)
                        TextEditor(text: $viewModel.note)
                            .frame(height: dynamicHeight(for: viewModel.note))
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    if isUpdating {
                        isUpdating = false
                    } else {
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if !isUpdating {
                    Button(action: {
                        isUpdating.toggle()
                    }, label: {
                        Text("Update")
                            .foregroundStyle(Color.black)
                    })
                } else {
                    Button(action: {
                        Task {
                            try await viewModel.update(by: candidatID)
                        }
                        isUpdating.toggle()
                    }, label: {
                        Text("Done")
                            .foregroundStyle(Color.black)
                    })
                }
                
            }
        })
        .onAppear {
            Task {
                await viewModel.updateDetailsOnMainThread(for: candidatID)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CandidateDetailsView(viewModel: DetailsViewModel(), candidatID: "1")
    }
}
