import SwiftUI
import Theme

struct LMSDirectoryLandingView: View {
    @StateObject private var viewModel: LMSDirectoryViewModel
    @State private var showingSearch = false
    @State private var showingQRInfo = false
    @State private var showingQRScanner = false
    @State private var qrError: String?

    init(viewModel: LMSDirectoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if showingSearch || viewModel.isCurated {
                    LMSDirectoryView(
                        viewModel: viewModel,
                        onScanTapped: { showingQRInfo = true }
                    )
                } else {
                    LMSDirectoryLandingIntroView(
                        onFindTapped: { showingSearch = true },
                        onQRTapped: { showingQRInfo = true }
                    )
                }
            }
            .padding(24)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .sheet(isPresented: $showingQRInfo) {
            LMSDirectoryQRInstructionsView {
                showingQRInfo = false
                showingQRScanner = true
            }
        }
        .sheet(isPresented: $showingQRScanner) {
            LMSDirectoryQRScannerView {
                showingQRScanner = false
            } onCodeScanned: { code in
                showingQRScanner = false
                if viewModel.handleScannedURL(code) {
                    showingSearch = true
                } else {
                    qrError = "We couldn't read the QR code. Try again."
                }
            }
        }
        .alert("QR Error", isPresented: Binding(
            get: { qrError != nil },
            set: { if !$0 { qrError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(qrError ?? "")
        }
    }
}
