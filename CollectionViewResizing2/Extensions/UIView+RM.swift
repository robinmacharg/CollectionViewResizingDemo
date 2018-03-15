// https://stackoverflow.com/a/24590678/2431627

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// https://bradbambara.wordpress.com/2015/07/06/interface-builder-tricks/

private var stringTagHandle: UInt8 = 0

extension UIView {
    
    //use Objective C Associated Object API to add this property to UIView
    @IBInspectable public var stringTag:String? {
        get {
            if let object = objc_getAssociatedObject(self, &stringTagHandle) as? String {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &stringTagHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // this should work in a similar way to viewWithTag:
    public func viewWithStringTag(strTag:String) -> UIView? {
        
        if stringTag == strTag {
            return self
        }
        
        for view in subviews {
            if let matchingSubview = view.viewWithStringTag(strTag: strTag) {
                return matchingSubview
            }
        }
        
        return nil
    }
}

// https://stackoverflow.com/a/1823360/2431627

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        else {
            for view in self.subviews {
                let responder: UIView? = view.findFirstResponder()
                if responder != nil {
                    return responder
                }
            }
        }
        return nil
    }
}

// https://swiftexample.info/code/uiview-extension-swift/
extension UIView {
    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize  {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var top : CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var bottom : CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var right : CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    var left : CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x  = newValue
            self.frame = frame
        }
    }
}

// https://stackoverflow.com/a/36388769/2431627
//extension UIView {
//    class func fromNib<T: UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
//    }
//}

extension UIView {
    class func fromNib<T: UIView>(ofType theType: T.Type) -> T {
        let description = String(describing: theType)
        let view = Bundle.main.loadNibNamed(description, owner: nil, options: nil)![0] as! T
        return view
    }
}

