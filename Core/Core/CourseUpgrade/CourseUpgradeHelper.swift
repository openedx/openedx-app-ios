//
//  CourseUpgradeHelper.swift
//  Core
//
//  Created by Saeed Bashir on 4/24/24.
//

import Foundation
import StoreKit
import SwiftUI
import MessageUI

public struct CourseUpgradeHelperModel {
    let courseID: String
    let blockID: String?
    let screen: CourseUpgradeScreen
}

public enum UpgradeCompletionState {
    case initial
    case payment
    case fulfillment(showLoader: Bool)
    case success(_ courseID: String, _ componentID: String?)
    case error(UpgradeError, Error?)
}

// These error actions are used to send in analytics
public enum UpgradeErrorAction: String {
    case refreshToRetry = "refresh"
    case reloadPrice = "reload_price"
    case emailSupport = "get_help"
    case close = "close"
}

// These alert actions are used to send in analytics
public enum UpgradeAlertAction: String {
    case close
    case continueWithoutUpdate = "continue_without_update"
    case getHelp = "get_help"
    case refresh
}
public protocol CourseUpgradeHelperDelegate: AnyObject {
    func hideAlertAction()
}

public class CourseUpgradeHelper: NSObject {
    
    weak private(set) var delegate: CourseUpgradeHelperDelegate?
    private(set) var completion: (() -> Void)?
    private(set) var helperModel: CourseUpgradeHelperModel?
    private(set) var config: ConfigProtocol
    private(set) var analytics: CoreAnalytics
    
    private var pacing: String?
    private var courseID: String?
    private var blockID: String?
    private var screen: CourseUpgradeScreen = .unknown
    private var localizedCoursePrice: String?
    weak private(set) var upgradeHadler: CourseUpgradeHandler?
    private var unlockController: UIHostingController<CourseUpgradeUnlockView>?
    private var topController: UIViewController?
    
    public init(
        config: ConfigProtocol,
        analytics: CoreAnalytics
    ) {
        self.config = config
        self.analytics = analytics
        
    }
    
    public func setData(
        courseID: String,
        pacing: String,
        blockID: String? = nil,
        localizedCoursePrice: String,
        screen: CourseUpgradeScreen
    ) {
        self.courseID = courseID
        self.pacing = pacing
        self.blockID = blockID
        self.localizedCoursePrice = localizedCoursePrice
        self.screen = screen
    }
    
    public func handleCourseUpgrade(
        upgradeHadler: CourseUpgradeHandler,
        state: UpgradeCompletionState,
        delegate: CourseUpgradeHelperDelegate? = nil
    ) {
        self.delegate = delegate
        self.upgradeHadler = upgradeHadler
        topController = UIApplication.topViewController()
        
        switch state {
        case .fulfillment(let show):
            if show {
                showLoader()
            }
        case .success(let courseID, let blockID):
            helperModel = CourseUpgradeHelperModel(courseID: courseID, blockID: blockID, screen: screen)
            if upgradeHadler.upgradeMode == .userInitiated {
                postSuccessNotification()
            } else {
                showSilentRefreshAlert()
            }
        case .error(let type, let error):
            if type == .paymentError {
                if let error = error as? SKError, error.code == .paymentCancelled {
                    analytics.trackCourseUpgradePaymentError(
                        .courseUpgradePaymentCancelError,
                        biValue: .courseUpgradePaymentCancelError,
                        courseID: courseID ?? "",
                        blockID: blockID,
                        pacing: pacing ?? "",
                        coursePrice: localizedCoursePrice ?? "",
                        screen: screen,
                        error: upgradeHadler.formattedError
                    )
                } else {
                    analytics.trackCourseUpgradePaymentError(
                        .courseUpgradePaymentError,
                        biValue: .courseUpgradePaymentError,
                        courseID: courseID ?? "",
                        blockID: blockID,
                        pacing: pacing ?? "",
                        coursePrice: localizedCoursePrice ?? "",
                        screen: screen,
                        error: upgradeHadler.formattedError
                    )
                }
            } else {
                analytics.trackCourseUpgradeError(
                    courseID: courseID ?? "",
                    blockID: blockID,
                    pacing: pacing ?? "",
                    coursePrice: localizedCoursePrice ?? "",
                    screen: screen,
                    error: upgradeHadler.formattedError,
                    flowType: upgradeHadler.upgradeMode.rawValue
                )
            }
            
            removeLoader(success: false, removeView: type != .verifyReceiptError)
        
        default:
            break
        }
    }
    
    private func postSuccessNotification() {
        NotificationCenter.default.post(name: .unfullfilledTransctionsNotification, object: nil)
    }
    
    public func resetUpgradeModel() {
        helperModel = nil
        delegate = nil
    }
    
    private func reset() {
        pacing = nil
        courseID = nil
        blockID = nil
        localizedCoursePrice = nil
        screen = .unknown
        resetUpgradeModel()
    }
}

extension CourseUpgradeHelper {
    func showSuccess() {
        guard let topController = topController else { return }
        
//        topController.showBottomActionSnackBar(
//            message: CoreLocalization.CourseUpgrade.successMessage,
//            textSize: .xSmall,
//            autoDismiss: true,
//            duration: 3
//        )

        analytics.trackCourseUpgradeSuccess(
            courseID: courseID ?? "",
            blockID: blockID,
            pacing: pacing ?? "",
            coursePrice: localizedCoursePrice ?? "",
            screen: screen,
            flowType: upgradeHadler?.upgradeMode.rawValue ?? ""
        )
        reset()
    }
    
