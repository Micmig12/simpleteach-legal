import SwiftUI

struct TrashItemCard: View {
    let item: TrashItem
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Photo
            Group {
                if let uiImage = UIImage(data: item.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(item.category.color.opacity(0.2))
                        .overlay {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 32))
                                .foregroundStyle(item.category.color)
                        }
                }
            }
            .frame(height: 130)
            .clipped()

            // Info
            VStack(alignment: .leading, spacing: 6) {
                CategoryBadge(category: item.category, size: .small)

                HStack {
                    Text(String(format: "%.0f g", item.weightGrams))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: item.isRecyclable ? "arrow.3.trianglepath" : "xmark")
                        .font(.caption)
                        .foregroundStyle(item.isRecyclable ? .mint : .red.opacity(0.8))
                }

                Text(item.capturedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(12)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.9)
        .onAppear {
            withAnimation(.spring(duration: 0.4)) { appeared = true }
        }
    }
}
