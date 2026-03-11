import SwiftUI
import UIKit

struct ContentView: View {
    @State private var engine = BPMEngine()
    @State private var tapTrigger = 0
    @State private var tapScale: CGFloat = 1.0
    @State private var showOnboarding: Bool

    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    init() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        _showOnboarding = State(initialValue: !hasSeenOnboarding)
    }

    var body: some View {
        ZStack {
            // Background
            Theme.background
                .ignoresSafeArea()

            // Main content
            VStack(spacing: 0) {
                Spacer()

                // Pulse animation area
                PulseAnimationView(
                    tapTrigger: $tapTrigger,
                    isActive: engine.state != .idle
                )
                .frame(height: 260)

                Spacer()
                    .frame(height: 20)

                // BPM display
                bpmDisplay

                Spacer()
                    .frame(height: 16)

                // Status / instruction text
                statusText

                Spacer()

                // Bottom area — reset button or tap hint
                bottomArea
                    .padding(.bottom, 60)
            }

            // Full-screen tap target (behind nothing, above background)
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    handleTap()
                }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            haptic.prepare()
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                }
        }
    }

    // MARK: - BPM Display

    @ViewBuilder
    private var bpmDisplay: some View {
        switch engine.state {
        case .idle:
            Text("--")
                .font(Theme.largeBPM)
                .foregroundStyle(Theme.textTertiary)
                .scaleEffect(tapScale)

        case .tapping:
            VStack(spacing: 4) {
                Text("\(Int(engine.bpm))")
                    .font(Theme.largeBPM)
                    .foregroundStyle(Theme.textPrimary.opacity(0.7))
                    .scaleEffect(tapScale)
                    .contentTransition(.numericText())

                Text("BPM")
                    .font(Theme.label)
                    .foregroundStyle(Theme.textSecondary)
                    .tracking(3)
            }

        case .confident:
            VStack(spacing: 4) {
                Text("\(Int(engine.bpm))")
                    .font(Theme.heroBPM)
                    .foregroundStyle(Theme.accent)
                    .scaleEffect(tapScale)
                    .contentTransition(.numericText())
                    .shadow(color: Theme.accent.opacity(0.3), radius: 20)

                Text("BPM")
                    .font(Theme.label)
                    .foregroundStyle(Theme.accent.opacity(0.7))
                    .tracking(3)
            }
        }
    }

    // MARK: - Status Text

    @ViewBuilder
    private var statusText: some View {
        switch engine.state {
        case .idle:
            VStack(spacing: 8) {
                Text("TAP WITH EACH BEAT")
                    .font(Theme.label)
                    .foregroundStyle(Theme.textSecondary)
                    .tracking(2)

                Text("Place fingers on neck or wrist to feel pulse")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Theme.textTertiary)
            }

        case .tapping:
            VStack(spacing: 8) {
                Text("FINDING RHYTHM...")
                    .font(Theme.label)
                    .foregroundStyle(Theme.accent.opacity(0.7))
                    .tracking(2)

                Text("\(engine.tapCount) TAPS")
                    .font(Theme.sublabel)
                    .foregroundStyle(Theme.textTertiary)
                    .tracking(1.5)
            }

        case .confident:
            Text("\(engine.tapCount) TAPS")
                .font(Theme.sublabel)
                .foregroundStyle(Theme.textTertiary)
                .tracking(1.5)
        }
    }

    // MARK: - Bottom Area

    @ViewBuilder
    private var bottomArea: some View {
        if engine.state != .idle {
            Button {
                withAnimation(Theme.stateTransition) {
                    engine.reset()
                }
            } label: {
                Text("RESET")
                    .font(Theme.label)
                    .foregroundStyle(Theme.textSecondary)
                    .tracking(2)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Theme.surface)
                    .clipShape(Capsule())
            }
        } else {
            // Subtle tap indicator
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 24))
                .foregroundStyle(Theme.textTertiary)
        }
    }

    // MARK: - Tap Handler

    private func handleTap() {
        haptic.impactOccurred()
        haptic.prepare()

        withAnimation(Theme.tapSpring) {
            tapScale = 1.08
        }
        withAnimation(Theme.tapSpring.delay(0.1)) {
            tapScale = 1.0
        }

        tapTrigger += 1

        withAnimation(Theme.stateTransition) {
            engine.registerTap()
        }
    }
}
