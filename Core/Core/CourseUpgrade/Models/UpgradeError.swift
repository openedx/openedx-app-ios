//
//  UpgradeError.swift
//  Core
//
//  Created by Vadim Kuznetsov on 22.05.24.
//

import StoreKit

public enum UpgradeError: Error, LocalizedError {
    case paymentsNotAvailable // device isn't allowed to make payments
    case paymentError(Error?) // unable to purchase a product
    case receiptNotAvailable(Error?) // unable to fetech inapp purchase receipt
    case basketError(Error) // basket API returns error
    case checkoutError(Error) // checkout API returns error
    case verifyReceiptError(Error) // verify receipt API returns error
    case productNotExist // product not existed on app appstore
    case generalError(Error?) // general error
    
    var errorString: String {
        switch self {
        case .basketError:
            return "basket"
        case .checkoutError:
            return "checkout"
        case .paymentError:
            return "payment"
        case .verifyReceiptError:
            return "execute"
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .basketError(let error):
            return basketErrorMessage(for: error as NSError)
        case .checkoutError(let error):
            return checkoutErrorMessage(for: error as NSError)
        case .paymentError:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        case .verifyReceiptError(let error):
            return executeErrorMessage(for: error as NSError)
        default:
            break
        }
        return nil
    }
    
    private func basketErrorMessage(for error: NSError) -> String {
        switch error.code {
        case 400:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseNotFount
        case 403:
            return CoreLocalization.CourseUpgrade.FailureAlert.authenticationErrorMessage
        case 406:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseAlreadyPaid
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        }
    }

    private func checkoutErrorMessage(for error: NSError) -> String {
        switch error.code {
        case 403:
            return CoreLocalization.CourseUpgrade.FailureAlert.authenticationErrorMessage
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        }
    }

    private func executeErrorMessage(for error: NSError) -> String {
        switch error.code {
        case 409:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseAlreadyPaid
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseNotFullfilled
        }
    }
    
    private var nestedError: Error? {
        switch self {
        case .receiptNotAvailable(let error):
            return error
        case .basketError(let error):
            return error
        case .checkoutError(let error):
            return error
        case .verifyReceiptError(let error):
            return error
        case .generalError(let error):
            return error
        case .paymentError(let error):
            return error
        default:
            return nil
        }
    }
    
    public var formattedError: String {
        let unhandledError = "unhandledError"
        guard let error = nestedError else { return unhandledError }
        return "\(errorString)-\((error as NSError).code)-\(error.localizedDescription)"
    }
    
    public var isCancelled: Bool {
        switch self {
        case .paymentError(let error):
            if let error = error as? SKError, error.code == .paymentCancelled {
                return true
            }
        default:
            break
        }
        return false
    }
}
