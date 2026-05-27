import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    var animateIn: Bool = true

    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.15), in: Circle())
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(color)
                }
            }
        }
        .glassCard(cornerRadius: 20, padding: 20)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(duration: 0.5).delay(0.1)) {
                appeared = true
            }
        }
    }
}
