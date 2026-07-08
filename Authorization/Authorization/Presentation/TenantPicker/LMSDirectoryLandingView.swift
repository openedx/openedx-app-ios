import SwiftUI
import Theme

struct LMSDirectoryLandingView: View {
    @StateObject private var viewModel: LMSDirectoryViewModel
    @State private var showingSearch = false
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
                        onScanTapped: { showingQRScanner = true }
                    )
                } else {
                    LMSDirectoryLandingIntroView(
                        onFindTapped: { showingSearch = true },
                        onQRTapped: { showingQRScanner = true }
                    )
                }
            }
            .padding(24)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        // Curated mode presents the org's fixed list, so the title reads "Choose…"
        // rather than the search-oriented "Find your LMS".
        .navigationTitle(viewModel.isCurated ? "Choose your platform" : "Find your LMS")
        .sheet(isPresented: $showingQRScanner) {
            LMSDirectoryQRScannerView {
                showingQRScanner = false
            } onCodeScanned: { code in
                showingQRScanner = false
                Task {
                    if let error = await viewModel.selectScannedURL(code) {
                        qrError = error
                    }
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
