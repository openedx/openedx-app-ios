//
//  ProfileBottomSheet.swift
//  Profile
//
//  Created by  Stepanok Ivan on 01.03.2023.
//

import SwiftUI
import Core

struct ProfileBottomSheet: View {
    
    @State private var yPosition: CGFloat = 0
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
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
    
    @Environment (\.isHorizontal) private var isHorizontal
    
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
        ZStack(alignment: .bottom) {
            if showingBottomSheet {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingBottomSheet = false
                        }
                    }
            }
            VStack {
                VStack {
                    VStack(alignment: .center, spacing: 4) {
                        HStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 2, style: .circular)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .frame(width: 31, height: 4)
                                .padding(.top, 4)
                        }.frame(maxWidth: .infinity)
                        
                        Text(ProfileLocalization.Edit.BottomSheet.title)
                            .font(Theme.Fonts.titleLarge)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 14)
                        
                        button(title: ProfileLocalization.Edit.BottomSheet.select,
                               type: .gallery,
                               action: {
                            openGallery()
                        })
                        
                        button(title: ProfileLocalization.Edit.BottomSheet.remove,
                               type: .remove,
                               action: {
                            removePhoto()
                        })
                        .padding(.top, 10)
                        
                        button(title: ProfileLocalization.Edit.BottomSheet.cancel,
                               type: .cancel,
                               action: {
                            withAnimation {
                                showingBottomSheet = false
                            }
                        }).padding(.top, 34)
                    }.padding(.horizontal, 24)
                    
                }
                .frame(minWidth: 0,
                         maxWidth: (idiom == .pad || (idiom == .phone && isHorizontal))
                         ? 330
                         : .infinity,
                       maxHeight: 290, alignment: .topLeading)
                    .background(Theme.Colors.cardViewBackground)
                    .cornerRadius(8)
                    .padding(.horizontal, 22)
            }
            .offset(y: showingBottomSheet ? yPosition : 700)
            .gesture(dragGesture)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func button(title: String, type: ButtonType, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .center) {
                switch type {
                case .gallery:
                    CoreAssets.gallery.swiftUIImage
                case .remove:
                    CoreAssets.removePhoto.swiftUIImage
                case .cancel:
                    EmptyView()
                }
                Text(title)
                    .foregroundColor(type.textColor())
                    .font(Theme.Fonts.labelLarge)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 48)
        .background(
            Theme.Shapes.buttonShape
                .fill(type.bgColor())
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(type.frameColor())
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
        
        func bgColor() -> Color {
            switch self {
            case .gallery:
                return Theme.Colors.accentColor
            case .remove:
                return .clear
            case .cancel:
                return .clear
            }
        }
        
        func frameColor() -> Color {
            switch self {
            case .gallery:
                return Theme.Colors.accentColor
            case .remove:
                return Theme.Colors.alert
            case .cancel:
                return Theme.Colors.textInputStroke
            }
        }
        
        func textColor() -> Color {
            switch self {
            case .gallery:
                return .white
            case .remove:
                return Theme.Colors.alert
            case .cancel:
                return Theme.Colors.textPrimary
            }
        }
    }
}
