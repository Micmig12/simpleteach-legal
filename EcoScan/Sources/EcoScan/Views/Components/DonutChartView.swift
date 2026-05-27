import SwiftUI
import Charts

struct DonutChartView: View {
    let stats: RecyclingStats
    @State private var selectedCategory: RecyclingCategory?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Por Categoria")
                .font(.headline)
                .foregroundStyle(.white)

            if stats.categoryBreakdown.isEmpty {
                emptyState
            } else {
                HStack(alignment: .center, spacing: 24) {
                    chart
                    legend
                }
            }
        }
    }

    private var chart: some View {
        Chart(stats.categoryBreakdown, id: \.category) { item in
            SectorMark(
                angle: .value("Peso", item.weightKg),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .foregroundStyle(item.category.color)
            .opacity(selectedCategory == nil || selectedCategory == item.category ? 1 : 0.4)
        }
        .frame(width: 160, height: 160)
        .onTapGesture { selectedCategory = nil }
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(stats.categoryBreakdown, id: \.category) { item in
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedCategory = selectedCategory == item.category ? nil : item.category
                    }
                } label: {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(item.category.color)
                            .frame(width: 10, height: 10)
                        Text(item.category.localizedName)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.85))
                        Spacer()
                        Text(String(format: "%.2f kg", item.weightKg))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
                .opacity(selectedCategory == nil || selectedCategory == item.category ? 1 : 0.5)
            }
        }
    }

    private var emptyState: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "chart.pie")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.3))
                Text("Nenhum item ainda")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
        }
        .frame(height: 120)
    }
}
