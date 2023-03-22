//
//  EncodedVideoPlayer.swift
//  Course
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import SwiftUI
import _AVKit_SwiftUI
import Core
import Swinject

public struct EncodedVideoPlayer: View {
    
    private var controller = AVPlayerViewController()
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var orientation = UIDevice.current.orientation
    @State private var isLoading: Bool = true
    @State private var isAnimating: Bool = false
    @State private var isViewedOnce: Bool = false
    @State private var isOrientationChanged: Bool = false
    @Binding private var killPlayer: Bool
    @State var showAlert = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
        
    public var isViewed: ((Bool) -> Void)
    private let url: URL?
    
    public init(
        url: URL?,
        isViewed: @escaping ((Bool) -> Void),
        killPlayer: Binding<Bool>
    ) {
        self.url = url
        self.isViewed = isViewed
        self._killPlayer = killPlayer
    }
    
    public var body: some View {
        ZStack {
            VStack {
                PlayerViewController(
                    videoURL: url,
                    controller: controller,
                    progress: { progress in
                        if progress >= 0.8 {
                            if !isViewedOnce {
                                self.isViewed(true)
                                isViewedOnce = true
                            }
                        }
                    })
                .aspectRatio(16 / 9, contentMode: .fit)
                .onReceive(NotificationCenter.Publisher(
                    center: .default,
                    name: UIDevice.orientationDidChangeNotification)) { _ in
                        self.orientation = UIDevice.current.orientation
                        if self.orientation.isLandscape {
                            controller.enterFullScreen(animated: true)
                            controller.player?.play()
                            isOrientationChanged = true
                        } else {
                            if isOrientationChanged {
                                controller.exitFullScreen(animated: true)
                                controller.player?.pause()
                                isOrientationChanged = false
                            }
                        }
                    }
                Spacer()
                if !orientation.isLandscape || idiom != .pad {
                    VStack {}.onAppear {
                        isLoading = false
                        alertMessage = CourseLocalization.Alert.rotateDevice
                    }
                }
                
                // MARK: - Alert
                if showAlert {
                    Spacer()
                    VStack(alignment: .center) {
                        Spacer()
                        HStack(spacing: 6) {
                            CoreAssets.rotateDevice.swiftUIImage.renderingMode(.template)
                            Text(alertMessage ?? "")
                        }.shadowCardStyle(bgColor: CoreAssets.accentColor.swiftUIColor,
                                          textColor: .white)
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                alertMessage = nil
                                showAlert = false
                            }
                        }
                    }
                }
            }.onChange(of: killPlayer, perform: { _ in
                controller.player?.replaceCurrentItem(with: nil)
            })
        }
    }
}

struct EncodedVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EncodedVideoPlayer(url: URL(string: ""), isViewed: {_ in }, killPlayer: .constant(true))
    }
}
