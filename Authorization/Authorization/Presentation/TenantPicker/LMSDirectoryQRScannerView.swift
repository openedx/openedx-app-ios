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
        private let dimLayer = CAShapeLayer()
        private let reticle = UIView()
        private let reticleSize: CGFloat = 260
        private let reticleRadius: CGFloat = 20

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            setupCamera()
            setupOverlay()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            previewLayer?.frame = view.bounds
            // Punch a rounded-square hole in the dimmed overlay so the camera shows
            // through the reticle while everything around it stays dimmed.
            let path = UIBezierPath(rect: view.bounds)
            path.append(UIBezierPath(roundedRect: reticle.frame, cornerRadius: reticleRadius))
            path.usesEvenOddFillRule = true
            dimLayer.path = path.cgPath
            dimLayer.frame = view.bounds
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Stop the camera when swiped away, not only via the Close button.
            stopSession()
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
            // Dim layer sits above the camera preview; its hole is cut in viewDidLayoutSubviews.
            dimLayer.fillRule = .evenOdd
            dimLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
            view.layer.addSublayer(dimLayer)

            reticle.translatesAutoresizingMaskIntoConstraints = false
            reticle.backgroundColor = .clear
            reticle.layer.borderColor = UIColor.white.cgColor
            reticle.layer.borderWidth = 3
            reticle.layer.cornerRadius = reticleRadius
            view.addSubview(reticle)

            let hint = UILabel()
            hint.translatesAutoresizingMaskIntoConstraints = false
            hint.text = "Point your camera at the LMS QR code"
            hint.textColor = .white
            hint.font = .systemFont(ofSize: 15, weight: .medium)
            hint.textAlignment = .center
            hint.numberOfLines = 0
            hint.shadowColor = UIColor.black.withAlphaComponent(0.6)
            hint.shadowOffset = CGSize(width: 0, height: 1)
            view.addSubview(hint)

            let close = UIButton(type: .system)
            close.translatesAutoresizingMaskIntoConstraints = false
            close.setImage(UIImage(systemName: "xmark"), for: .normal)
            close.tintColor = .white
            close.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            close.layer.cornerRadius = 22
            close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
            view.addSubview(close)

            NSLayoutConstraint.activate([
                reticle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                reticle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                reticle.widthAnchor.constraint(equalToConstant: reticleSize),
                reticle.heightAnchor.constraint(equalToConstant: reticleSize),

                hint.topAnchor.constraint(equalTo: reticle.bottomAnchor, constant: 24),
                hint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                hint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

                close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
                close.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                close.widthAnchor.constraint(equalToConstant: 44),
                close.heightAnchor.constraint(equalToConstant: 44)
            ])
        }

        private func stopSession() {
            if session.isRunning { session.stopRunning() }
        }

        @objc private func closeTapped() {
            stopSession()
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
                stopSession()
                onCodeScanned?(value)
            }
        }
    }
}
