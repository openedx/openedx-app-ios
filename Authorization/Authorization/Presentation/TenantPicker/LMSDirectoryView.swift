import Core
import SwiftUI
import Theme
import Kingfisher

struct LMSDirectoryView: View {
    @ObservedObject var viewModel: LMSDirectoryViewModel
    var onScanTapped: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.isCurated {
                searchField
            }
            content
        }
        .padding(.vertical, 12)
        .accessibilityIdentifier("lms_directory_container")
    }

    private var searchField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.Colors.textInputTextColor)
                TextField("Enter LMS URL or name", text: $viewModel.searchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.webSearch)
                    .submitLabel(.search)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { onScanTapped?() }) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Theme.Colors.infoColor)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("qr_search_button")
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                Theme.Shapes.textInputShape
                    .fill(Theme.Colors.textInputBackground)
            )
            .overlay(
                Theme.Shapes.textInputShape
                    .stroke(lineWidth: 1)
                    .fill(Theme.Colors.textInputStroke)
            )
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            // Curated mode has no search/history — an idle state just means the fixed
            // list is still loading.
            if viewModel.isCurated { loadingView } else {
                placeholder(text: "Start typing to find your platform.")
            }
        case .history:
            if viewModel.isCurated { loadingView } else { historySection }
        case .searching:
            loadingView
        case .results:
            resultsSection
        case .empty:
            placeholder(text: "We haven't found any suitable LMS yet.")
        case .offline:
            placeholder(text: "No internet connection")
        case .error(let message):
            placeholder(text: message)
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("History")
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                Spacer()
                Button("Clean history") {
                    viewModel.clearHistory()
                }
                .font(Theme.Fonts.labelMedium)
                .foregroundColor(Theme.Colors.infoColor)
            }
            ForEach(viewModel.history) { item in
                historyRow(item)
            }
        }
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // "Results" is a search concept — in curated mode the list is just the platforms.
            if !viewModel.isCurated {
                Text("Results")
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            ForEach(viewModel.results) { result in
                resultRow(result)
            }
        }
    }

    private func resultRow(_ item: LMSSearchResult) -> some View {
        Button(action: { viewModel.selectResult(item) }) {
            LMSRowContent(
                title: item.title,
                subtitle: item.shortDescription,
                url: item.baseURL,
                logoURL: item.logoURL,
                accentColorHex: item.accentColorHex
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("lms_result_\(item.id)")
    }

    private func historyRow(_ item: LMSHistoryItem) -> some View {
        let detail = item.decodedDetail()
        return Button(action: { viewModel.selectHistoryItem(item) }) {
            LMSRowContent(
                title: item.title,
                subtitle: item.shortDescription,
                url: item.baseURL,
                logoURL: item.logoURL,
                accentColorHex: detail?.accentColorHex
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("lms_history_\(item.id)")
    }

    private var loadingView: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text("Searching…")
                .font(Theme.Fonts.bodyLarge)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(.vertical, 8)
    }

    private func placeholder(text: String) -> some View {
        Text(text)
            .font(Theme.Fonts.bodyLarge)
            .foregroundColor(Theme.Colors.textSecondary)
            .padding(.vertical, 8)
    }
}

private struct LMSRowContent: View {
    let title: String
    let subtitle: String
    let url: URL
    let logoURL: URL?
    let accentColorHex: String?

    private var badgeColor: Color {
        if let hex = accentColorHex, let lmsColor = LMSColor(hex: hex) {
            return Color(red: lmsColor.red, green: lmsColor.green, blue: lmsColor.blue)
        }
        return Theme.Colors.accentColor
    }

    private var lmsInitialsView: some View {
        let initials = title
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
        return RoundedRectangle(cornerRadius: 8)
            .fill(badgeColor)
            .frame(width: 44, height: 44)
            .overlay(
                Text(initials.isEmpty ? String(title.prefix(1)).uppercased() : initials)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(.white)
            )
    }

    var body: some View {
        HStack(spacing: 12) {
            switch LMSImageSource(url: logoURL) {
            case let .remote(url):
                KFImage.url(url)
                    .placeholder {
                        lmsInitialsView
                    }
                    .onFailure { _ in }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Theme.Colors.background)
                    )
            case .bundled:
                // Shipped inside the app: there is nothing to load, so it draws in
                // the first frame and works with no network at all.
                if let image = LMSImageSource(url: logoURL)?.bundledImage() {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .cornerRadius(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.Colors.background)
                        )
                } else {
                    lmsInitialsView
                }
            case .none:
                lmsInitialsView
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(subtitle)
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                Text(url.host ?? url.absoluteString)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(16)
        .background(
            Theme.Shapes.textInputShape
                .fill(Theme.Colors.background)
        )
        .overlay(
            Theme.Shapes.textInputShape
                .stroke(lineWidth: 1)
                .fill(Theme.Colors.textInputStroke.opacity(0.4))
        )
    }
}
