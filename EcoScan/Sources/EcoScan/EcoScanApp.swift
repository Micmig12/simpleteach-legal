import SwiftUI
import SwiftData

@main
struct EcoScanApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: TrashItem.self)
        } catch {
            fatalError("Não foi possível inicializar o banco de dados: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .preferredColorScheme(.dark)
        }
    }
}
