//
//  TimerManager.swift
//  SportTasks
//
//  Created by Noah tesson on 09/06/2025.
//

import WidgetKit
import SwiftUI
import Combine

enum ScreenSmartTimer: String {
    case Timer, UserAction, Pause, End
    var id: Self { self }
}

class SmartTimerSystem: ISystem {
    
    @Published var smartTimerData: SmartTimerMakeIt = SmartTimerMakeIt.empty()
    
    override init(id: Int) {
        super.init(id: id)
        loadData(systemId: id)
    }
    
    override init() {
        super.init()
    }
    
    private func loadData(systemId: Int) {
        Task {
            do {
                let result = try await Api.getSmartTimer(id: systemId)
                await MainActor.run {
                    self.smartTimerData = result
                }
            } catch {
                print("Error get timer in class: ", error)
            }
        }
    }
    
    override var model: SystemMakeIt { return SystemMakeIt.SmartTimer }
    override var icon: String { return "clock" }
    override var color: Color { return Color.purple }
    
    override func modelView() -> any View {
        Text(self.model.displayName)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(self.color)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    override func iconView() -> any View {
        Image(systemName: self.icon)
            .font(.system(size: 50))
    }
    override func data(for id: Int, isEditing: Bool) -> any View { SmartTimerDataView(taskId: id, isEditing: isEditing) }
    override func view() -> any View {
        SmartTimerView(smartTimer: SmartTimerClass(smartTimerTask: self.smartTimerData))
    }
}

class SmartTimerClass: ObservableObject {
    
    @Published var smartTimerTask: SmartTimerMakeIt
    @Published var count = 5
    @Published var screen = ScreenSmartTimer.Timer
    @Published var isPreviewEnd = false
    @Published var isStopped = false
    
    private var previewScreen = ScreenSmartTimer.Timer
    private var isInitialCountDown = true
    private var timer: Timer?
    private var timerStarted = false
    
    @Published var elapsedSeconds = 0
    private var generalTimer: Timer?

    init(smartTimerTask: SmartTimerMakeIt) {
        self.smartTimerTask = smartTimerTask
    }
    
    var total: Int { smartTimerTask.nbRep * smartTimerTask.nbSeries }
    
    func startGeneralTimer() {
        guard generalTimer == nil else { return } // éviter doublons
        generalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedSeconds += 1
        }
    }
    
    func stopGeneralTimer() {
        generalTimer?.invalidate()
        generalTimer = nil
    }
    
    func switchScreensmartTimer(newScreen: ScreenSmartTimer) {
        self.screen = newScreen
    }
    
    func checkScreen(screen: ScreenSmartTimer) -> Bool {
        return self.screen == screen
    }
    
    func getIsInitialCountDown() -> Bool {
        return self.isInitialCountDown
    }
    
    func getPreviewScreen() -> ScreenSmartTimer {
        return self.previewScreen
    }
    
    func updPreviewScreen() {
        self.previewScreen = self.screen
    }
    
    func checkLastSeries() {
        if self.smartTimerTask.currentSeries + 1 == self.smartTimerTask.nbSeries {
            if self.isInitialCountDown {
                self.smartTimerTask.currentSeries += 1
            }
            self.isPreviewEnd = true
            return
        }
    }
    
    func checkEnd() {
        if (self.smartTimerTask.currentSeries == self.smartTimerTask.nbSeries) {
            self.screen = ScreenSmartTimer.End
            return
        }
    }
    
    func IncreaseSeries() {
        if (!self.isInitialCountDown && self.count == self.smartTimerTask.timeRecup) {
            if (self.smartTimerTask.currentRep == 0) {
                smartTimerTask.currentSeries += 1
            } else {
                self.smartTimerTask.currentRep = self.smartTimerTask.nbRep
            }
        }
    }
    
    func incrementSeriesIfMaxRep() {
        if self.smartTimerTask.currentRep == self.smartTimerTask.nbRep {
            self.smartTimerTask.currentSeries += 1
            self.smartTimerTask.currentRep = 0
        }
    }
    
