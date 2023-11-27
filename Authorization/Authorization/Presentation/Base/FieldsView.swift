//
//  FieldsView.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 28.10.2022.
//

import SwiftUI
import Core

struct FieldsView: View {
    
    let fields: [FieldConfiguration]
    let router: BaseRouter
    let config: ConfigProtocol
    let cssInjector: CSSInjector
    let proxy: GeometryProxy
    @Environment(\.colorScheme) var colorScheme
    @State private var text: String = ""
    
    var body: some View {
        ForEach(0..<fields.count, id: \.self) { index in
            let config = fields[index]
            
            switch config.field.type {
            case .text:
                RegistrationTextField(config: config)
                    .id(index)
            case .email, .confirm_email:
                RegistrationTextField(
                    config: config,
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
                )
                .id(index)
            case .password:
                RegistrationTextField(
                    config: config,
                    keyboardType: .default,
                    textContentType: .password
                )
                .id(index)
            case .select:
                PickerView(config: config, router: router)
                    .id(index)
            case .textarea:
                RegistrationTextField(
                    config: config,
                    isTextArea: true,
                    keyboardType: .default,
                    textContentType: .password
                )
                
            case .checkbox:
                EmptyView()
                    .id(index)
                Text("Checkbox is not support")
            case .plaintext:
                HTMLFormattedText(
                    cssInjector.injectCSS(
                        colorScheme: colorScheme,
                        html: config.field.label,
                        type: .discovery,
                        fontSize: 90, screenWidth: proxy.size.width)
                )
                .id(UUID())
                .padding(.horizontal, -6)
                
            case .unknown:
                Text("This field not support")
            }
        }
    }
}

#if DEBUG
struct FieldsView_Previews: PreviewProvider {
    static var previews: some View {
        let fields = [
            FieldConfiguration(field: PickerFields(
                type: .text,
                label: "User Name",
                required: true,
                name: "name",
                instructions: "Enter your name.",
                options: [])
            ),
            FieldConfiguration(field: PickerFields(
                type: .email,
                label: "Email",
                required: true,
                name: "email",
                instructions: "This is what you will use to login.",
                options: [])
            ),
            FieldConfiguration(field: PickerFields(
                type: .text,
                label: "Password",
                required: true,
                name: "password",
                instructions: "Your password must contain minimum 2 characters.",
                options: [])
            )
        ]
        VStack {
            GeometryReader { proxy in
                FieldsView(
                    fields: fields,
                    router: AuthorizationRouterMock(),
                    config: ConfigMock(),
                    cssInjector: CSSInjectorMock(),
                    proxy: proxy
                )
            }
        }.padding()
    }
}
#endif
