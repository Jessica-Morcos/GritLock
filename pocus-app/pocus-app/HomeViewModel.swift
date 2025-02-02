import SwiftUI
import Combine
import FamilyControls
import ManagedSettings

class HomeViewModel: ObservableObject {
    @Published var settings = AppSettings()
    @Published var progress: CGFloat = 0.0
    @Published var isBreak: Bool = false
    @Published var currentCycle: Int = 1
    @Published var isPickerPresented: Bool = false
    @Published var selectedApps = FamilyActivitySelection()

    private var timer: AnyCancellable?
    private var store = ManagedSettingsStore()
    private var lastPressTime: Date = Date()

    var timerString: String {
        let time = isBreak ? settings.breakValue : settings.timerValue
        return String(format: "%02d:%02d", time / 60, time % 60)
    }

    func handleButtonPress() {
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(lastPressTime)
        lastPressTime = currentTime

        if timeInterval < 0.5 {
            if isBreak {
                stopTimer()
                isBreak = false
                settings.timerValue = settings.timerValue 
                resetTimerValues()
                unlockApps()
            }
        } else {
            if timer == nil {
                startTimer()
            } else if isBreak {
                stopTimer()
                
            }
        }
    }

    func requestScreenTimeAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("Screen Time authorization granted.")
            } catch {
                print("Screen Time authorization failed: \(error)")
            }
        }
    }

    func startTimer() {
        let totalTime = isBreak ? settings.breakValue : settings.timerValue

        if isBreak {
            unlockApps()
        } else {
            lockApps()
        }

        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.isBreak {
                if self.settings.breakValue > 0 {
                    self.settings.breakValue -= 1
                    self.progress = CGFloat(self.settings.initialBreakValue - self.settings.breakValue) / CGFloat(self.settings.initialBreakValue)
                } else {
                    self.endBreak()
                }
            } else {
                if self.settings.timerValue > 0 {
                    self.settings.timerValue -= 1
                    self.progress = CGFloat(self.settings.initialTimerValue - self.settings.timerValue) / CGFloat(self.settings.initialTimerValue)
                } else {
                    self.endWork()
                }
            }
        }
    }

    func endWork() {
        stopTimer()
        unlockApps()
        if currentCycle < settings.totalCycles {
            isBreak = true
            settings.breakValue = settings.breakValue
            startTimer()
        } else {
            resetTimerValues()
        }
    }

    func endBreak() {
        stopTimer()
        lockApps()
        currentCycle += 1
        if currentCycle <= settings.totalCycles {
            isBreak = false
            settings.timerValue = settings.timerValue
            startTimer()
        } else {
            resetTimerValues()
        }
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    func resetTimerValues() {
      
        settings.timerValue = settings.initialTimerValue
        settings.breakValue = settings.initialBreakValue
        progress = 0.0
        currentCycle = 1
        stopTimer()
    }

    func applySettings() {
      
        settings.timerValue = settings.initialTimerValue
        settings.breakValue = settings.initialBreakValue
        resetTimerValues()
    }

    func lockApps() {
        guard !selectedApps.applicationTokens.isEmpty else {
            print("No apps selected for locking.")
            return
        }
        store.shield.applications = selectedApps.applicationTokens
    }

    func unlockApps() {
        store.shield.applications = nil
    }
}
