//
//  api.swift
//  MakeIt
//
//  Created by Noah tesson on 04/11/2025.
//

import SwiftUI
import Foundation
import Combine

class Api {
    static let baseURL = URL(string: false ? "replace it (local server if false)" : "replace it (cloudfloud server if false)")!

    private static let encoder: JSONEncoder = {
         let e = JSONEncoder()
         e.dateEncodingStrategy = .iso8601
         return e
     }()
     
     private static let decoder: JSONDecoder = {
         let d = JSONDecoder()
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // correspond au format de ton serveur
         d.dateDecodingStrategy = .formatted(formatter)
         return d
     }()
    

    // ----------------------------------------------------------------------
    // MARK: - Generic request
    // ----------------------------------------------------------------------
    private static func request<T: Decodable>(endpoint: String, method: String = "GET", body: Encodable? = nil) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(T.self, from: data)
    }
    
    private static func requestNoReturn(endpoint: String, method: String = "GET", body: Encodable? = nil) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }

        let (_, response) = try await URLSession.shared.data(for: request)
        guard
            let http = response as? HTTPURLResponse,
            (200..<300).contains(http.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
    }
    
    
    // ----------------------------------------------------------------------
    // MARK: - GROUP
    // ----------------------------------------------------------------------
    
    static func getGroups() async throws -> [GroupMakeIt] {
        try await request(endpoint: "groups")
    }
    
    static func getGroups(id: Int) async throws -> [GroupMakeIt] {
        try await request(endpoint: "groups/\(id)")
    }
    
    static func createGroup(name: String, color: String) async throws -> Int {
        struct Body: Codable {
            let name: String;
            let color: String;
        };
        let body = Body(
            name: name,
            color: color,
        )
        return try await request(endpoint: "groups", method: "POST", body: body)
    }

    static func updateGroup(_ group: GroupMakeIt) async throws -> GroupMakeIt {
        try await request(endpoint: "groups/\(group.id)", method: "PUT", body: group)
    }

    static func deleteGroup(id: Int) async throws {
        try await requestNoReturn(endpoint: "groups/\(id)", method: "DELETE")
    }

    
    // ----------------------------------------------------------------------
    // MARK: - TASK
    // ----------------------------------------------------------------------
    static func getTasks() async throws -> [TaskMakeIt] {
        try await request(endpoint: "task")
    }
    
    static func getTasksByGroupId(groupId: Int) async throws -> [TaskMakeIt] {
        try await request(endpoint: "taskByGroup/\(groupId)")
    }
    
    static func deleteTask(id: Int) async throws {
        try await requestNoReturn(endpoint: "task/\(id)", method: "DELETE")
    }
    
    static func putTask(_ task: TaskMakeIt) async throws -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        struct Body: Codable {
            let system: String;
            let name: String;
            let recurrence: String;
        };
        let body = Body(
            system: task.system.rawValue,
            name: task.name,
            recurrence: task.recurrence.rawValue,
        )
        return try await request(endpoint: "task/\(String(describing: task.id))", method: "PUT", body: body)
    }

    
    // ----------------------------------------------------------------------
    // MARK: - NONE
    // ----------------------------------------------------------------------
    static func postNone(groupId: Int, name: String, recurrence: RecurrenceMakeIt) async throws -> Int {
        struct Body: Codable {
            let groupId: Int;
            let name: String;
            let recurrence: String;
        }
        let body = Body(groupId: groupId, name: name, recurrence: recurrence.rawValue)
        return try await request(endpoint: "none", method: "POST", body: body)
    }
    
    
    // ----------------------------------------------------------------------
    // MARK: - TIMER
    // ----------------------------------------------------------------------
    static func postTimer(groupId: Int, name: String, recurrence: RecurrenceMakeIt, nbHours: Int, nbMinutes: Int, nbSeconds: Int) async throws -> Int {
        struct Body: Codable {
            let groupId: Int;
            let name: String;
            let recurrence: String;
            let nbHours: Int;
            let nbMinutes: Int;
            let nbSeconds: Int;
        }
        let body = Body(groupId: groupId, name: name, recurrence: recurrence.rawValue, nbHours: nbHours, nbMinutes: nbMinutes, nbSeconds: nbSeconds)
        return try await request(endpoint: "timer", method: "POST", body: body)
    }
    
    static func getTimer(id: Int) async throws -> TimerMakeIt {
        return try await request(endpoint: "timer/\(id)")
    }
    
    static func putTimer(_ timer: TimerMakeIt) async throws -> Int {
        struct Body: Codable {
            let nbHours: String;
            let nbMinutes: String;
            let nbSeconds: String;
        }
        let body = Body(nbHours: String(timer.nbHours), nbMinutes: String(timer.nbMinutes), nbSeconds: String(timer.nbSeconds))
        return try await request(endpoint: "smartTimer/\(String(describing: timer.id))", method: "DELETE", body: body)
    }
    
    
    // ----------------------------------------------------------------------
    // MARK: - SMART TIMER
    // ----------------------------------------------------------------------
    static func postSmartTimer(groupId: Int, name: String, recurrence: RecurrenceMakeIt, nbRep: Int, nbSeries: Int, timeRecup: Int) async throws -> Int {
        struct Body: Codable {
            let groupId: Int;
            let name: String;
            let recurrence: String;
            let nbRep: Int;
            let nbSeries: Int;
            let timeRecup: Int;
        }
        let body = Body(groupId: groupId, name: name, recurrence: recurrence.rawValue, nbRep: nbRep, nbSeries: nbSeries, timeRecup: timeRecup)
        return try await request(endpoint: "smartTimer", method: "POST", body: body)
    }
    
    static func getSmartTimer(id: Int) async throws -> SmartTimerMakeIt {
        return try await request(endpoint: "smartTimer/\(id)")
    }
    
    static func putSmartTimer(_ smart_timer: SmartTimerMakeIt) async throws -> Int {
        struct Body: Codable {
            let currentRep: String;
            let currentSeries: String;
        }
        let body = Body(currentRep: String(smart_timer.currentRep), currentSeries: String(smart_timer.currentSeries))
        
        guard let id = smart_timer.id else {
            throw URLError(.badURL)
        }
        return try await request(endpoint: "smartTimer/\(id)", method: "PUT", body: body)
    }
}


fileprivate struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
