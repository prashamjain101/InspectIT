//
//  Inspection.swift
//  InspectIT
//
//  Created by Prasham Jain on 20/06/24.
//
import Foundation

struct InspectionResponse: Codable, Identifiable {
    var inspection: Inspection
    var id: Int { inspection.id }
}

extension InspectionResponse {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}


struct Inspection: Codable {
    let area: Area?
    let id: Int
    let inspectionType: InspectionType?
    var survey: Survey?
    var inspectionStatus: InspectionStatus?
}

struct Area: Codable {
    let id: Int
    let name: String
}

struct InspectionType: Codable {
    let access: String
    let id: Int
    let name: String
}

struct Survey: Codable {
    var categories: [Category]?
}

struct Category: Codable {
    let id: Int
    let name: String
    var questions: [Question]?
}

struct Question: Codable {
    let answerChoices: [AnswerChoice]?
    let id: Int
    let name: String
    var selectedAnswerChoiceId: Int?
}

struct AnswerChoice: Codable {
    let id: Int
    let name: String
    let score: Float
}

enum InspectionStatus: String, Codable {
    case draft
    case completed
}