    func showError() {
        guard let topController = topController else { return }
        
        // not showing any error if payment is canceled by user
        if case .error(let type, let error) = upgradeHadler?.state, type == .paymentError,
           let error = error as? SKError, error.code == .paymentCancelled {
            return
        }

        let alertController = UIAlertController().showAlert(
            withTitle: CoreLocalization.CourseUpgrade.FailureAlert.alertTitle,
            message: upgradeHadler?.errorMessage,
            onViewController: topController) { _, _, _ in }

        if case .error(let type, let error) = upgradeHadler?.state,
           type == .verifyReceiptError && error?.errorCode != 409 {
            alertController.addButton(
                withTitle: CoreLocalization.CourseUpgrade.FailureAlert.refreshToRetry,
                style: .default) { _ in
                    self.trackUpgradeErrorAction(errorAction: .refreshToRetry)
                    Task {
                        await self.upgradeHadler?.reverifyPayment()
                    }
                }
        }

        if case .complete = upgradeHadler?.state, completion != nil {
            alertController.addButton(
                withTitle: CoreLocalization.CourseUpgrade.FailureAlert.refreshToRetry,
                style: .default) {[weak self] _ in
                    self?.trackUpgradeErrorAction(errorAction: .refreshToRetry)
                    self?.showLoader()
                    self?.completion?()
                    self?.completion = nil
                }
        }

        alertController.addButton(withTitle: CoreLocalization.CourseUpgrade.FailureAlert.getHelp) { [weak self] _ in
            self?.trackUpgradeErrorAction(errorAction: .emailSupport)
            self?.launchEmailComposer(errorMessage: "Error: \(self?.upgradeHadler?.formattedError ?? "")")
        }

        alertController.addButton(withTitle: CoreLocalization.close, style: .default) { [weak self] _ in
            self?.trackUpgradeErrorAction(errorAction: .close)
            
            if self?.unlockController != nil {
                self?.removeLoader()
                self?.hideAlertAction()
            } else {
                self?.hideAlertAction()
            }
        }
    }
    
    private func hideAlertAction() {
        delegate?.hideAlertAction()
        reset()
    }
}

extension CourseUpgradeHelper {
    public func showLoader(forceShow: Bool = false) {
        guard let topController = topController, unlockController == nil else { return }
        let unlockView = CourseUpgradeUnlockView()
        
        unlockController = UIHostingController(rootView: unlockView)
        unlockController?.modalTransitionStyle = .crossDissolve
        unlockController?.modalPresentationStyle = .overFullScreen
        
        topController.navigationController?.present(unlockController!, animated: true)
    }
    
    public func removeLoader(
        success: Bool? = false,
        removeView: Bool? = false,
        completion: (() -> Void)? = nil
    ) {
        self.completion = completion
        if success == true {
            helperModel = nil
        }
        
        if unlockController != nil, removeView == true {
            unlockController = nil
            
            if let controller = topController?.navigationController?
                .presentedViewController as? UIHostingController<CourseUpgradeUnlockView> {
                controller.dismiss(animated: true)
            }
            
            helperModel = nil
            
            if success == true {
                showSuccess()
            } else {
                showError()
            }
        } else if success == false {
            showError()
        }
    }
}

extension CourseUpgradeHelper {
    private func showSilentRefreshAlert() {
        guard let topController = UIApplication.topViewController() else { return }

        let alertController = UIAlertController().alert(
            withTitle: CoreLocalization.CourseUpgrade.SuccessAlert.silentAlertTitle,
            message: CoreLocalization.CourseUpgrade.SuccessAlert.silentAlertMessage) { _, _, _ in }

        alertController.addButton(
            withTitle: CoreLocalization.CourseUpgrade.SuccessAlert.silentAlertRefresh,
            style: .default) {[weak self] _ in
                self?.showLoader(forceShow: true)
                //            self?.popToEnrolledCourses()
            }

        alertController.addButton(
            withTitle: CoreLocalization.CourseUpgrade.SuccessAlert.silentAlertContinue,
            style: .default) {[weak self] _ in
            self?.reset()
        }

        topController.present(alertController, animated: true, completion: nil)
    }
}

extension CourseUpgradeHelper {
    private func trackUpgradeErrorAction(errorAction: UpgradeErrorAction) {
        analytics.trackCourseUpgradeErrorAction(
            courseID: courseID ?? "",
            blockID: blockID,
            pacing: pacing ?? "",
            coursePrice: localizedCoursePrice,
            screen: screen,
            errorAction: errorAction.rawValue,
            error: upgradeHadler?.formattedError ?? "",
            flowType: upgradeHadler?.upgradeMode.rawValue ?? ""
        )
    }
}

extension CourseUpgradeHelper {
    func launchEmailComposer(errorMessage: String) {
        guard let emailURL = EmailTemplates.contactSupport(
            email: config.feedbackEmail,
            emailSubject: CoreLocalization.CourseUpgrade.supportEmailSubject,
            errorMessage: errorMessage
        ), UIApplication.shared.canOpenURL(emailURL) else {
            
            UIAlertController().showAlert(
                withTitle: CoreLocalization.CourseUpgrade.emailNotSetupTitle,
                message: CoreLocalization.Error.cannotSendEmail,
                onViewController: topController!
            )
            
            return
        }
        
        UIApplication.shared.open(emailURL)
    }
}

extension Error {
    var errorCode: Int? {
        return (self as NSError).code
    }
}
