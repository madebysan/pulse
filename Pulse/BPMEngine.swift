import Foundation
import SwiftUI

@Observable
final class BPMEngine {
    // MARK: - State

    enum TapState {
        case idle
        case tapping
        case confident
    }

    private(set) var state: TapState = .idle
    private(set) var bpm: Double = 0
    private(set) var tapCount: Int = 0
    private(set) var lastTapTime: Date?

    // MARK: - Private

    private var tapTimestamps: [Date] = []
    private var resetTimer: Timer?

    // Number of consistent taps needed for confident reading
    private let confidenceThreshold = 8

    // MARK: - Public API

    func registerTap() {
        let now = Date()
        tapTimestamps.append(now)
        tapCount = tapTimestamps.count
        lastTapTime = now

        // Calculate BPM from intervals
        if tapTimestamps.count >= 2 {
            let intervals = calculateIntervals()
            let filteredIntervals = rejectOutliers(intervals)

            if !filteredIntervals.isEmpty {
                let avgInterval = filteredIntervals.reduce(0, +) / Double(filteredIntervals.count)
                bpm = 60.0 / avgInterval
            }

            // Transition states
            if tapTimestamps.count >= confidenceThreshold && bpm >= 40 && bpm <= 220 {
                state = .confident
            } else {
                state = .tapping
            }
        } else {
            state = .tapping
        }

        // Reset inactivity timer
        scheduleAutoReset()
    }

    func reset() {
        tapTimestamps.removeAll()
        tapCount = 0
        bpm = 0
        state = .idle
        lastTapTime = nil
        resetTimer?.invalidate()
        resetTimer = nil
    }

    // MARK: - Private Methods

    private func calculateIntervals() -> [Double] {
        guard tapTimestamps.count >= 2 else { return [] }

        var intervals: [Double] = []
        for i in 1..<tapTimestamps.count {
            let interval = tapTimestamps[i].timeIntervalSince(tapTimestamps[i - 1])
            intervals.append(interval)
        }
        return intervals
    }

    private func rejectOutliers(_ intervals: [Double]) -> [Double] {
        guard intervals.count >= 3 else { return intervals }

        let avg = intervals.reduce(0, +) / Double(intervals.count)

        return intervals.filter { interval in
            interval > avg * 0.5 && interval < avg * 2.0
        }
    }

    private func scheduleAutoReset() {
        resetTimer?.invalidate()
        resetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.reset()
            }
        }
    }
}
