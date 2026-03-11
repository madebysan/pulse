import SwiftUI

struct PulseRing: View {
    let delay: Double
    let maxScale: CGFloat
    @Binding var trigger: Int

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.8

    var body: some View {
        Circle()
            .stroke(Theme.accent, lineWidth: 2)
            .scaleEffect(scale)
            .opacity(opacity)
            .onChange(of: trigger) {
                // Reset
                scale = 0.5
                opacity = 0.8

                // Animate outward
                withAnimation(
                    .easeOut(duration: 0.8)
                    .delay(delay)
                ) {
                    scale = maxScale
                    opacity = 0
                }
            }
    }
}

struct PulseAnimationView: View {
    @Binding var tapTrigger: Int
    let isActive: Bool

    var body: some View {
        ZStack {
            // Inner glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.accent.opacity(0.15),
                            Theme.accent.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .opacity(isActive ? 1 : 0.3)

            // Expanding rings
            PulseRing(delay: 0, maxScale: 1.8, trigger: $tapTrigger)
                .frame(width: 100, height: 100)

            PulseRing(delay: 0.1, maxScale: 2.2, trigger: $tapTrigger)
                .frame(width: 100, height: 100)

            PulseRing(delay: 0.2, maxScale: 2.6, trigger: $tapTrigger)
                .frame(width: 100, height: 100)

            // Center dot
            Circle()
                .fill(Theme.accent)
                .frame(width: 16, height: 16)
                .shadow(color: Theme.accent.opacity(0.6), radius: 12)
        }
    }
}
