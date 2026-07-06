//
//  ReportLMSView.swift
//  Profile
//
//  The "Report this LMS" flow shown on the Profile tab when the LMS Directory
//  feature is on. A learner can flag the platform they're signed into: pick a
//  reason, add a note, optionally attach a screenshot, and send it to the
//  registry's moderators (not to the LMS itself).
//

import SwiftUI
import Core
import Theme
import PhotosUI

// MARK: - Report this LMS

/// Moderation reasons a learner can flag the current platform with. Raw values
/// match the registry's categories so the admin console groups them correctly.
public enum LMSReportCategory: String, CaseIterable, Identifiable, Sendable {
    case inappropriate
    case scam
    case impersonation
    case spam
    case broken
    case other

    public var id: String { rawValue }

    var title: String {
        switch self {
        case .inappropriate:
            return NSLocalizedString("Inappropriate or adult content", comment: "LMS report category")
        case .scam:
            return NSLocalizedString("Scam or phishing", comment: "LMS report category")
        case .impersonation:
            return NSLocalizedString("Pretends to be someone else", comment: "LMS report category")
        case .spam:
            return NSLocalizedString("Spam or fake platform", comment: "LMS report category")
        case .broken:
            return NSLocalizedString("Doesn't work or can't sign in", comment: "LMS report category")
        case .other:
            return NSLocalizedString("Something else", comment: "LMS report category")
        }
    }
}

/// Drives the "Report this LMS" sheet on the Profile tab. Submits a moderation
/// complaint about the platform the learner is currently signed into to the
/// registry (not to the LMS itself); a human moderator decides what to do with it.
@MainActor
public final class ReportLMSViewModel: ObservableObject {

    public enum SubmitState: Equatable {
        case editing
        case submitting
        case success
        case failure(String)
    }

    let lmsTitle: String
    private let baseURL: String?
    private let registryURL: String?

    @Published var category: LMSReportCategory = .inappropriate
    @Published var message: String = ""
    @Published var email: String = ""
    @Published private(set) var state: SubmitState = .editing
    /// A downscaled preview of the attached screenshot, if any.
    @Published private(set) var screenshot: UIImage?
    private var screenshotBase64: String?

    public init() {
        let base = UserDefaults.standard.string(forKey: "selectedLMSBaseURL")
        self.baseURL = (base?.isEmpty ?? true) ? nil : base
        self.registryURL = UserDefaults.standard.string(forKey: "lmsRegistryURL")
        if let host = base.flatMap({ URL(string: $0)?.host }) {
            self.lmsTitle = host
        } else {
            self.lmsTitle = NSLocalizedString("This platform", comment: "LMS report fallback title")
        }
    }

