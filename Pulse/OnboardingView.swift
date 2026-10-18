import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var showDisclaimer = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: Theme.paddingLarge) {
                Spacer()

                // Title
                Text("FIND YOUR PULSE")
                    .font(Theme.title)
                    .foregroundStyle(Theme.textPrimary)
                    .tracking(2)

                // Instruction cards
                VStack(spacing: Theme.paddingMedium) {
                    pulseLocationCard(
                        icon: "hand.point.up.fill",
                        title: "NECK",
                        description: "Place two fingers on the side of your neck, just below your jaw"
                    )

                    pulseLocationCard(
                        icon: "hand.raised.fill",
                        title: "WRIST",
                        description: "Place two fingers on the inside of your wrist, below your thumb"
                    )
                }
                .padding(.horizontal, Theme.paddingMedium)

                Spacer()

                // How to use
                VStack(spacing: Theme.paddingSmall) {
                    Text("THEN TAP THE SCREEN")
                        .font(Theme.label)
                        .foregroundStyle(Theme.textSecondary)
                        .tracking(1.5)

                    Text("with each beat you feel")
                        .font(Theme.instruction)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer()

                // Continue button
                Button {
                    showDisclaimer = true
                } label: {
                    Text("GOT IT")
                        .font(Theme.label)
                        .foregroundStyle(Theme.background)
                        .tracking(2)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.bottom, Theme.paddingLarge)
            }
        }
        .alert("Health Notice", isPresented: $showDisclaimer) {
            Button("I Understand") {
                isPresented = false
            }
        } message: {
            Text("Pulse is not a medical device. Results are estimates based on your tapping and should not be used for medical diagnosis or treatment decisions.")
        }
    }

    private func pulseLocationCard(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(Theme.accent)
                .frame(width: 52, height: 52)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.label)
                    .foregroundStyle(Theme.textPrimary)
                    .tracking(1.5)

                Text(description)
                    .font(Theme.body)
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
