//
//  MakeItApp.swift
//  MakeIt
//
//  Created by Noah tesson on 03/07/2025.
//

import SwiftUI
import BackgroundTasks
import WidgetKit

@main
struct MakeItApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/*
func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "com.Noah.MakeIt.refresh")
    
    request.earliestBeginDate = Calendar.current.date(
        bySettingHour: 0,   // heure (0 = minuit)
        minute: 33,         // minute (ici 33 min après ton cron 00:23)
        second: 0,
        of: Date()
    )
    
    request.earliestBeginDate = .now.addingTimeInterval(24 * 3600)
    try? BGTaskScheduler.shared.submit(request)
}

func getTasks() async -> [Tasks] {
    var tasks: [Tasks] = []
    
    do {
        let data = try await RequestManager.getTasks()
        
        if data.status == "ok" {
            for task in data.data {
                var newTasks = Tasks.empty()
                newTasks.id = task.id
                newTasks.dataTask = task
                
                if task.system == .Timer {
                    let dataTimer = try await RequestManager.getTimerTasks(id: task.IDSystem)
                    if dataTimer.status == "ok" {
                        newTasks.dataTimerTask = dataTimer.data
                    }
                } else if task.system == .SmartTimer {
                    let dataSmartTimer = try await RequestManager.getSmartTimerTasks(id: task.IDSystem)
                    if dataSmartTimer.status == "ok" {
                        newTasks.dataSmartTimerTask = dataSmartTimer.data
                    }
                }
                
                tasks.append(newTasks)
            }
        }
    } catch {
        print("Erreur connexion: ", error)
    }
    
    return tasks
}


class BackgroundRefreshManager {
    static let shared = BackgroundRefreshManager()

    private init() {
        print("init")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.Noah.MakeIt.refresh", using: nil) { task in
            print("in")
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        print("beofre shedule refresh")
        scheduleAppRefresh()
        print("after shedule refresh")
        
        Task {
            let tasks = await getTasks()
            
            print("tasks: ", tasks)
            
            for taskItem in tasks {
                SharedDataManager.save(task: taskItem)
            }
            
            WidgetCenter.shared.reloadAllTimelines()
            task.setTaskCompleted(success: true) // ✅ Très important
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.Noah.MakeIt.refresh")
        // ⏳ Planifie juste après ton cron (par ex. 00:30)
        
        request.earliestBeginDate = Calendar.current.date(
            bySettingHour: 0,   // heure (0 = minuit)
            minute: 33,         // minute (ici 33 min après ton cron 00:23)
            second: 0,
            of: Date()
        )
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Erreur de planification: \(error)")
        }
    }
    
    func getTasks() async -> [Tasks] {
        var tasks: [Tasks] = []
        
        do {
            let data = try await RequestManager.getTasks()
            
            if data.status == "ok" {
                for task in data.data {
                    var newTasks = Tasks.empty()
                    newTasks.id = task.id
                    newTasks.dataTask = task
                    
                    if task.system == .Timer {
                        let dataTimer = try await RequestManager.getTimerTasks(id: task.IDSystem)
                        if dataTimer.status == "ok" {
                            newTasks.dataTimerTask = dataTimer.data
                        }
                    } else if task.system == .SmartTimer {
                        let dataSmartTimer = try await RequestManager.getSmartTimerTasks(id: task.IDSystem)
                        if dataSmartTimer.status == "ok" {
                            newTasks.dataSmartTimerTask = dataSmartTimer.data
                        }
                    }
                    
                    tasks.append(newTasks)
                }
            }
        } catch {
            print("Erreur connexion: ", error)
        }
        
        return tasks
    }
}

*/
