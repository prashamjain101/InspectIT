//
//  AuthViewModel.swift
//  InspectIT
//
//  Created by Prasham Jain on 23/06/24.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var username: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var showAlert: Bool = false

    private let authNetworkService: AuthNetworkService

    init(authNetworkService: AuthNetworkService = AuthNetworkService()) {
        self.authNetworkService = authNetworkService
    }

    func login() {
        authNetworkService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    func register() {
        authNetworkService.register(email: email, password: password, fullname: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}

