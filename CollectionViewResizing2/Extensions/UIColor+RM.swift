// See https://medium.com/ios-os-x-development/ios-extend-uicolor-with-custom-colors-93366ae148e6

import UIKit

// https://stackoverflow.com/a/40810305/2431627
// (-1.0...1.0).random()
extension ClosedRange where Bound : FloatingPoint {
    public func random() -> Bound {
        let max = UInt32.max
        return
            Bound(arc4random_uniform(max)) /
                Bound(max) *
                (upperBound - lowerBound) +
        lowerBound
    }
}

extension UIColor {
    static var Random: UIColor {
        return UIColor(
            red: (0.0...1.0).random(),
            green: (0.0...1.0).random(),
            blue: (0.0...1.0).random(),
            alpha: 1.0)
    }
}
