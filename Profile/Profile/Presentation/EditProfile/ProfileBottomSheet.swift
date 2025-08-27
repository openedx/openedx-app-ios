//
//  ProfileBottomSheet.swift
//  Profile
//
//  Created by  Stepanok Ivan on 01.03.2023.
//

import SwiftUI
import Core
import Theme

struct ProfileBottomSheet: View {
    
    @State private var yPosition: CGFloat = 0
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @EnvironmentObject var themeManager: ThemeManager
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.location.y >= 0 {
                    self.yPosition = value.location.y
                    if value.location.y >= 50 {
                        withAnimation {
                            showingBottomSheet = false
                            yPosition = 0
                        }
                    }
                }
            }
            .onEnded { value in
                if value.location.y <= 50 {
                    withAnimation {
                        yPosition = 0
                    }
                }
            }
    }
    
    private var openGallery: () -> Void
    private var removePhoto: () -> Void
    @Binding private var showingBottomSheet: Bool
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    private var maxWidth: CGFloat {
        idiom == .pad || (idiom == .phone && isHorizontal) ? 330 : .infinity
    }
    
    init(
        showingBottomSheet: Binding<Bool>,
        openGallery: @escaping () -> Void,
        removePhoto: @escaping () -> Void
    ) {
        self._showingBottomSheet = showingBottomSheet
        self.openGallery = openGallery
        self.removePhoto = removePhoto
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                if showingBottomSheet {
                    background
                        .onTapGesture {
                            withAnimation {
                                showingBottomSheet = false
                            }
                        }
                }
                content
                .offset(y: showingBottomSheet ? yPosition : proxy.size.height)
                .gesture(dragGesture)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
    private var background: some View {
        Color.black
            .opacity(0.5)
            .ignoresSafeArea()
    }
    
    private var content: some View {
        VStack {
            VStack {
                VStack(alignment: .center, spacing: 4) {
                    HStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .foregroundColor(themeManager.theme.colors.textSecondary)
                            .frame(width: 31, height: 4)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text(ProfileLocalization.Edit.BottomSheet.title)
                        .font(Theme.Fonts.titleLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                        .accessibilityIdentifier("profile_bottom_sheet_title_text")
                    
                    button(title: ProfileLocalization.Edit.BottomSheet.select,
                           type: .gallery,
                           action: {
                        openGallery()
                    })
                    .accessibilityIdentifier("select_picture_button")
                    
                    button(title: ProfileLocalization.Edit.BottomSheet.remove,
                           type: .remove,
                           action: {
                        removePhoto()
                    })
                    .padding(.top, 10)
                    .accessibilityIdentifier("remove_picture_button")
                    
                    button(title: ProfileLocalization.Edit.BottomSheet.cancel,
                           type: .cancel,
                           action: {
                        withAnimation {
                            showingBottomSheet = false
                        }
                    })
                    .padding(.top, 34)
                    .accessibilityIdentifier("cancel_button")
                }
                .padding(.horizontal, 24)
            }
            .frame(minWidth: 0,
                   maxWidth: maxWidth,
                   maxHeight: 290, alignment: .topLeading)
            .background(themeManager.theme.colors.cardViewBackground)
            .cornerRadius(8)
            .padding(.horizontal, 22)
        }
    }

    private func button(title: String, type: ButtonType, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .center) {
                switch type {
                case .gallery:
                    CoreAssets.gallery.swiftUIImage.renderingMode(.template)
                        .foregroundColor(themeManager.theme.colors.primaryButtonTextColor)
                case .remove:
                    CoreAssets.removePhoto.swiftUIImage
                case .cancel:
                    EmptyView()
                }
                Text(title)
                    .foregroundColor(type.textColor(using: themeManager))
                    .font(Theme.Fonts.labelLarge)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 48)
        .background(
            Theme.Shapes.buttonShape
                .fill(type.bgColor(using: themeManager))
        )
        .overlay(
            Theme.Shapes.buttonShape
                .stroke(style: .init(
                    lineWidth: 1,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 1)
                )
                .foregroundColor(
                    type.frameColor(using: themeManager)
                )
        )
    }
}

struct ProfileBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ProfileBottomSheet(showingBottomSheet: .constant(true), openGallery: {}, removePhoto: {})
                .loadFonts()
                
        }
    }
}

extension ProfileBottomSheet {
    enum ButtonType: Equatable {
        case gallery
        case remove
        case cancel
        
        func bgColor(using themeManager: ThemeManager) -> Color {
            switch self {
            case .gallery:
                return themeManager.theme.colors.accentColor
            case .remove:
                return .clear
            case .cancel:
                return .clear
            }
        }
        
        func frameColor(using themeManager: ThemeManager) -> Color {
            switch self {
            case .gallery:
                return themeManager.theme.colors.accentColor
            case .remove:
                return themeManager.theme.colors.alert
            case .cancel:
                return themeManager.theme.colors.textInputStroke
            }
        }
        
        func textColor(using themeManager: ThemeManager) -> Color {
            switch self {
            case .gallery:
                return themeManager.theme.colors.primaryButtonTextColor
            case .remove:
                return themeManager.theme.colors.alert
            case .cancel:
                return themeManager.theme.colors.textPrimary
            }
        }
    }
}
