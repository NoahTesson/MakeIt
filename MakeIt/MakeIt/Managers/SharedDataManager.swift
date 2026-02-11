//
//  PinnedTasksStorage.swift
//  SportTasks
//
//  Created by Noah tesson on 12/06/2025.
//

import Foundation
/*
struct SharedDataManager {
    static let suiteName = "group.com.Noah.MakeIt.batch"
    static let key = "DataTasks"

    private static var userDefaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }

    static func save(task: Tasks) {
        guard let userDefaults = userDefaults else { return }

        // 1️⃣ Charger les tâches existantes
        var existingTasks = load()

        // 2️⃣ Ajouter la nouvelle tâche
        existingTasks.append(task)

        // 3️⃣ Encoder et sauvegarder
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(existingTasks) {
            userDefaults.set(encoded, forKey: key)
        }
    }

    static func load() -> [Tasks] {
        guard let userDefaults = userDefaults else { return [] }
        if let savedData = userDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let loadedTasks = try? decoder.decode([Tasks].self, from: savedData) {
                return loadedTasks
            }
        }
        return []
    }
    
    static func contains(task: Tasks) -> Bool {
        let _ = load()
        return true//existingTasks.contains { $0.dataTask.id == task.dataTask.id }
    }
    
    static func remove(task: Tasks) {
        var tasks = load()
        tasks.removeAll { $0.id == task.id }

        // Sauvegarder la liste mise à jour en remplaçant tout
        guard let userDefaults = userDefaults else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            userDefaults.set(encoded, forKey: key)
        }
    }
}

*/
