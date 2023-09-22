//
//  SwiftUIHostController.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import SwiftUI
import Core

public class SwiftUIHostController<InnerView: View>: UIViewController {
    
    private var innerView: InnerView
    
    public init(view: InnerView) {
        self.innerView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: innerView)
        addChild(childView)
        view.addSubview(childView.view)
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            childView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            childView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            childView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            childView.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            childView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        childView.didMove(toParent: self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
}
