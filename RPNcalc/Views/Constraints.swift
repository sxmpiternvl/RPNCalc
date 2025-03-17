import UIKit

enum ConstraintAttribute {
    case top, bottom, leading, trailing, left, right
}

extension UIView {
    func setConstraint(_ attribute: ConstraintAttribute, toView: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        switch attribute {
        case .top:
            self.topAnchor.constraint(equalTo: toView.topAnchor, constant: constant).isActive = true
        case .bottom:
            self.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: constant).isActive = true
        case .leading:
            self.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: constant).isActive = true
        case .trailing:
            self.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: constant).isActive = true
        case .left:
            self.leftAnchor.constraint(equalTo: toView.leftAnchor, constant: constant).isActive = true
        case .right:
            self.rightAnchor.constraint(equalTo: toView.rightAnchor, constant: constant).isActive = true
        }
    }
    
    func setConstraint(_ attribute: ConstraintAttribute, toGuide: UILayoutGuide, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        switch attribute {
        case .top:
            self.topAnchor.constraint(equalTo: toGuide.topAnchor, constant: constant).isActive = true
        case .bottom:
            self.bottomAnchor.constraint(equalTo: toGuide.bottomAnchor, constant: constant).isActive = true
        case .leading:
            self.leadingAnchor.constraint(equalTo: toGuide.leadingAnchor, constant: constant).isActive = true
        case .trailing:
            self.trailingAnchor.constraint(equalTo: toGuide.trailingAnchor, constant: constant).isActive = true
        default:
            break
        }
    }
}
