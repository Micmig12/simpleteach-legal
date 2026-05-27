import SwiftUI

struct EcoMeshBackground: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20, paused: false)) { context in
            let phase = Float(context.date.timeIntervalSinceReferenceDate * 0.04)
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5 + sin(phase) * 0.08],
                    [0.5 + cos(phase * 0.7) * 0.06, 0.5],
                    [1.0, 0.5 + sin(phase * 1.3) * 0.08],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    Color(red: 0.00, green: 0.10, blue: 0.05),
                    Color(red: 0.00, green: 0.22, blue: 0.12),
                    Color(red: 0.00, green: 0.05, blue: 0.08),
                    Color(red: 0.00, green: 0.28, blue: 0.18),
                    Color(red: 0.00, green: 0.20, blue: 0.15),
                    Color(red: 0.00, green: 0.15, blue: 0.22),
                    Color(red: 0.00, green: 0.05, blue: 0.03),
                    Color(red: 0.00, green: 0.08, blue: 0.18),
                    Color(red: 0.00, green: 0.02, blue: 0.05)
                ]
            )
            .ignoresSafeArea()
        }
    }
}
