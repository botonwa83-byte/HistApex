import SwiftUI

extension Color {
    static let apexBackground = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x1C1C1E) : UIColor(hex6: 0xF5F0EB)
    })
    static let apexCardSurface = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x2C2C2E) : UIColor(hex6: 0xFFFFFF)
    })
    static let apexSurface = apexCardSurface
    static let apexInk = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xF2F2F7) : UIColor(hex6: 0x1C1C1E)
    })

    static let apexLava = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xFF8A65) : UIColor(hex6: 0xFF7043)
    })
    static let apexEmerald = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x4DB6AC) : UIColor(hex6: 0x26A69A)
    })
    static let apexStarBlue = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x64B5F6) : UIColor(hex6: 0x42A5F5)
    })
    static let apexMystery = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x9575CD) : UIColor(hex6: 0x7E57C2)
    })
    static let apexGold = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xFFB74D) : UIColor(hex6: 0xFFA726)
    })
    static let apexDanger = Color(UIColor { _ in UIColor(hex6: 0xEF5350) })

    static let apexTeal = apexEmerald
    static let apexBlue = apexStarBlue
    static let apexRed = apexLava
    static let apexViolet = apexMystery

    static let stageJunior = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x81C784) : UIColor(hex6: 0x66BB6A)
    })
    static let stageRequired = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xFF8A65) : UIColor(hex6: 0xFF7043)
    })
    static let stageElective = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x9575CD) : UIColor(hex6: 0x7E57C2)
    })
    static let stageSprint = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xFFB74D) : UIColor(hex6: 0xFFA726)
    })

    static func grade(_ grade: ImportanceGrade) -> Color {
        switch grade {
        case .s: return .apexRed
        case .a: return .apexGold
        case .b: return .apexBlue
        case .c: return .secondary
        }
    }
}

extension UIColor {
    convenience init(hex6: UInt32) {
        self.init(
            red: CGFloat((hex6 >> 16) & 0xFF) / 255,
            green: CGFloat((hex6 >> 8) & 0xFF) / 255,
            blue: CGFloat(hex6 & 0xFF) / 255,
            alpha: 1
        )
    }
}

enum AppearancePreference: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "跟随系统"
        case .light: return "浅色"
        case .dark: return "深色"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

final class AppearanceManager: ObservableObject {
    static let shared = AppearanceManager()
    private let storageKey = "appearance_preference"

    @Published var preference: AppearancePreference {
        didSet {
            UserDefaults.standard.set(preference.rawValue, forKey: storageKey)
        }
    }

    var colorScheme: ColorScheme? { preference.colorScheme }

    private init() {
        let raw = UserDefaults.standard.string(forKey: storageKey) ?? ""
        preference = AppearancePreference(rawValue: raw) ?? .system
    }
}