    var canSubmit: Bool {
        state != .submitting && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Downscale and JPEG-compress a picked image, keeping a preview + base64.
    func attachScreenshot(_ data: Data) {
        guard let image = UIImage(data: data) else { return }
        let maxDimension: CGFloat = 1280
        let scale = min(1, maxDimension / max(image.size.width, image.size.height))
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let resized = UIGraphicsImageRenderer(size: size).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        guard let jpeg = resized.jpegData(compressionQuality: 0.6) else { return }
        screenshot = resized
        screenshotBase64 = jpeg.base64EncodedString()
    }

    func removeScreenshot() {
        screenshot = nil
        screenshotBase64 = nil
    }

    func submit() {
        guard canSubmit else { return }
        guard
            let baseURL,
            let registryURL,
            let endpoint = URL(string: registryURL)?.appendingPathComponent("api/v1/reports")
        else {
            state = .failure(
                NSLocalizedString(
                    "Reporting isn't available for this platform.",
                    comment: "LMS report unavailable"
                )
            )
            return
        }

        state = .submitting
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        var body: [String: Any] = [
            "base_url": baseURL,
            "category": category.rawValue,
            "message": message.trimmingCharacters(in: .whitespacesAndNewlines),
            "platform": "ios",
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        ]
        if !trimmedEmail.isEmpty { body["reporter_email"] = trimmedEmail }
        if let screenshotBase64 { body["screenshot_base64"] = screenshotBase64 }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        Task { @MainActor in
            do {
                let (_, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                state = .success
            } catch {
                state = .failure(
                    NSLocalizedString(
                        "We couldn't send your report. Check your connection and try again.",
                        comment: "LMS report failure"
                    )
                )
            }
        }
    }
}

// MARK: - Report this LMS sheet

/// The "Report this LMS" sheet shown from the Profile tab: pick a reason, add a
/// note, optionally attach a screenshot, and send it to the moderators.
struct ReportLMSView: View {
    @ObservedObject var viewModel: ReportLMSViewModel
    var onClose: () -> Void

    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        NavigationView {
            content
                .background(Theme.Colors.background.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: onClose) {
                            Text(viewModel.state == .success ? "Done" : "Cancel")
                                .foregroundColor(Theme.Colors.infoColor)
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.state == .success {
            successView
        } else {
            form
        }
    }

    private var form: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                section(title: "What's wrong?") {
                    VStack(spacing: 8) {
                        ForEach(LMSReportCategory.allCases) { category in
                            categoryRow(category)
                        }
                    }
                }

                section(title: "Tell us more") {
                    ZStack(alignment: .topLeading) {
                        if viewModel.message.isEmpty {
                            Text("Describe what happened")
                                .font(Theme.Fonts.bodyLarge)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .padding(.top, 12)
                                .padding(.horizontal, 12)
                        }
                        TextEditor(text: $viewModel.message)
                            .frame(minHeight: 110)
                            .padding(6)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    .background(Theme.Shapes.textInputShape.fill(Theme.Colors.textInputBackground))
                    .overlay(Theme.Shapes.textInputShape.stroke(lineWidth: 1).fill(Theme.Colors.textInputStroke))
                }

                section(title: "Screenshot (optional)") {
                    if let shot = viewModel.screenshot {
                        VStack(alignment: .leading, spacing: 8) {
                            Image(uiImage: shot)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Button {
                                viewModel.removeScreenshot()
                                photoItem = nil
                            } label: {
                                Text("Remove screenshot")
                                    .font(Theme.Fonts.labelLarge)
                                    .foregroundColor(Theme.Colors.alert)
                            }
                        }
                    } else {
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            HStack(spacing: 8) {
                                Image(systemName: "paperclip")
                                Text("Attach a screenshot")
                                    .font(Theme.Fonts.bodyLarge)
                            }
                            .foregroundColor(Theme.Colors.infoColor)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Theme.Shapes.textInputShape.fill(Theme.Colors.textInputBackground))
                            .overlay(
                                Theme.Shapes.textInputShape
                                    .stroke(lineWidth: 1)
                                    .fill(Theme.Colors.textInputStroke)
                            )
                        }
                    }
                }

                section(title: "Email (optional)") {
                    TextField("So we can follow up", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(14)
                        .background(Theme.Shapes.textInputShape.fill(Theme.Colors.textInputBackground))
                        .overlay(Theme.Shapes.textInputShape.stroke(lineWidth: 1).fill(Theme.Colors.textInputStroke))
                }

                if case .failure(let message) = viewModel.state {
                    Text(message)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundColor(Theme.Colors.alert)
                }

                submitButton
            }
            .padding(24)
        }
        .onChange(of: photoItem) { newItem in
            guard let newItem else { return }
            Task { @MainActor in
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    viewModel.attachScreenshot(data)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Report a problem")
                .font(Theme.Fonts.titleLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            Text(viewModel.lmsTitle)
                .font(Theme.Fonts.bodyLarge)
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textSecondary)
            content()
        }
    }

    private func categoryRow(_ category: LMSReportCategory) -> some View {
        let selected = viewModel.category == category
        return Button {
            viewModel.category = category
        } label: {
            HStack {
                Text(category.title)
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer()
                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(selected ? Theme.Colors.accentColor : Theme.Colors.textSecondary)
            }
            .padding(14)
            .background(
                Theme.Shapes.textInputShape
                    .fill(selected ? Theme.Colors.accentColor.opacity(0.12) : Theme.Colors.textInputBackground)
            )
            .overlay(
                Theme.Shapes.textInputShape
                    .stroke(lineWidth: 1)
                    .fill(selected ? Theme.Colors.accentColor.opacity(0.5) : Theme.Colors.textInputStroke.opacity(0.4))
            )
        }
        .buttonStyle(.plain)
    }

    private var submitButton: some View {
        Button(action: { viewModel.submit() }) {
            HStack(spacing: 10) {
                if viewModel.state == .submitting {
                    ProgressView()
                }
                Text("Send report")
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Theme.Shapes.buttonShape
                    .fill(viewModel.canSubmit ? Theme.Colors.accentColor : Theme.Colors.textSecondary.opacity(0.4))
            )
        }
        .disabled(!viewModel.canSubmit)
        .buttonStyle(.plain)
    }

    private var successView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(Theme.Colors.accentColor)
            Text("Thanks for the heads-up")
                .font(Theme.Fonts.titleLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            Text("A moderator will look into \(viewModel.lmsTitle) shortly.")
                .font(Theme.Fonts.bodyLarge)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
