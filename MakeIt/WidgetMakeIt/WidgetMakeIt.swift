//
//  WidgetMakeIt.swift
//  WidgetMakeIt
//
//  Created by Noah tesson on 03/07/2025.
//

import WidgetKit
import SwiftUI

/*
struct TaskProvider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(date: Date(), tasks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let tasks = SharedDataManager.load()
        let entry = TaskEntry(date: Date(), tasks: tasks)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let tasks = SharedDataManager.load()
        let entry = TaskEntry(date: Date(), tasks: tasks)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300))) // refresh every 5 mins
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date
    let tasks: [Tasks]
}

struct TaskWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: TaskProvider.Entry
    var url = "makeIt://modalcreatetask"

    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        default:
            Text("Non supporté")
        }
    }
    
    var smallView: some View {
        VStack() {
            if entry.tasks.isEmpty {
                VStack {
                    Image(systemName: "plus")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.blue)
                        )
                    Text("Ajouter une task")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(alignment: .leading, spacing: 8) {

                    ForEach(entry.tasks.prefix(4)) { task in
                        
                        if (task.dataSmartTimerTask.currentSeries == task.dataSmartTimerTask.nbSeries) {
                            HStack {
                                
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 18)
                                        .foregroundColor(.green)
                                }
                                
                                ZStack {
                                    HStack {
                                        Text(task.dataTask.name)
                                            .font(.system(size: 15, weight: .semibold))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                        
                                        Spacer()
                                        
                                        Text(makeString(task: task))
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                            .foregroundStyle(.gray)
                                            //.frame(alignment: .bottom)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    //.background(.red)
                                    
                                    Rectangle()
                                        .fill(Color("WidgetBackgroundInverse"))
                                        .frame(height: 3)
                                    
                                }
                            }
                        } else {
                            
                            HStack {
                                Text(task.dataTask.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.3)
                                
                                Spacer()
                                
                                Text(makeString(task: task))
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray)
                                    //.frame(alignment: .bottom)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            //.background(.red)
                        }
                    
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .widgetURL(URL(string: url))
    }
    
    var mediumView: some View {
        VStack(spacing: 8) {
            /*
            if entry.tasks.isEmpty {
                VStack {
                    Image(systemName: "plus")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.blue)
                        )
                    Text("Ajouter une task")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.3))
                                .frame(height: 80)
                                .overlay(
                                    Text(item)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                )
                        }
                    }
                    .padding()
                }
                /*
                VStack(alignment: .leading, spacing: 8) {
                    // Liste des tâches
                    
                    ForEach(entry.tasks.prefix(3)) { task in
                        TaskRow(task: task)
                    }
                    
                }
                .padding(16)
                .cornerRadius(16)
                 */
            }
             */
        }
        .widgetURL(URL(string: url))
    }
    
    
    func makeString(task: Tasks) -> String {

        if (task.dataTask.system == .Timer) {
            return  "\(task.dataTimerTask.nbHours)h\(task.dataTimerTask.nbMinutes)m\(task.dataTimerTask.nbSeconds)s"
            
        } else if (task.dataTask.system == .SmartTimer) {

            return "\((task.dataSmartTimerTask.currentSeries * task.dataSmartTimerTask.nbRep) + task.dataSmartTimerTask.currentRep)/\(task.dataSmartTimerTask.nbSeries * task.dataSmartTimerTask.nbRep)"
        } else {
            return ""
        }
    }
}

struct WidgetMakeIt: Widget {
    let kind: String = "MonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TaskProvider()) { entry in
            TaskWidgetEntryView(entry: entry)
                .containerBackground(Color("WidgetBackground"), for: .widget)
        }
        .configurationDisplayName("Mes Tâches")
        .description("Affiche les DataTasks récents.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    WidgetMakeIt()
} timeline: {
    TaskEntry(date: .now, tasks: [taskFill, taskFill2])
    TaskEntry(date: .now, tasks: [])
}

/*
#Preview(as: .systemMedium) {
    WidgetMakeIt()
} timeline: {
    TaskEntry(date: .now, tasks: [Tasks.empty(), Tasks.empty(), Tasks.empty(), Tasks.empty(), Tasks.empty(), Tasks.empty()])
    TaskEntry(date: .now, tasks: [])
}
*/


var taskFill = Tasks(
    id: 1,
    dataTask: DataTask(
        id: 1,
        type: .PushUp,
        system: .SmartTimer,
        IDSystem: -1,
        name: "Pompe",
        recurrence: .Chaquejour,
        endDate: nil,
        inARow: 0
    ),
    dataTimerTask: DataTimerTask(id: 0, nbHours: 0, nbMinutes: 0, nbSeconds: 0),
    dataSmartTimerTask: DataSmartTimerTask(id: 0, nbRep: 0, nbSeries: 0, currentRep: 0, currentSeries: 0, timeRecup: 0)
)

var taskFill2 = Tasks(
    id: 2,
    dataTask: DataTask(
        id: 2,
        type: .PushUp,
        system: .SmartTimer,
        IDSystem: -1,
        name: "autre",
        recurrence: .Chaquejour,
        endDate: nil,
        inARow: 0
    ),
    dataTimerTask: DataTimerTask(id: 0, nbHours: 0, nbMinutes: 0, nbSeconds: 0),
    dataSmartTimerTask: DataSmartTimerTask(id: 0, nbRep: 5, nbSeries: 5, currentRep: 0, currentSeries: 5, timeRecup: 0)
)

*/
