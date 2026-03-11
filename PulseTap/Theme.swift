import SwiftUI

enum Theme {
    // MARK: - Colors

    static let background = Color(red: 0.04, green: 0.04, blue: 0.04) // #0A0A0A
    static let surface = Color(red: 0.10, green: 0.10, blue: 0.10) // #1A1A1A
    static let surfaceLight = Color(red: 0.15, green: 0.15, blue: 0.15) // #262626

    static let accent = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30 — coral red
    static let accentDim = Color(red: 1.0, green: 0.23, blue: 0.19).opacity(0.3)

    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.55)
    static let textTertiary = Color(white: 0.35)

    // MARK: - Typography

    static let heroBPM = Font.system(size: 120, weight: .bold, design: .rounded)
    static let largeBPM = Font.system(size: 72, weight: .bold, design: .rounded)
    static let label = Font.system(size: 14, weight: .semibold, design: .monospaced)
    static let sublabel = Font.system(size: 12, weight: .medium, design: .monospaced)
    static let instruction = Font.system(size: 18, weight: .medium, design: .rounded)
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)

    // MARK: - Spacing

    static let paddingLarge: CGFloat = 40
    static let paddingMedium: CGFloat = 24
    static let paddingSmall: CGFloat = 12

    // MARK: - Animation

    static let tapSpring = Animation.spring(response: 0.3, dampingFraction: 0.6)
    static let stateTransition = Animation.easeInOut(duration: 0.4)
}
