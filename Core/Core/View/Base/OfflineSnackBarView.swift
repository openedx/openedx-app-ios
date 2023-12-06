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
                    Spacer()
                    Button(CoreLocalization.NoInternet.dismiss,
                           action: {
                        withAnimation {
                            dismiss = true
                        }
                    })
                    Button(CoreLocalization.NoInternet.reload,
                           action: {
                        Task {
                            await reloadAction()
                        }
                        withAnimation {
                            dismiss = true
                        }
                    })
                }.padding(.horizontal, 16)
                    .font(Theme.Fonts.titleSmall)
                    .frame(maxWidth: .infinity, maxHeight: OfflineSnackBarView.height)
                    .background(Theme.Colors.warning.ignoresSafeArea())
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
        OfflineSnackBarView(connectivity: Connectivity(), reloadAction: {})
    }
}
