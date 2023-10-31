//
//  SelectMailClientView.swift
//  Core
//
//  Created by  Stepanok Ivan on 31.10.2023.
//

import SwiftUI

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
                    Text(CoreLocalization.Review.Email.title)
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
