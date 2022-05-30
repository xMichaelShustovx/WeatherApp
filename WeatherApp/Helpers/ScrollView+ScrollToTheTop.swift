
import UIKit

extension UIScrollView {
    
    func scrollToTop() {
        let offsetNeeded = CGPoint(x: 0, y: -47)
        setContentOffset(offsetNeeded, animated: true)
    }
}
