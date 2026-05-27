import SwiftUI
import AVFoundation

final class CameraPreviewLayer: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewLayer {
        let view = CameraPreviewLayer()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewLayer, context: Context) {
        uiView.previewLayer.session = session
    }
}

@Observable
final class CameraViewModel {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    var capturedImage: UIImage?
    var isCapturing = false
    var error: Error?

    func setupCamera() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device)
        else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) { session.addOutput(output) }

        session.commitConfiguration()

        Task.detached { [session] in
            session.startRunning()
        }
    }

    func capture() {
        guard !isCapturing else { return }
        isCapturing = true
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: PhotoCaptureDelegate(viewModel: self))
    }

    func stop() {
        Task.detached { [session] in session.stopRunning() }
    }
}

private final class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    let viewModel: CameraViewModel

    init(viewModel: CameraViewModel) { self.viewModel = viewModel }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        defer { viewModel.isCapturing = false }
        if let error {
            viewModel.error = error
            return
        }
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        viewModel.capturedImage = image
    }
}
