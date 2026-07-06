import AVFoundation
import SwiftUI

struct LMSDirectoryQRScannerView: UIViewControllerRepresentable {
    var onCancel: () -> Void
    var onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let controller = QRScannerViewController()
        controller.onCancel = onCancel
        controller.onCodeScanned = onCodeScanned
        return controller
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {}

    final class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
        var onCancel: (() -> Void)?
        var onCodeScanned: ((String) -> Void)?

        private let session = AVCaptureSession()
        private var previewLayer: AVCaptureVideoPreviewLayer?

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            setupCamera()
            setupOverlay()
        }

        private func setupCamera() {
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input)
            else {
                return
            }

            session.addInput(input)

            let output = AVCaptureMetadataOutput()
            if session.canAddOutput(output) {
                session.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [.qr, .aztec, .dataMatrix]
            }

            let preview = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = .resizeAspectFill
            preview.frame = view.bounds
            view.layer.addSublayer(preview)
            previewLayer = preview

            session.startRunning()
        }

        private func setupOverlay() {
            let closeButton = UIButton(type: .system)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.setTitle("Close", for: .normal)
            closeButton.setTitleColor(.white, for: .normal)
            closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
            view.addSubview(closeButton)

            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            ])
        }

        @objc private func closeTapped() {
            session.stopRunning()
            onCancel?()
        }

        nonisolated func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let value = metadata.stringValue
            else {
                return
            }
            // The delegate queue is DispatchQueue.main (set in setupCamera), so we are
            // guaranteed to be on the main actor here.
            MainActor.assumeIsolated {
                session.stopRunning()
                onCodeScanned?(value)
            }
        }
    }
}
