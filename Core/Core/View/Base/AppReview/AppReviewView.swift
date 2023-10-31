//
//  AppReviewView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.10.2023.
//

import SwiftUI

public struct AppReviewView: View {
        
    @ObservedObject private var viewModel: AppReviewViewModel

    @Environment (\.isHorizontal) private var isHorizontal
    @Environment (\.presentationMode) private var presentationMode
    
    public init(viewModel: AppReviewViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            if viewModel.showSelectMailClientView {
                SelectMailClientView(clients: viewModel.clients, onMailTapped: { client in
                    viewModel.openMailClient(client)
                })
            } else {
                VStack(spacing: 20) {
                    if viewModel.state == .thanksForFeedback || viewModel.state == .thanksForVote {
                        CoreAssets.favorite.swiftUIImage
                            .resizable()
                            .frame(width: isHorizontal ? 50 : 100,
                                   height: isHorizontal ? 50 : 100)
                            .foregroundColor(Theme.Colors.accentColor)
                            .onForeground {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                    }
                    Text(viewModel.state.title)
                        .font(Theme.Fonts.titleMedium)
                    Text(viewModel.state.description)
                        .font(Theme.Fonts.titleSmall)
                        .foregroundColor(Theme.Colors.avatarStroke)
                        .multilineTextAlignment(.center)
                    if viewModel.state == .vote {
                        StarRatingView(rating: $viewModel.rating)
                        
                        HStack(spacing: 28) {
                            Text("Not Now")
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentColor)
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            
                            AppReviewButton(type: .submit, action: {
                                viewModel.reviewAction()
                            }, isActive: .constant(viewModel.rating != 0))
                        }
                    } else if viewModel.state == .feedback {
                        TextEditor(text: $viewModel.feedback)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .hideScrollContentBackground()
                            .background(
                                Theme.Shapes.textInputShape
                                    .fill(Theme.Colors.commentCellBackground)
                            )
                            .overlay(
                                ZStack(alignment: .topLeading) {
                                    Theme.Shapes.textInputShape
                                        .stroke(lineWidth: 1)
                                        .fill(
                                            Theme.Colors.textInputStroke
                                        )
                                    if viewModel.feedback.isEmpty {
                                        Text("What could have been better?")
                                            .font(Theme.Fonts.bodyMedium)
                                            .foregroundColor(Theme.Colors.textSecondary)
                                            .padding(16)
                                    }
                                }
                            )
                            .frame(height: viewModel.showReview ? 162 : 0)
                            .opacity(viewModel.showReview ? 1 : 0)
                        
                        HStack(spacing: 28) {
                            Text("Not Now")
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentColor)
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            
                            AppReviewButton(type: .shareFeedback, action: {
                                viewModel.writeFeedbackToMail()
                            }, isActive: .constant(viewModel.feedback.count >= 3))
                        }
                    } else if viewModel.state == .thanksForVote {
                        HStack(spacing: 28) {
                            Text("Not Now")
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentColor)
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            
                            AppReviewButton(type: .rateUs, action: {
                                presentationMode.wrappedValue.dismiss()
                                viewModel.requestReview()
                            }, isActive: .constant(true))
                        }
                    }
                    
                }.padding(isHorizontal ? 40 : 40)
                    .background(Theme.Colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 400)
                    .padding(24)
                    .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 0)
            }
        }
    }
}

struct AppReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AppReviewView(viewModel: AppReviewViewModel(config: ConfigMock(), storage: CoreStorageMock()))
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1 ..< 6) { index in
                Group {
                    if index <= rating {
                        CoreAssets.star.swiftUIImage
                            .resizable()
                            .frame(width: 48, height: 48)
                    } else {
                        CoreAssets.starOutline.swiftUIImage
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}

struct SelectMailClientView: View {
    
    let clients: [ThirdPartyMailClient]
    
    var onMailTapped: (ThirdPartyMailClient) -> Void
    
    init(clients: [ThirdPartyMailClient], onMailTapped: @escaping (ThirdPartyMailClient) -> Void) {
        self.clients = clients
        self.onMailTapped = onMailTapped
    }
    
    @State var isOpen: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select email client:")
                        .font(Theme.Fonts.labelLarge)
                        .padding(.leading, 16)
                        .padding(.top, 8)
                    ScrollView(.horizontal) {
                        HStack {
                            Image(.defaultMail).resizable()
                                .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.leading, 14)
                                    .shadow(color: .black.opacity(0.2), radius: 8)
                                    
                            ForEach(clients, id: \.name) { client in
                                Group {
                                    Button(action: {
                                        onMailTapped(client)
                                    }, label: {
                                        client.icon?.resizable()
                                    })
                                }.frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: .black.opacity(0.2), radius: 8)
                                    .padding(.leading, 4)
                                    .padding(.vertical, 16)
                            }
                        }
                    }
                    
                }.background( Theme.Colors.background)
                    .offset(y: isOpen ? 0 : 200)
            }
        }.onAppear {
            withAnimation(Animation.bouncy.delay(0.3)) {
                isOpen = true
            }
        }
    }
}

struct SelectMailClientView_Previews: PreviewProvider {
    static var previews: some View {
        
        let clients: [ThirdPartyMailClient] = [
            ThirdPartyMailClient(name: "googlegmail", icon: Image(.googlegmail), URLScheme: ""),
            ThirdPartyMailClient(name: "readdle-spark", icon: Image(.readdleSpark), URLScheme: ""),
        ThirdPartyMailClient(name: "airmail", icon: Image(.airmail), URLScheme: ""),
        ThirdPartyMailClient(name: "ms-outlook", icon: Image(.msOutlook), URLScheme: ""),
        ThirdPartyMailClient(name: "ymail", icon: Image(.ymail), URLScheme: ""),
        ThirdPartyMailClient(name: "fastmail", icon: Image(.fastmail), URLScheme: ""),
        ThirdPartyMailClient(name: "protonmail", icon: Image(.proton), URLScheme: "")
        ]
        
        SelectMailClientView(clients: clients, onMailTapped: { _ in
            
        })
    }
}

struct AppReviewButton: View {
    let type: ButtonType
    let action: () -> Void
    @Binding var isActive: Bool
    
    enum ButtonType {
        case submit, shareFeedback, rateUs
    }
    
    var body: some View {
        Button(action: {
            if isActive { action() }
        }, label: {
        Group {
            HStack(spacing: 4) {
                Text(type == .submit ? "Submit"
                     : (type == .shareFeedback ? "Share Feedback" : "Rate Us" ))
                .foregroundColor(isActive ? Color.white : Color.black.opacity(0.6))
                .font(Theme.Fonts.labelLarge)
                .padding(3)
                
            }.padding(.horizontal, 20)
                .padding(.vertical, 9)
        }.fixedSize()
            .background(isActive
                        ? Theme.Colors.accentColor
                        : Theme.Colors.cardViewStroke)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(type == .submit ? "WhatsNewLocalization.buttonPrevious"
                                : (type == .shareFeedback ? "WhatsNewLocalization.buttonNext" : "WhatsNewLocalization.buttonDone" ))
            .cornerRadius(8)
        })
    }
}
