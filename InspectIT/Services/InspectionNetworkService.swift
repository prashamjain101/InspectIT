//
//  InspectionNetworkService.swift
//  InspectIT
//
//  Created by Prasham Jain on 25/06/24.
//

import Foundation

class InspectionNetworkService {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func startInspection(completion: @escaping (Result<InspectionResponse, NetworkError>) -> Void) {
        let endpoint = Endpoint(path: Constants.Webservices.Endpoints.startInspection, method: "GET", headers: ["Content-Type": "application/json"])
        networkManager.request(endpoint, responseType: InspectionResponse.self, completion: completion)
    }
    
    func submitInspection(inspectionResponse: InspectionResponse?, completion: @escaping (Result<InspectionResponse, NetworkError>) -> Void) {
        guard let body = inspectionResponse?.toDictionary() else {
            completion(.failure(.encodingError))
            return
        }
        let endpoint = Endpoint(path: Constants.Webservices.Endpoints.submitInspection, method: "POST", body: body, headers: ["Content-Type": "application/json"])
        networkManager.request(endpoint, responseType: InspectionResponse.self, completion: completion)
    }
}

