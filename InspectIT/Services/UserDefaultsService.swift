//
//  UserDefaultsService.swift
//  InspectIT
//
//  Created by Prasham Jain on 22/06/24.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "loggedInUser"
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
        }
    }
    
    func loadUser() -> User? {
        if let savedUserData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: savedUserData) {
            return user
        }
        return nil
    }
    
    func clearUser() {
        userDefaults.removeObject(forKey: userKey)
    }
}

