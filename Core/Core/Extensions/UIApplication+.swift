//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    func endEditing(force: Bool = true) {
        windows.forEach { $0.endEditing(force) }
    }
}
