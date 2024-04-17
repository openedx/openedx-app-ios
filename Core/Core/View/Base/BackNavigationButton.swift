//
//  BackNavigationButton.swift
//  Core
//
//  Created by Vadim Kuznetsov on 3.04.24.
//

import SwiftUI
import Theme

class BackButton: UIButton {
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        return .zero
    }
}

public struct BackNavigationButtonRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: BackNavigationButtonViewModel
    var action: (() -> Void)?
    var color: Color

    init(action: (() -> Void)? = nil, color: Color, viewModel: BackNavigationButtonViewModel) {
        self.viewModel = viewModel
        self.action = action
        self.color = color
    }
    
    public func makeUIView(context: Context) -> UIButton {
        let button = BackButton(type: .custom)
        let image = CoreAssets.arrowLeft.image.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(color)
        button.contentHorizontalAlignment = .leading
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonAction), for: .touchUpInside)
        button.accessibilityIdentifier = "back_button"
        return button
    }

    public func updateUIView(_ button: UIButton, context: Context) {
        var actions: [UIAction] = []
        for item in viewModel.items {
            let action = UIAction(title: item.title) {[weak viewModel] _ in
                viewModel?.navigateTo(item: item)
            }
            actions.append(action)
        }
        button.menu = UIMenu(title: "", children: actions)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    public class Coordinator: NSObject {
        var action: (() -> Void)?
        init(action: (() -> Void)?) {
            self.action = action
        }
        
        @objc func buttonAction() {
            action?()
        }
    }
}

public struct BackNavigationButton: View {
    @StateObject var viewModel = BackNavigationButtonViewModel()
    private let color: Color
    private let action: (() -> Void)?
    
    public init(
        color: Color = Theme.Colors.accentXColor,
        action: (() -> Void)? = nil
    ) {
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        BackNavigationButtonRepresentable(action: action, color: color, viewModel: viewModel)
        .onAppear {
            viewModel.loadItems()
        }
        
    }
}
#if DEBUG
struct BackNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        BackNavigationButton()
    }
}
#endif
