import SwiftUI

// MARK: - Color Palette
extension Color {
    // Backgrounds
    static let appBackground     = Color(hex: "#0A0A0F")
    static let appSurface        = Color(hex: "#13131F")
    static let appCard           = Color(hex: "#1C1C2E")
    static let appCardElevated   = Color(hex: "#242438")

    // Accents
    static let accentMint        = Color(hex: "#00E5A0")   // Primary CTA
    static let accentPurple      = Color(hex: "#7C3AED")   // Secondary
    static let accentOrange      = Color(hex: "#F97316")   // Progress / warnings
    static let accentRed         = Color(hex: "#EF4444")   // Errors / injury

    // Text
    static let textPrimary       = Color(hex: "#FFFFFF")
    static let textSecondary     = Color(hex: "#9CA3AF")
    static let textMuted         = Color(hex: "#4B5563")

    // Gradients (used as backgrounds)
    static let gradientMint      = LinearGradient(colors: [Color(hex: "#00E5A0"), Color(hex: "#00B37D")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let gradientPurple    = LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#4F46E5")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let gradientOrange    = LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#DC2626")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let gradientDark      = LinearGradient(colors: [Color(hex: "#13131F"), Color(hex: "#0A0A0F")], startPoint: .top, endPoint: .bottom)

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - Typography (SF Pro Rounded — built-in, no download needed)
extension Font {
    static let displayLarge  = Font.system(size: 34, weight: .bold,     design: .rounded)
    static let displayMedium = Font.system(size: 28, weight: .bold,     design: .rounded)
    static let displaySmall  = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headlineLarge = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let headlineSmall = Font.system(size: 15, weight: .semibold, design: .rounded)
    static let bodyLarge     = Font.system(size: 16, weight: .regular,  design: .rounded)
    static let bodySmall     = Font.system(size: 14, weight: .regular,  design: .rounded)
    // Note: we intentionally skip redefining .caption (conflicts with SwiftUI built-in)
    static let label         = Font.system(size: 11, weight: .semibold, design: .rounded)
}

// MARK: - Reusable Components

struct AppCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = 16

    init(padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
    }

    var body: some View {
        content
            .padding(padding)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var style: ButtonStyle = .mint
    let action: () -> Void

    enum ButtonStyle { case mint, purple, orange }

    var gradient: LinearGradient {
        switch style {
        case .mint:   return Color.gradientMint
        case .purple: return Color.gradientPurple
        case .orange: return Color.gradientOrange
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.black).scaleEffect(0.8)
                }
                Text(title)
                    .font(.headlineLarge)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

struct TagBadge: View {
    let text: String
    var color: Color = .accentMint

    var body: some View {
        Text(text)
            .font(.label)
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    var accent: Color = .accentMint
    var icon: String = ""

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if !icon.isEmpty {
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundColor(accent)
                    }
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                HStack(alignment: .lastTextBaseline, spacing: 3) {
                    Text(value)
                        .font(.displaySmall)
                        .foregroundColor(.textPrimary)
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - View Modifiers

struct AppTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.textMuted.opacity(0.3), lineWidth: 1)
            )
            .foregroundColor(.textPrimary)
            .tint(.accentMint)
    }
}

extension View {
    func appTextField() -> some View { modifier(AppTextFieldStyle()) }
    func appScreen() -> some View {
        self.background(Color.appBackground.ignoresSafeArea())
    }
}
