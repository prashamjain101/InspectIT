//
//  AuthViewModelTests.swift
//  InspectITTests
//
//  Created by Prasham Jain on 27/06/24.
//

import XCTest
@testable import InspectIT

// Mock NetworkManaging
class MockNetworkManager: NetworkManaging {
    var result: Result<User, NetworkError>?
    
    func request<T>(_ endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let result = result as? Result<T, NetworkError> else {
            fatalError("Result type mismatch")
        }
        completion(result)
    }
}

class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockNetworkManager: MockNetworkManager!
    var authNetworkService: AuthNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        authNetworkService = AuthNetworkService(networkManager: mockNetworkManager)
        viewModel = AuthViewModel(authNetworkService: authNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        authNetworkService = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.email, "charlie@gmail.com")
        XCTAssertEqual(viewModel.password, "123456")
        XCTAssertEqual(viewModel.confirmPassword, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertFalse(viewModel.showAlert)
    }

    func testSuccessfulLogin() {
        let expectation = XCTestExpectation(description: "Login success")
        let mockUser = User(fullname: "Test User", email: "test@example.com", password: "123456")
        mockNetworkManager.result = .success(mockUser)
        
        viewModel.login()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.isAuthenticated)
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertFalse(self.viewModel.showAlert)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedLogin() {
        let expectation = XCTestExpectation(description: "Login failure")
        mockNetworkManager.result = .failure(.badResponse)
        
        viewModel.login()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isAuthenticated)
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.showAlert)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testSuccessfulRegistration() {
        let expectation = XCTestExpectation(description: "Registration success")
        let mockUser = User(fullname: "Test User", email: "test@example.com", password: "123456")
        mockNetworkManager.result = .success(mockUser)
        
        viewModel.register()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.isAuthenticated)
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertFalse(self.viewModel.showAlert)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedRegistration() {
        let expectation = XCTestExpectation(description: "Registration failure")
        mockNetworkManager.result = .failure(.badResponse)
        
        viewModel.register()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isAuthenticated)
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.showAlert)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
