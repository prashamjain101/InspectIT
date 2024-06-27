//
//  HomeViewModel.swift
//  InspectIT
//
//  Created by Prasham Jain on 25/06/24.
//

import SwiftUI

class HomeViewModel: ObservableObject, InspectionViewModelDelegate {
    
    @Published var selectedSegment = 0
    @Published var showNetworkStatus = false
    @Published var showInspectionView = false
    @Published var inspectionResponses: [InspectionResponse] = []
    @Published var selectedResponse: InspectionResponse? = nil
    
    init() {
        fetchInspectionResponses()
    }

    @objc private func networkStatusChanged() {
        showNetworkStatusTemporarily()
    }

    private func showNetworkStatusTemporarily() {
        withAnimation {
            showNetworkStatus = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                self.showNetworkStatus = false
            }
        }
    }

    func fetchInspectionResponses(for status: InspectionStatus? = nil) {
        inspectionResponses = DatabaseManager.shared.getAllInspectionResponses(statusFilter: status)
        print("InspectionResponses--->>>\(inspectionResponses)")
    }

    func deleteInspectionResponse(responseId: Int64) {
        if DatabaseManager.shared.deleteInspectionResponse(responseId: responseId) {
            fetchInspectionResponses() // Refresh the data
        }
    }
    
    func didUpdateInspectionResponse(shouldRemoveInspectionView: Bool) {
        fetchInspectionResponses(for: selectedSegment == 0 ? .draft : .completed)
        if shouldRemoveInspectionView {
            showInspectionView = false
        }
    }
    
    func closeInspectionView() {
        selectedResponse = nil
        showInspectionView = false
    }
}
