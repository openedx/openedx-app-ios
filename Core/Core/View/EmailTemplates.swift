//
//  EmailTemplates.swift
//  Core
//
//  Created by Saeed Bashir on 5/15/24.
//

import Foundation
import UIKit

public class EmailTemplates {
    public class func contactSupport(email: String, emailSubject: String, errorMessage: String? = nil) -> URL? {
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let deviceModel = UIDevice.current.model
        let feedbackDetails = "OS version: \(osVersion)\nApp version: \(appVersion)\nDevice model: \(deviceModel)"
        
        var emailBody = "\n\n\(email)\n".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let errorMessage {
            emailBody.append(errorMessage)
        }
        
        let emailURL = URL(string: "mailto:\(email)?subject=\(emailSubject)&body=\(emailBody)")
        
        return emailURL
    }
}
