import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \TrashItem.capturedAt, order: .reverse) private var items: [TrashItem]

    private var stats: RecyclingStats { RecyclingStats(items: items) }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                LazyVGrid(columns: columns, spacing: 16) {
                    StatCardView(
                        title: "Lixo Reciclável",
                        value: String(format: "%.2f kg", stats.recyclableWeightKg),
                        subtitle: "\(stats.recyclableItems.count) itens",
                        icon: "arrow.3.trianglepath",
                        color: .mint
                    )
                    StatCardView(
                        title: "Total Escaneado",
                        value: "\(stats.totalItems)",
                        subtitle: String(format: "%.2f kg total", stats.totalWeightKg),
                        icon: "camera.viewfinder",
                        color: .cyan
                    )
                    StatCardView(
                        title: "Taxa de Reciclagem",
                        value: String(format: "%.0f%%", stats.recyclingRate * 100),
                        subtitle: nil,
                        icon: "chart.pie.fill",
                        color: .green
                    )
                    StatCardView(
                        title: "Sequência",
                        value: "\(stats.currentStreakDays) dias",
                        subtitle: stats.currentStreakDays > 0 ? "Continue assim!" : "Comece hoje",
                        icon: "flame.fill",
                        color: .orange
                    )
                }

                if !items.isEmpty {
                    LiquidGlassCard {
                        DonutChartView(stats: stats)
                    }

                    recentActivity
                }

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Painel")
        .navigationBarTitleDisplayMode(.large)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Olá, Reciclador! 🌱")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.7))
            Text("Seu impacto hoje")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Atividade Recente")
                .font(.headline)
                .foregroundStyle(.white)

            ForEach(items.prefix(5)) { item in
                HStack(spacing: 12) {
                    if let uiImage = UIImage(data: item.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.category.localizedName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text(item.capturedAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    Spacer()
                    Text(String(format: "%.0f g", item.weightGrams))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(item.category.color)
                }
                .padding(12)
                .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .glassCard()
    }
}
