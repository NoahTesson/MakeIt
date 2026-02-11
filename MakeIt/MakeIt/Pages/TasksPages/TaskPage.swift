//
//  TaskPage.swift
//  MakeIt
//
//  Created by Noah tesson on 23/07/2025.
//

import SwiftUI
/*
struct TaskPage: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var task: Tasks
    
    @State private var selectedMenu: String = "Exercice"
    @State private var isExerciceStart: Bool = false
    
    @State private var toDisplay = "Exercice"
    @State private var isEdit = false
    
    @State private var newName = ""
    @State private var newRep = ""
    @State private var newSeries = ""
    @State private var newTimeRecup = ""
    @State private var newTypeRec: Recurrence = .Chaquejour
    
    
    var body: some View {
        VStack(spacing: 0) {
            if (isExerciceStart) {
                SmartTimerView(smartTimer: SmartTimer(smartTimerTask: task.dataSmartTimerTask))
            } else {
                HStack {
                    Text(selectedMenu)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                inARowSection()
                
                if (task.dataTask.system == .None) {
                    SystemNoneSection
                } else if (task.dataTask.system == .Timer) {
                    SystemTimerSection
                } else if (task.dataTask.system == .SmartTimer) {
                    SystemSmartTimerSection
                }
                
                Spacer()
                
                buttonstartexercicesection
                
            }
        }
        .padding(.top, 25)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if (isEdit) {
                    Button(action: {
                        isEdit.toggle()
                        newName = ""
                        newRep = ""
                        newSeries = ""
                        newTimeRecup = ""
                        task.dataTask.recurrence = newTypeRec
                    }) {
                        VStack {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: { dismiss() }) {
                        VStack(alignment: .leading, spacing: 4) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .frame(width: 20, height: 8)
                            
                            Text("Back")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            ToolbarItem(placement: .principal) {
                Text(task.dataTask.name)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if (isEdit) {
                    Button(action: {
                        
                        sendUpdTask()
                        
                        isEdit.toggle()
                    }) {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.green)
                    }
                } else {
                    Menu {
                        Button(action: { isEdit.toggle() }) {
                            Text("Edit")
                        }
                        Button(action: { selectedMenu = "Exercice" }) {
                            Text("Exercice")
                        }
                        Button(action: { selectedMenu = "Configuration" }) {
                            Text("Configuration")
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .frame(width: 15, height: 8)
                            
                            Text("Menu")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
    
    // MARK: - System None Section
    private var SystemNoneSection: some View {
        VStack {
            if (selectedMenu == "Exercice") {
                
            } else if (selectedMenu == "Configuration") {
                typeSection
            }
        }
    }
    
    
    // MARK: - System Timer Section
    private var SystemTimerSection: some View {
        VStack {
            if (selectedMenu == "Exercice") {
                VStack(spacing: 15) {
                    
                    VStack(spacing: 12) {
                        Image(systemName: "target")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        Text("Objectif")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text("\(task.dataTimerTask.nbHours)h \(task.dataTimerTask.nbMinutes)m \(task.dataTimerTask.nbSeconds)S")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("MyAdaptiveColorInverse"))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 25)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                    )
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("MyAdaptiveColor").opacity(0.9))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("StrokeGray"), lineWidth: 1)
                )
            } else if (selectedMenu == "Configuration") {
                typeSection
                DataSectionTimer
            }
        }
        .padding()
    }
    
    // MARK: - System SmartTimer Section
    private var SystemSmartTimerSection: some View {
        VStack {
            if (selectedMenu == "Exercice") {
                CurrentStateSection
            } else if (selectedMenu == "Configuration") {
                typeSection
                DataSectionSmartTimer
            }
        }
        .padding()
    }

    // MARK: - in a row Section
    func inARowSection() -> some View {
        return (
            VStack {
                HStack {
                    Text("Day in a row")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Text"))
                    Spacer()
                    Text("1 week")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Text"))
                }
                //.background(.blue)
                
                HStack {
                    ForEach (1...7, id: \.self) { number in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(Color("StrokeGray"), lineWidth: 2)
                            .frame(height: 10)
                    }
                }
                //.background(.green)
            }
            .padding()
            .frame(maxWidth: .infinity)
            //.background(.red)
        )
    }
    
    // MARK: - type section
    private var typeSection: some View {
        HStack {
            
            VStack {
                HStack {
                    Text("Recurrence")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack(spacing: 15) {
                    //task.dataTask.type.textStyle
                    
                    if (isEdit) {
                        Menu {
                            ForEach(Recurrence.allCases) { type in
                                Button {
                                    newTypeRec = task.dataTask.recurrence
                                    task.dataTask.recurrence = type
                                } label: {
                                    type.textStyle
                                }
                            }
                        } label: {
                            task.dataTask.recurrence.textStyleUpd
                        }
                    } else {
                        task.dataTask.recurrence.textStyle
                    }
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("StrokeGray"),lineWidth: 1)
            )
            
            Spacer()
            
            VStack {
                HStack {
                    Text("Type")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack(spacing: 15) {
                    task.dataTask.type.textStyle()
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("StrokeGray"),lineWidth: 1)
            )
        }
    }
    
    // MARK: - Actual State Section
    private var CurrentStateSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("État actuel")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            HStack(spacing: 12) {
                // Répétitions actuelles
                VStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle")
                        .font(.title3)
                        .foregroundColor(.orange)
                    
                    Text("Rép actuel")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("\(task.dataSmartTimerTask.currentRep)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // Séries actuelles
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.title3)
                        .foregroundColor(.green)
                    
                    Text("Series actuel")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("\(task.dataSmartTimerTask.currentSeries)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            VStack(spacing: 12) {
                Image(systemName: "target")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text("Objectif")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text(makeString(task: task.dataSmartTimerTask))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("MyAdaptiveColorInverse"))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 25)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("MyAdaptiveColor").opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("StrokeGray"), lineWidth: 1)
        )
    }
    
    // MARK: - Data Section
    private var DataSectionTimer: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Configuration")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            DataSectionTwoTimer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("MyAdaptiveColor").opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Data Section two
    private var DataSectionTwoTimer: some View {
        HStack(spacing: 15) {
            VStack(spacing: 8) {
                Image(systemName: "h.square")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Hours")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if (isEdit) {
                    TextField("", text: $newRep)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                } else {
                    Text("\(task.dataTimerTask.nbHours)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Carte Séries
            VStack(spacing: 8) {
                
                Image(systemName: "m.square")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Minutes")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if (isEdit) {
                    TextField("", text: $newSeries)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                } else {
                    Text("\(task.dataTimerTask.nbMinutes)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Temps de récupération
            VStack(spacing: 8) {
                Image(systemName: "s.square")
                    .font(.title3)
                    .foregroundColor(.indigo)
                
                Text("Seconds")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if (isEdit) {
                    TextField("", text: $newTimeRecup)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                } else {
                    Text("\(task.dataTimerTask.nbSeconds)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.indigo.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.indigo.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Data Section
    private var DataSectionSmartTimer: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Configuration")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            DataSectionTwoSmartTimer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("MyAdaptiveColor").opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Data Section two
    private var DataSectionTwoSmartTimer: some View {
        HStack(spacing: 15) {
            VStack(spacing: 8) {
                Image(systemName: "repeat")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Répétitions")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if (isEdit) {
                    TextField("", text: $newRep)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                } else {
                    Text("\(task.dataSmartTimerTask.nbRep)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Carte Séries
            VStack(spacing: 8) {
                
                Image(systemName: "list.number")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Séries")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if (isEdit) {
                    TextField("", text: $newSeries)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                } else {
                    Text("\(task.dataSmartTimerTask.nbSeries)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Temps de récupération
            VStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.title3)
                    .foregroundColor(.indigo)
                
                Text("Temps récup")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if (isEdit) {
                    TextField("", text: $newTimeRecup)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                } else {
                    Text("\(task.dataSmartTimerTask.timeRecup)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MyAdaptiveColorInverse"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.indigo.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.indigo.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - button start exercice
    private var buttonstartexercicesection: some View {
        // Bouton de démarrage
        Button(action: {
            isExerciceStart = true
        }) {
            HStack(spacing: 15) {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                
                Text("Démarrer Exercice")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.vertical, 18)
            .padding(.horizontal, 40)
            .background(
                    LinearGradient(
                        colors: [.green, .green.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
            )
            .cornerRadius(20)
            .shadow(color: .green.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .disabled(isEdit ? true : false)
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: isExerciceStart)
        .padding(.bottom, 30)
    }
    
    
    func sendUpdTask() {
        Task {
            if (!newName.isEmpty) { task.dataTask.name = newName }
            if (!newRep.isEmpty) { task.dataSmartTimerTask.nbRep = Int(newRep) ?? 0 }
            if (!newSeries.isEmpty) { task.dataSmartTimerTask.nbSeries = Int(newSeries) ?? 0 }
            if (!newTimeRecup.isEmpty) { task.dataSmartTimerTask.timeRecup = Int(newTimeRecup) ?? 0 }
            
            var result: ServerMessagePost = ErrorServerPost
            
            switch (task.dataTask.system) {
            case .None:
                result = try await RequestManager.updateNoneTaskByUser(task: task)
            case .Timer:
                result = try await RequestManager.updateTimerTaskByUser(task: task)
            case .SmartTimer:
                result = try await RequestManager.updateSmartTimerTaskByUser(task: task)
            }
            
            if (result.status == "ok") {
                print("fregrtwgeterg")
            } else {
                print("ko task deleted")
            }
        }
    }
}

func makeString(task: DataSmartTimerTask) -> String {
    return "\((task.currentSeries * task.nbRep) + task.currentRep)/\(task.nbSeries * task.nbRep)"
}

*/