    func Countdown() {
        guard !timerStarted else { return }
        timerStarted = true
        
        print("elapsedSeconds: ", elapsedSeconds)
        
        if isInitialCountDown {
            startGeneralTimer()
        }
        
        IncreaseSeries()
        incrementSeriesIfMaxRep()
        
        var TmpCount = isInitialCountDown ? count : smartTimerTask.timeRecup
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.screen == ScreenSmartTimer.Pause {
                return
            }
            if TmpCount > 0 {
                TmpCount -= 1
                self.count = TmpCount
            } else {
                timer.invalidate()
                self.isInitialCountDown = false
                self.timerStarted = false
                self.count = self.smartTimerTask.timeRecup
                self.screen = ScreenSmartTimer.UserAction
                
                self.checkEnd()
                self.checkLastSeries()
            }
        }

    }
    
    func updateRepsFromText(newValue: String) {
        if (newValue == "") {
            smartTimerTask.currentRep += 0
        } else if let intValue = Int(newValue) {
            
            if (intValue > smartTimerTask.nbRep) {
                smartTimerTask.currentRep += 0
                return
            }
            
            if (smartTimerTask.currentRep + intValue >= smartTimerTask.nbRep && smartTimerTask.currentSeries < smartTimerTask.nbSeries) {
                smartTimerTask.currentSeries += 1
                smartTimerTask.currentRep = 0
                return
            }
            
            smartTimerTask.currentRep += intValue
        }
    }
}

