//
//  SmartTimerEngine.swift
//  MakeIt
//
//  Created by Noah tesson on 18/11/2025.
//

import SwiftUI

final class SmartTimerEngine {
    private var timer: Timer?
    private var duration: Int = 0
    var onTick: ((Int)->Void)?
    var onFinish: (()->Void)?

    func start(seconds: Int) {
        duration = seconds
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.duration -= 1
            self.onTick?(self.duration)

            if self.duration <= 0 {
                self.timer?.invalidate()
                self.onFinish?()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

