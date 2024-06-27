//
//  InspectionViewModel.swift
//  InspectIT
//
//  Created by Prasham Jain on 25/06/24.
//

import Foundation

protocol InspectionViewModelDelegate: AnyObject {
    func didUpdateInspectionResponse(shouldRemoveInspectionView: Bool)
    func closeInspectionView()
}

class InspectionViewModel: ObservableObject {
    @Published var inspectionResponse: InspectionResponse?
    @Published var errorMessage: String?
    @Published var showAlert = false
    private let inspectionNetworkService: InspectionNetworkService
    
    weak var delegate: InspectionViewModelDelegate?
    
    init(inspectionNetworkService: InspectionNetworkService = InspectionNetworkService()) {
        self.inspectionNetworkService = inspectionNetworkService
    }
    
    func fetchInspection() {
        inspectionNetworkService.startInspection { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let inspection):
                    self?.inspectionResponse = inspection
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func selectAnswer(for questionId: Int, answerId: Int) {
        guard let inspection = inspectionResponse?.inspection,
              let survey = inspection.survey,
              let categories = survey.categories else {
                  return
              }
        
        for categoryIndex in 0..<categories.count {
            if let questions = categories[categoryIndex].questions {
                for questionIndex in 0..<questions.count {
                    if questions[questionIndex].id == questionId {
                        inspectionResponse?.inspection.survey?.categories?[categoryIndex].questions?[questionIndex].selectedAnswerChoiceId = answerId
                        inspectionResponse?.inspection.inspectionStatus = .draft
                        
                        if let inspectionResponse = inspectionResponse {
                            let inspectionId = Int64(inspection.id)
                            if checkIfInspectionExists(inspectionId: inspectionId) {
                                // Update the DB
                                let dbUpdationResponse = DatabaseManager.shared.updateInspectionResponse(response: inspectionResponse, status: .draft)
                                print("Database \(dbUpdationResponse ? "Updated" : "Not Updated") with InspectionID - \(inspection.id)")
                                delegate?.didUpdateInspectionResponse(shouldRemoveInspectionView: false)
                            } else {
                                // Add In DB
                                let dbAddedResponse = DatabaseManager.shared.insertInspectionResponse(response: inspectionResponse, status: .draft)
                                if let dbAddedResponse = dbAddedResponse {
                                    print("Database with row ID \(dbAddedResponse) with InspectionID - \(inspection.id) has been added successfully")
                                    delegate?.didUpdateInspectionResponse(shouldRemoveInspectionView: false)
                                }
                            }
                        }
                        
                        return
                    }
                }
            }
        }
    }
    
    func checkIfInspectionExists(inspectionId: Int64) -> Bool {
        return DatabaseManager.shared.inspectionExists(inspectionId: inspectionId)
    }
    
    func allQuestionsAnswered() -> Bool {
        guard let categories = inspectionResponse?.inspection.survey?.categories else {
            return false
        }
        
        for category in categories {
            if let questions = category.questions {
                for question in questions {
                    if question.selectedAnswerChoiceId == nil {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func submitInspection() {
        guard allQuestionsAnswered() else {
            errorMessage = "Please answer all the questions before submitting."
            showAlert = true
            return
        }
        
        inspectionNetworkService.submitInspection(inspectionResponse: inspectionResponse) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let inspection):
                    print("Inspection Submitted Successfully with ID -> \(inspection.id)")
                    if var inspectionResponse = self?.inspectionResponse {
                        inspectionResponse.inspection.inspectionStatus = .completed
                        let dbUpdationResponse = DatabaseManager.shared.updateInspectionResponse(response: inspectionResponse, status: .completed)
                        print("Database \(dbUpdationResponse ? "Updated" : "Not Updated") with InspectionID - \(inspection.id)")
                        self?.delegate?.didUpdateInspectionResponse(shouldRemoveInspectionView: true)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}