struct SmartTimerView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var smartTimer: SmartTimerClass
    
    @State private var nbRepNew = ""
    
    @State private var currentWidth: CGFloat = 0
    let maxWidth: CGFloat = 150
    let duration: Double = 8
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Nombre actuel : \(makeString2(task: smartTimer.smartTimerTask))")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color("MyAdaptiveColor"))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 20)
            
            Spacer()
            
            if (smartTimer.screen == ScreenSmartTimer.Timer) {
                
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: smartTimer.getIsInitialCountDown() ? "clock.fill" : "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(smartTimer.getIsInitialCountDown() ? .orange : .green)
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: smartTimer.count)
                        
                        Text(smartTimer.getIsInitialCountDown() ?
                            "L'exercice démarre dans:" :
                            "Temps de récupération en cours:"
                        )
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            smartTimer.Countdown()
                        }
                    }
                    
                    VStack(spacing: 8) {
                         Text("\(smartTimer.count)")
                             .font(.system(size: 72, weight: .bold, design: .rounded))
                             .foregroundStyle(
                                 LinearGradient(
                                     colors: smartTimer.getIsInitialCountDown() ? [.orange, .red] : [.green, .blue],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing
                                 )
                             )
                             .scaleEffect(1.0)
                             .animation(.easeInOut(duration: 0.3), value: smartTimer.count)
                         
                         Text("secondes")
                             .font(.title3)
                             .fontWeight(.medium)
                             .foregroundColor(.secondary)
                     }
                     .padding(.vertical, 30)
                     .padding(.horizontal, 40)
                    
                     .background(
                         RoundedRectangle(cornerRadius: 25)
                            .fill(Color("MyAdaptiveColor"))
                            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                     )
                }
                
                 
            } else if (smartTimer.screen == ScreenSmartTimer.UserAction) {
                FirstIf
            } else if (smartTimer.screen == ScreenSmartTimer.Pause) {
                FirstElseIf
            } else if (smartTimer.screen == ScreenSmartTimer.End) {
                SecondElseIf
            }
        
            if (smartTimer.screen != ScreenSmartTimer.End) {
                LastIf
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    // MARK: - first if
    private var FirstIf: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 12) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
                Text("Exercice en cours...")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("MyAdaptiveColor"))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            
            Button(action: {
                if (smartTimer.isPreviewEnd) {
                    smartTimer.stopGeneralTimer()
                    smartTimer.IncreaseSeries()
                    smartTimer.switchScreensmartTimer(newScreen: ScreenSmartTimer.End)
                } else {
                    smartTimer.switchScreensmartTimer(newScreen: ScreenSmartTimer.Timer)
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: smartTimer.isPreviewEnd ? "checkmark.circle.fill" : "timer")
                        .font(.title2)
                    
                    Text(smartTimer.isPreviewEnd ? "Finir Exercice" : "Lancer Chrono temps de récupération")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(
                    LinearGradient(
                        colors: smartTimer.isPreviewEnd ? [.green, .green.opacity(0.8)] : [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
            }
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.1), value: smartTimer.isPreviewEnd)
        }
    }
    
    // MARK: - first else if
    private var FirstElseIf: some View {
        VStack(spacing: 20) {
            
            HStack(spacing: 15) {
                VStack(spacing: 8) {
                    Image(systemName: "repeat")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("Répétitions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(smartTimer.smartTimerTask.currentRep)/\(smartTimer.smartTimerTask.nbRep)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                )
                VStack(spacing: 8) {
                    Image(systemName: "list.number")
                        .font(.title2)
                        .foregroundColor(.purple)
                    
                    Text("Séries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(smartTimer.smartTimerTask.currentSeries)/\(smartTimer.smartTimerTask.nbSeries)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.purple.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            
            if smartTimer.isStopped {
                VStack(spacing: 12) {
                    Text("Ajuster les répétitions")
                        .font(.headline)
                        .foregroundColor(.primary)
                      
                    TextField("Nombre de répétitions de la dernière série", text: $nbRepNew)
                        .keyboardType(.numberPad)
                        .autocapitalization(.none)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            if (smartTimer.isStopped) {
                Button(action: {
                    smartTimer.isStopped = false
                }) {
                    Text("Annuler")
                        .foregroundStyle(.blue)
                }
            }
            
            Button(action: {
                if (smartTimer.isStopped) {
                    smartTimer.updateRepsFromText(newValue: nbRepNew)
                    Task {
                        let _ = try await Api.putSmartTimer(smartTimer.smartTimerTask)
                    }
                    dismiss()
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    smartTimer.isStopped = true
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: smartTimer.isStopped ? "xmark.circle.fill" : "stop.circle.fill")
                        .font(.title2)
                    
                    Text(smartTimer.isStopped ? "Arrêter" : "Stop")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                    LinearGradient(
                        colors: [.red, .red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    // MARK: - Second else if
    private var SecondElseIf: some View {
        VStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                
                /*
                Text("Exercice \(smartTimer.smartTimerTask.type) fini.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                 */
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green.opacity(0.3), lineWidth: 2)
                    )
            )
            
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {

                    // Rectangle animé avec bouton intégré
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue)
                            .frame(width: currentWidth, height: 60)
                            .animation(.linear(duration: duration), value: currentWidth)

                        // Bouton stylisé centré sur la barre
                        Button(action: {
                            smartTimer.updateRepsFromText(newValue: nbRepNew)
                            Task {
                                let _ = try await Api.putSmartTimer(smartTimer.smartTimerTask)
                            }

                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "xmark")
                                    .font(.title2)

                                Text("Fermer")
                                    .fontWeight(.bold)
                            }
                            .frame(width: currentWidth, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue.opacity(0.1))
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            )
                            .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
            .onAppear {
                startGrowing()
            }
        }
        .onAppear {
            /*
            Task {
                let result = try await RequestManager.updateTask(dataSmartTimerTask: smartTimer.smartTimerTask)
                
                if (result.status == "ok") {
                    print(result.message)
                }
            }
             */
        }
    }
    
    // MARK: - Last if
    private var LastIf: some View {
        Button(action: {
            if (smartTimer.screen == ScreenSmartTimer.Pause) {
                smartTimer.switchScreensmartTimer(newScreen: smartTimer.getPreviewScreen())
            } else {
                smartTimer.updPreviewScreen()
                smartTimer.switchScreensmartTimer(newScreen: ScreenSmartTimer.Pause)
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: smartTimer.checkScreen(screen: ScreenSmartTimer.Pause) ? "arrow.clockwise" : "pause.fill")
                    .font(.title2)
                    .frame(minWidth: 30, minHeight: 30)
                
                Text(smartTimer.checkScreen(screen: ScreenSmartTimer.Pause) ? "Restart" : "Pause")
                    .fontWeight(.bold)
                    .frame(minWidth: 60, minHeight: 20)
            }
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(
                LinearGradient(
                    colors: [.blue, .blue.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(1.0)
    }
    
    
    func startGrowing() {
        currentWidth = maxWidth
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            smartTimer.updateRepsFromText(newValue: nbRepNew)
            Task {
                let _ = try await Api.putSmartTimer(smartTimer.smartTimerTask)
            }
            dismiss()
        }
    }
}

func makeString2(task: SmartTimerMakeIt) -> String {
    return "\((task.currentSeries * task.nbRep) + task.currentRep)/\(task.nbSeries * task.nbRep)"
}
