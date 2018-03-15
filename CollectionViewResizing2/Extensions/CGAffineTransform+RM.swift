import UIKit

extension CGAffineTransform {
    var xScale: CGFloat { return sqrt(self.a * self.a + self.c * self.c) }
    var yScale: CGFloat { return sqrt(self.b * self.b + self.d * self.d) }
    var rotation: CGFloat { return CGFloat(atan2f(Float(self.b), Float(self.a))) }
}
