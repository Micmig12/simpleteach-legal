import Foundation

struct RecyclingStats {
    let items: [TrashItem]

    var totalItems: Int { items.count }

    var recyclableItems: [TrashItem] { items.filter { $0.isRecyclable } }
    var nonRecyclableItems: [TrashItem] { items.filter { !$0.isRecyclable } }

    var totalWeightKg: Double { items.reduce(0) { $0 + $1.weightKg } }
    var recyclableWeightKg: Double { recyclableItems.reduce(0) { $0 + $1.weightKg } }

    var recyclingRate: Double {
        guard totalItems > 0 else { return 0 }
        return Double(recyclableItems.count) / Double(totalItems)
    }

    func weight(for category: RecyclingCategory) -> Double {
        items.filter { $0.category == category }.reduce(0) { $0 + $1.weightKg }
    }

    func count(for category: RecyclingCategory) -> Int {
        items.filter { $0.category == category }.count
    }

    var categoryBreakdown: [(category: RecyclingCategory, weightKg: Double)] {
        RecyclingCategory.allCases.map { cat in
            (category: cat, weightKg: weight(for: cat))
        }.filter { $0.weightKg > 0 }
    }

    var currentStreakDays: Int {
        guard !items.isEmpty else { return 0 }
        let calendar = Calendar.current
        let sorted = items.map { calendar.startOfDay(for: $0.capturedAt) }
            .sorted(by: >)
        var streak = 1
        var previous = sorted[0]
        for date in sorted.dropFirst() {
            let diff = calendar.dateComponents([.day], from: date, to: previous).day ?? 0
            if diff == 1 {
                streak += 1
                previous = date
            } else if diff > 1 {
                break
            }
        }
        return streak
    }
}
