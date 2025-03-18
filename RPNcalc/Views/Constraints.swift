import UIKit

enum ConstraintAttribute {
    case top, bottom, leading, trailing, left, right
}

extension UIView {
    func setConstraint(_ attribute: ConstraintAttribute, toView: Any, constant: CGFloat = 0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let toView = toView as? UIView {
            // If the toView is a UIView
            switch attribute {
            case .top:
                return self.topAnchor.constraint(equalTo: toView.topAnchor, constant: constant)
            case .bottom:
                return self.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: constant)
            case .leading:
                return self.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: constant)
            case .trailing:
                return self.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: constant)
            case .left:
                return self.leftAnchor.constraint(equalTo: toView.leftAnchor, constant: constant)
            case .right:
                return self.rightAnchor.constraint(equalTo: toView.rightAnchor, constant: constant)
            }
        } else if let toGuide = toView as? UILayoutGuide {
            // If the toView is a UILayoutGuide (e.g., safeAreaLayoutGuide)
            switch attribute {
            case .top:
                return self.topAnchor.constraint(equalTo: toGuide.topAnchor, constant: constant)
            case .bottom:
                return self.bottomAnchor.constraint(equalTo: toGuide.bottomAnchor, constant: constant)
            case .leading:
                return self.leadingAnchor.constraint(equalTo: toGuide.leadingAnchor, constant: constant)
            case .trailing:
                return self.trailingAnchor.constraint(equalTo: toGuide.trailingAnchor, constant: constant)
            case .left:
                return self.leftAnchor.constraint(equalTo: toGuide.leftAnchor, constant: constant)
            case .right:
                return self.rightAnchor.constraint(equalTo: toGuide.rightAnchor, constant: constant)
            }
        }
        
        return NSLayoutConstraint() // Default return, shouldn't happen
    }
}
