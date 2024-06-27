//
//  Constants.swift
//  InspectIT
//
//  Created by Prasham Jain on 22/06/24.
//

import Foundation

struct Constants {
    struct Webservices {
        static let baseURL = "http://localhost:5001"
        struct Endpoints {
            static let login = "/api/login"
            static let register = "/api/register"
            static let startInspection = "/api/inspections/start"
            static let submitInspection = "/api/inspections/submit"
        }
    }
    
}

