//
//  WelcomeView.swift
//  InspectIT
//
//  Created by Prasham Jain on 20/06/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @StateObject private var reachability = Reachability()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            if viewModel.isAuthenticated {
                HomeView()
                    .environmentObject(reachability)
            } else {
                
                VStack {
                    Spacer()
                    Image("AppLogo")
                    Text("InspectIT")
                        .font(.largeTitle)
                        .bold()
                    Text("Everything you need is in one place")
                        .font(.subheadline)
                    Spacer()
                    NavigationLink(destination: LoginView(viewModel: viewModel)) {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: screenSize.width - 80)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(color: .blue, radius: 4.0, x: 0, y: 2)
                    }
                    NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                        Text("Register")
                            .foregroundColor(.white)
                            .frame(width: screenSize.width - 80)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(color: .blue, radius: 4.0, x: 0, y: 2)
                    }
                }
            }
        }
        .environmentObject(reachability)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
