//
//  AuthNetworkService.swift
//  InspectIT
//
//  Created by Prasham Jain on 23/06/24.
//

import Foundation

class AuthNetworkService {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }

    func login(email: String, password: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        let body: [String: Any] = ["email": email, "password": password]
        let endpoint = Endpoint(path: Constants.Webservices.Endpoints.login, method: "POST", body: body, headers: ["Content-Type": "application/json"])
        networkManager.request(endpoint, responseType: User.self, completion: completion)
    }

    func register(email: String, password: String, fullname: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        let body: [String: Any] = ["email": email, "password": password, "fullname": ""]
        let endpoint = Endpoint(path: Constants.Webservices.Endpoints.register, method: "POST", body: body, headers: ["Content-Type": "application/json"])
        networkManager.request(endpoint, responseType: User.self, completion: completion)
    }
}

