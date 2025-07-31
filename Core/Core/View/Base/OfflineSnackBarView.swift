//
//  OfflineSnackBarView.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.02.2023.
//

import SwiftUI
import Combine
import Theme

public struct OfflineSnackBarView: View {
    
    public static let height: CGFloat = 50
    
    @State private var dismiss: Bool = false
    private var reloadAction: () async -> Void
    private let connectivity: ConnectivityProtocol
    
    public init(connectivity: ConnectivityProtocol, reloadAction: @escaping () async -> Void) {
        self.connectivity = connectivity
        self.reloadAction = reloadAction
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    Text(CoreLocalization.NoInternet.offline)
                        .accessibilityIdentifier("no_internet_text")
                    Spacer()
                    Button(action: {
                        withAnimation {
                            dismiss = true
                        }
                    }, label: {
                        Text(CoreLocalization.NoInternet.dismiss)
                    })
                    .accessibilityIdentifier("no_internet_dismiss_button")
                    Button(action: {
                        Task {
                            await reloadAction()
                        }
                        withAnimation {
                            dismiss = true
                        }
                    }, label: {
                        Text(CoreLocalization.NoInternet.reload)
                    }
                    )
                    .accessibilityIdentifier("no_internet_reload_button")
                }.padding(.horizontal, 16)
                    .font(Theme.Fonts.titleSmall)
                    .frame(maxWidth: .infinity, maxHeight: OfflineSnackBarView.height)
                    .background(Theme.Colors.snackbarWarningColor.ignoresSafeArea())
            }
        }
        .onAppear {
            dismiss = connectivity.isInternetAvaliable
        }
        .offset(y: dismiss ? 100 : 0)
        .opacity(dismiss ? 0 : 1)
        .transition(.move(edge: .bottom))
        .onReceive(connectivity.internetReachableSubject, perform: { state in
            switch state {
            case .notReachable:
                withAnimation {
                    dismiss = false
                }
            case .reachable:
                break
            case .none:
                break
            }
        })
    }
}

struct OfflineSnackBarView_Previews: PreviewProvider {
    static var previews: some View {
        let configMock = ConfigMock()
        OfflineSnackBarView(connectivity: Connectivity(config: configMock), reloadAction: {})
    }
}
