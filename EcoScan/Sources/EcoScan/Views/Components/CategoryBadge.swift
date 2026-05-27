import SwiftUI

struct CategoryBadge: View {
    let category: RecyclingCategory
    var showIcon: Bool = true
    var size: BadgeSize = .medium

    enum BadgeSize {
        case small, medium, large
        var font: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption
            case .large: return .subheadline
            }
        }
        var padding: EdgeInsets {
            switch self {
            case .small: return .init(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return .init(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .large: return .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            }
        }
        var iconSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 16
            }
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            if showIcon {
                Image(systemName: category.icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
            }
            Text(category.localizedName)
                .font(size.font)
                .fontWeight(.semibold)
        }
        .padding(size.padding)
        .background(
            Capsule()
                .fill(category.color.opacity(0.2))
                .overlay(Capsule().stroke(category.color.opacity(0.5), lineWidth: 1))
        )
        .foregroundStyle(category.color)
    }
}

#Preview {
    VStack {
        ForEach(RecyclingCategory.allCases) { cat in
            CategoryBadge(category: cat)
        }
    }
    .padding()
    .background(.black)
}
