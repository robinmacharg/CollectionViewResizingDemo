import UIKit

extension UIStoryboard {
    
    // A convenience method for extracting VCs from storyboards
    // We gain a couple of lines and remove some boilerplate 
    class func viewController<ViewControllerType>(
        _ viewControllerName: String,
        inStoryboard storyboardName: String = "Main",
        inBundle bundle: Bundle? = nil,
        as: ViewControllerType.Type)
        -> ViewControllerType?
    {
        return UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: viewControllerName) as? ViewControllerType
    }
}
