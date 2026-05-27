import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var cameraVM = CameraViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showAnalysis = false
    @State private var capturedImage: UIImage?
    @State private var isAnalyzing = false

    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(session: cameraVM.session)
                .ignoresSafeArea()

            // Overlay UI
            VStack {
                Spacer()

                // Viewfinder frame
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(0.6), lineWidth: 2)
                    .frame(width: 320, height: 320)
                    .overlay {
                        // Corner accents
                        CornerAccents()
                    }

                Spacer()

                // Bottom controls
                bottomControls
                    .padding(.bottom, 40)
            }
        }
        .navigationTitle("Escanear")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onAppear { cameraVM.setupCamera() }
        .onDisappear { cameraVM.stop() }
        .onChange(of: cameraVM.capturedImage) { _, image in
            guard let image else { return }
            capturedImage = image
            showAnalysis = true
        }
        .onChange(of: selectedPhotoItem) { _, item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    capturedImage = image
                    showAnalysis = true
                }
            }
        }
        .sheet(isPresented: $showAnalysis) {
            if let image = capturedImage {
                AnalysisView(image: image)
            }
        }
    }

    private var bottomControls: some View {
        HStack(spacing: 48) {
            // Photo library picker
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(.ultraThinMaterial, in: Circle())
            }

            // Capture button
            Button(action: { cameraVM.capture() }) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 72, height: 72)
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 84, height: 84)
                }
            }
            .disabled(cameraVM.isCapturing)
            .scaleEffect(cameraVM.isCapturing ? 0.9 : 1)
            .animation(.spring(duration: 0.2), value: cameraVM.isCapturing)

            // Torch placeholder
            Button(action: {}) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(.ultraThinMaterial, in: Circle())
            }
        }
    }
}

private struct CornerAccents: View {
    var body: some View {
        ZStack {
            ForEach(0..<4) { i in
                CornerLine()
                    .rotationEffect(.degrees(Double(i) * 90))
            }
        }
    }
}

private struct CornerLine: View {
    var body: some View {
        GeometryReader { geo in
            Path { p in
                let w = geo.size.width
                let h = geo.size.height
                let len: CGFloat = 20
                p.move(to: CGPoint(x: 0, y: len))
                p.addLine(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: len, y: 0))
            }
            .stroke(.mint, style: StrokeStyle(lineWidth: 3, lineCap: .round))
        }
    }
}
