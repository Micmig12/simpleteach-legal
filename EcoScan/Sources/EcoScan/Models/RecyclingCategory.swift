import SwiftUI

enum RecyclingCategory: String, CaseIterable, Codable, Identifiable {
    case paper = "paper"
    case plastic = "plastic"
    case glass = "glass"
    case metal = "metal"
    case organic = "organic"
    case electronic = "electronic"
    case reject = "reject"

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .paper: return "Papel"
        case .plastic: return "Plástico"
        case .glass: return "Vidro"
        case .metal: return "Metal"
        case .organic: return "Orgânico"
        case .electronic: return "Eletrônico"
        case .reject: return "Rejeito"
        }
    }

    var isRecyclable: Bool {
        switch self {
        case .paper, .plastic, .glass, .metal, .electronic: return true
        case .organic, .reject: return false
        }
    }

    // Average weight in grams for estimation
    var averageWeightGrams: Double {
        switch self {
        case .paper: return 150
        case .plastic: return 50
        case .glass: return 300
        case .metal: return 80
        case .organic: return 200
        case .electronic: return 250
        case .reject: return 100
        }
    }

    var color: Color {
        switch self {
        case .paper: return Color(red: 0.2, green: 0.5, blue: 0.9)
        case .plastic: return Color(red: 0.9, green: 0.3, blue: 0.3)
        case .glass: return Color(red: 0.2, green: 0.75, blue: 0.4)
        case .metal: return Color(red: 0.9, green: 0.7, blue: 0.1)
        case .organic: return Color(red: 0.6, green: 0.4, blue: 0.2)
        case .electronic: return Color(red: 0.6, green: 0.2, blue: 0.9)
        case .reject: return Color(red: 0.5, green: 0.5, blue: 0.5)
        }
    }

    var icon: String {
        switch self {
        case .paper: return "doc.fill"
        case .plastic: return "bag.fill"
        case .glass: return "wineglass.fill"
        case .metal: return "cylinder.fill"
        case .organic: return "leaf.fill"
        case .electronic: return "cpu.fill"
        case .reject: return "xmark.bin.fill"
        }
    }

    var binColor: String {
        switch self {
        case .paper: return "Azul"
        case .plastic: return "Vermelho"
        case .glass: return "Verde"
        case .metal: return "Amarelo"
        case .organic: return "Marrom"
        case .electronic: return "Coleta Especial"
        case .reject: return "Cinza"
        }
    }
}
