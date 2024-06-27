//
//  SignUpView.swift
//  InspectIT
//
//  Created by Prasham Jain on 21/06/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Enter Your Personal Information")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 50)
                    TextField("Enter your name", text: $viewModel.username)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                    TextField("Enter your email", text: $viewModel.email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Enter password", text: $viewModel.password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    SecureField("Enter confirm password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    
                }
                .navigationBarItems(leading: Button(action: {
                    // Handle back action
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                })
                .navigationBarTitle("", displayMode: .inline)
                Spacer()
                Button(action: {
                    viewModel.register()
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
            .onChange(of: viewModel.errorMessage) { _ in
                if viewModel.errorMessage != nil {
                    viewModel.showAlert = true
                }
            }
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AuthViewModel()
        SignUpView(viewModel: viewModel)
    }
}
