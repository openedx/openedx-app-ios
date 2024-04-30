//
//  CourseUpgradeHelper.swift
//  Core
//
//  Created by Saeed Bashir on 4/24/24.
//

import Foundation
import StoreKit

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

public class CourseUpgradeHelper {
    
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
    
    public init(
        config: ConfigProtocol,
        analytics: CoreAnalytics,
        courseID: String,
        pacing: String,
        blockID: String? = nil,
        localizedCoursePrice: String,
        screen: CourseUpgradeScreen
    ) {
        self.config = config
        self.analytics = analytics
        self.courseID = courseID
        self.pacing = pacing
        self.blockID = blockID
        self.localizedCoursePrice = localizedCoursePrice
        self.screen = screen
    }
    
    func handleCourseUpgrade(
        upgradeHadler: CourseUpgradeHandler,
        state: UpgradeCompletionState,
        delegate: CourseUpgradeHelperDelegate? = nil
    ) {
        self.delegate = delegate
        self.upgradeHadler = upgradeHadler
        
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
        guard let topController = UIApplication.topViewController() else { return }
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
        guard let topController = UIApplication.topViewController() else { return }
        
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
                style: .default) { [weak self] _ in
                    self?.trackUpgradeErrorAction(errorAction: .refreshToRetry)
                    Task {
//                        if let self {
//                            await self.upgradeHadler?.reverifyPayment()
//                        }
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
//            self?.launchEmailComposer(errorMessage: "Error: \(self?.upgradeHadler?.formattedError ?? "")")
        }

        alertController.addButton(withTitle: CoreLocalization.close, style: .default) { [weak self] _ in
            self?.trackUpgradeErrorAction(errorAction: .close)

//            if self?.unlockController.isVisible == true {
//                self?.unlockController.removeView() {
//                    self?.hideAlertAction()
//                }
//            }
//            else {
//                hideAlertAction()
//            }
        }
    }
    
    private func hideAlertAction() {
        delegate?.hideAlertAction()
        reset()
    }
}

extension CourseUpgradeHelper {
    func showLoader(forceShow: Bool = false) {
//        if (!unlockController.isVisible && upgradeHadler?.upgradeMode == .userInitiated) || forceShow {
//            unlockController.showView()
//        }
    }
    
    func removeLoader(
        success: Bool? = false,
        removeView: Bool? = false,
        completion: (()-> ())? = nil
    ) {
        self.completion = completion
        if success == true {
            helperModel = nil
        }
        
//        if unlockController.isVisible, removeView == true {
//            unlockController.removeView() { [weak self] in
//                self?.helperModel = nil
//                if success == true {
//                    self?.showSuccess()
//                } else {
//                    self?.showError()
//                }
//            }
//        } else if success == false {
//            showError()
//        }
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

extension Error {
    var errorCode: Int? {
        return (self as NSError).code
    }
}
