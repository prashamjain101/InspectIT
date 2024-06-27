//
//  LoginView.swift
//  InspectIT
//
//  Created by Prasham Jain on 21/06/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                LoginHeaderView()
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
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle forgot password action
                    }) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                Button(action: {
                    // Handle login action
                    viewModel.login()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(color: .gray, radius: 4, x: 0, y: 4)
                }
                
                Text("Or Login with")
                    .padding(.top, 20)
                HStack {
                    Button(action: {
                        viewModel.errorMessage = "This Social login is not yet implemented."
                        viewModel.showAlert = true
                    }) {
                        Image(systemName: "f.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        viewModel.errorMessage = "This Social login is not yet implemented."
                        viewModel.showAlert = true
                    }) {
                        Image(systemName: "g.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                    }
                    Button(action: {
                        viewModel.errorMessage = "This Social login is not yet implemented."
                        viewModel.showAlert = true
                    }) {
                        Image(systemName: "applelogo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                }
                
                .padding(.top, 10)
                Spacer()
                HStack {
                    Text("Don’t have an account?")
                    NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                        Text("Register")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 20)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("Ok"), action: {
                    viewModel.errorMessage = nil
                    viewModel.showAlert = false
                }))
            }
            .onChange(of: viewModel.errorMessage) { _ in
                if viewModel.errorMessage != nil {
                    viewModel.showAlert = true
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LoginHeaderView: View {
    var body: some View {
        Spacer()
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
        Text("InspectIT")
            .font(.largeTitle)
            .fontWeight(.bold)
        Text("Login to continue using the app")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.bottom, 20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AuthViewModel()
        LoginView(viewModel: viewModel)
    }
}

