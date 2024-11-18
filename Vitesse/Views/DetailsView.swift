//
//  DetailsView.swift
//  Vitesse
//
//  Created by Alassane Der on 10/09/2024.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewmodel: DetailsViewModel
    
    // gradient de couleur
    let gradientStart = Color(hex: "#BDAEC2").opacity(0.9)
    let gradientEnd = Color(hex: "#BDAEC2").opacity(0.4)
    
    var candidatID: String  // pour que la vue accepte un ID d'un candidat
    
    @State var isUpdating: Bool = false
    
    // declaring the dissmiss environment value
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if !isUpdating {
                    if viewmodel.id.isEmpty {
                        ProgressView("Loading Candiat details...")
                    } else {
                        HStack {
                            Text("\(viewmodel.firstName) \(viewmodel.lastName)")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            // boutton clicable par les admin pour mmetre en favoris un candidat
                            Button {
                                Task {
                                    try await viewmodel.setAsFavorite(candidatID: candidatID)
                                    print("Bouton cliqué pour le candate don l'id est \(candidatID)")
                                }
                            } label: {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(viewmodel.isFavorite ? .black : Color(hex: "#BDAEC2"))
                            }
                            
                        }
                        .padding()
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Phone")
                                .fontWeight(.semibold)
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("\(viewmodel.phone)")
                            }
                            Divider()
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email")
                                .fontWeight(.semibold)
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("\(viewmodel.email)")
                            }
                            Divider()
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("LinkedIn URL")
                                .fontWeight(.semibold)
                            HStack {
                                Image(systemName: "globe")
                                if !viewmodel.linkedinURL.isEmpty {
                                    Link("Linkedin URL", destination: URL(string: viewmodel.linkedinURL)!)
                                } else {
                                    Text("No linkedin URL")
                                        .foregroundStyle(Color(hex: "#BDBDBD").opacity(0.4))
                                }
                            }
                            Divider()
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Note")
                                .fontWeight(.semibold)
                            Text(viewmodel.note)
                                .padding()
                                .foregroundStyle(.black)
                                .frame(height: dynamicHeight(for: viewmodel.note))
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }
                        
                }
                
                
            } else {
                VStack(alignment: .leading) {
                    Text("Firstname")
                        .fontWeight(.semibold)
                    HStack(spacing: 15) {
                        Image(systemName: "person.fill")
                        TextField("firstname", text: $viewmodel.firstName)
                    }
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#BDBDBD").opacity(0.2)))
                }
                VStack(alignment: .leading) {
                    Text("Lastname")
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "person.fill")
                        TextField("Lastname", text: $viewmodel.lastName)
                    }
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#BDBDBD").opacity(0.2)))
                }
                VStack(alignment: .leading) {
                    Text("Phone")
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "phone.fill")
                        TextField("Phone", text: $viewmodel.phone)
                    }
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#BDBDBD").opacity(0.2)))
                    
                }
                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "envelope.fill")
                        TextField("Email", text: $viewmodel.email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                    }
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#BDBDBD").opacity(0.2)))
                }
                VStack(alignment: .leading) {
                    Text("LinkedIn URL")
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "globe")
                        TextField("LinkedIn URL", text: $viewmodel.linkedinURL)
                    }
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#BDBDBD").opacity(0.2)))
                }
                VStack(alignment: .leading) {
                    Text("Note")
                        .fontWeight(.semibold)
                    TextEditor(text: $viewmodel.note)
                        .frame(height: dynamicHeight(for: viewmodel.note))
//                        .colorMultiply(Color.gray.opacity(0.2))
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .animation(.easeInOut, value: viewmodel.note)
                }
                
                // MARK: to update details
                Button(action: {
                    Task {
                        try await viewmodel.update(by:candidatID)
                    }
                    isUpdating = false
                }){
                    Text("Update")
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                }
                .padding()
            }// here end else
        }   //VSTACK END
        .padding(.horizontal, 40)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // calling the dismiss() to perform the dismissal
                    if isUpdating {
                        isUpdating = false
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12).weight(.bold))
                        .foregroundStyle(Color.black)
                        .padding(10)
                        .background(Circle().fill(Color(hex: "#BDBDBD").opacity(0.5)))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isUpdating.toggle()
                } label: {
                    Text(!isUpdating ? "Update" : "")
                        .foregroundStyle(Color.black)
                }
            }
            
        })
        .task {
            await viewmodel.updateDetailsOnMainThread(for: candidatID)
        }
    }
}

#Preview {
    DetailsView(viewmodel: DetailsViewModel(), candidatID: "fakeID")
}
