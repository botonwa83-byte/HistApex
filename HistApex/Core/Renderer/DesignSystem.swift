import SwiftUI

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 28
}

enum Radius {
    static let chip: CGFloat = 8
    static let inner: CGFloat = 12
    static let card: CGFloat = 20
    static let hero: CGFloat = 24
}

enum AppFont {
    static let sectionTitle = Font.headline
    static let cardTitle = Font.subheadline.weight(.bold)
    static let body = Font.subheadline
    static let caption = Font.caption
    static let chip = Font.system(size: 11, weight: .semibold)
    static func stat(_ size: CGFloat) -> Font {
        Font.system(size: size, weight: .bold, design: .rounded)
    }
    static func bigStat(_ size: CGFloat = 30) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
}

extension View {
    func cardShadow() -> some View {
        shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    func cardSurface(padding: CGFloat = Spacing.lg) -> some View {
        self
            .padding(padding)
            .background(Color.apexCardSurface)
            .cornerRadius(Radius.card)
            .cardShadow()
    }

    func readableWidth(_ maxWidth: CGFloat = 760) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

struct TagChip: View {
    let text: String
    var color: Color = .apexLava

    var body: some View {
        Text(text)
            .font(AppFont.chip)
            .foregroundColor(color)
            .lineLimit(1)
            .minimumScaleFactor(0.82)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.22))
            .clipShape(Capsule())
    }
}

struct IconBadge: View {
    let systemImage: String
    var color: Color = .apexBlue
    var size: CGFloat = 42
    var fontSize: CGFloat = 17

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: fontSize, weight: .semibold))
            .frame(width: size, height: size)
            .background(
                ZStack {
                    color.opacity(0.25)
                    color.opacity(0.08).blur(radius: 4)
                }
            )
            .foregroundColor(color)
            .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.inner)
                    .stroke(color.opacity(0.35), lineWidth: 1)
            )
    }
}

struct FlowWrap: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if rowWidth > 0, rowWidth + spacing + size.width > maxWidth {
                totalHeight += rowHeight + spacing
                totalWidth = max(totalWidth, rowWidth)
                rowWidth = size.width
                rowHeight = size.height
            } else {
                rowWidth += (rowWidth > 0 ? spacing : 0) + size.width
                rowHeight = max(rowHeight, size.height)
            }
        }
        totalHeight += rowHeight
        totalWidth = max(totalWidth, rowWidth)
        return CGSize(width: maxWidth == .infinity ? totalWidth : maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX, x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

struct SectionHeader: View {
    let title: String
    var systemImage: String? = nil
    var accent: Color = .apexLava

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(accent)
            }
            Text(title)
                .font(AppFont.sectionTitle)
            Spacer()
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let systemImage: String
    let message: String

    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 42))
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ExpandableSection<Content: View>: View {
    let title: String
    var systemImage: String? = nil
    var accent: Color = .apexLava
    var initiallyExpanded: Bool = false
    var badge: String? = nil
    @ViewBuilder let content: () -> Content

    @State private var isExpanded: Bool

    init(title: String, systemImage: String? = nil, accent: Color = .apexLava,
         initiallyExpanded: Bool = false, badge: String? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.accent = accent
        self.initiallyExpanded = initiallyExpanded
        self.badge = badge
        self.content = content
        _isExpanded = State(initialValue: initiallyExpanded)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .foregroundColor(accent)
                            .frame(width: 20)
                    }
                    Text(title)
                        .font(AppFont.sectionTitle)
                        .foregroundColor(.primary)
                    if let badge {
                        TagChip(text: badge, color: accent)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                        .animation(.easeInOut(duration: 0.25), value: isExpanded)
                }
                .padding(.vertical, Spacing.sm)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    content()
                }
                .padding(.top, Spacing.sm)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct CollapsibleCard<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var accent: Color = .apexBlue
    var initiallyExpanded: Bool = false
    @ViewBuilder let content: () -> Content

    @State private var isExpanded: Bool

    init(title: String, subtitle: String? = nil, systemImage: String? = nil,
         accent: Color = .apexBlue, initiallyExpanded: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.accent = accent
        self.initiallyExpanded = initiallyExpanded
        self.content = content
        _isExpanded = State(initialValue: initiallyExpanded)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.md) {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.title3)
                            .frame(width: 36, height: 36)
                            .background(accent.opacity(0.12))
                            .foregroundColor(accent)
                            .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(AppFont.cardTitle)
                            .foregroundColor(.primary)
                        if let subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Divider()
                        .padding(.vertical, Spacing.xs)
                    content()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .cardSurface()
    }
}

struct SectionDivider: View {
    var title: String? = nil
    var color: Color = .secondary.opacity(0.3)

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Rectangle()
                .fill(color)
                .frame(height: 1)
            if let title {
                Text(title)
                    .font(AppFont.chip)
                    .foregroundColor(.secondary)
                    .fixedSize()
                Rectangle()
                    .fill(color)
                    .frame(height: 1)
            }
        }
    }
}
