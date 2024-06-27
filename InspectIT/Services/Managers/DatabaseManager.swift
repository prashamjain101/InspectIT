//
//  DatabaseManager.swift
//  InspectIT
//
//  Created by Prasham Jain on 25/06/24.
//

import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private let dbConnection: Connection?
    
    private let inspectionResponses = Table("inspection_responses")
    private let id = Expression<Int64>("id")
    private let inspectionResponseData = Expression<String>("inspection_response_data")
    private let inspectionID = Expression<Int64>("inspection_id")
    private let status = Expression<String>("status")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            print("DatabasePath:---> \(path)")
            dbConnection = try Connection("\(path)/db.sqlite3")
            if !isTableExists(tableName: "inspection_responses") {
                createTable()
            }
        } catch {
            dbConnection = nil
            print("Error connecting to database: \(error.localizedDescription)")
        }
    }
    
    private func createTable() {
        do {
            try dbConnection?.run(inspectionResponses.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(inspectionResponseData)
                table.column(inspectionID)
                table.column(status)
            })
        } catch {
            print("Error creating table: \(error.localizedDescription)")
        }
    }
    
    private func isTableExists(tableName: String) -> Bool {
        do {
            let tables = try dbConnection?.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?", tableName)
            return try tables?.next() != nil
        } catch {
            print("Error checking if table exists: \(error.localizedDescription)")
            return false
        }
    }
    
    func insertInspectionResponse(response: InspectionResponse, status: InspectionStatus) -> Int64? {
        do {
            let inspectID = Int64(response.id)
            let jsonData = try JSONEncoder().encode(response)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let insert = inspectionResponses.insert(inspectionResponseData <- jsonString, self.inspectionID <- inspectID, self.status <- status.rawValue)
            let rowId = try dbConnection?.run(insert)
            return rowId
        } catch {
            print("Error inserting inspection response: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllInspectionResponses(statusFilter: InspectionStatus? = nil) -> [InspectionResponse] {
        var responses = [InspectionResponse]()
        do {
            var query = inspectionResponses
            if let statusFilter = statusFilter {
                query = query.filter(status == statusFilter.rawValue)
            }
            
            for responseRow in try dbConnection!.prepare(query) {
                let jsonString = responseRow[inspectionResponseData]
                let jsonData = jsonString.data(using: .utf8)!
                let decodedResponse = try JSONDecoder().decode(InspectionResponse.self, from: jsonData)
                responses.append(decodedResponse)
            }
        } catch {
            print("Error retrieving inspection responses: \(error.localizedDescription)")
        }
        return responses
    }
    
    func updateInspectionResponse(response: InspectionResponse, status: InspectionStatus) -> Bool {
        
        let responseId = Int64(response.inspection.id)
        
        let responseToUpdate = inspectionResponses.filter(inspectionID == responseId)
        do {
            let jsonData = try JSONEncoder().encode(response)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try dbConnection?.run(responseToUpdate.update(inspectionResponseData <- jsonString, self.status <- status.rawValue))
            return true
        } catch {
            print("Error updating inspection response: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteInspectionResponse(responseId: Int64) -> Bool {
        let responseToDelete = inspectionResponses.filter(id == responseId)
        do {
            try dbConnection?.run(responseToDelete.delete())
            return true
        } catch {
            print("Error deleting inspection response: \(error.localizedDescription)")
            return false
        }
    }
    
    func inspectionExists(inspectionId: Int64) -> Bool {
        do {
            print("Checking if inspection exists with ID: \(inspectionId)")
            let query = inspectionResponses.filter(self.inspectionID == inspectionId)
            let count = try dbConnection?.scalar(query.count) ?? 0
            print("Inspection count for ID \(inspectionId): \(count)")
            return count > 0
        } catch {
            print("Error checking if inspection exists: \(error.localizedDescription)")
        }
        return false
    }
}
