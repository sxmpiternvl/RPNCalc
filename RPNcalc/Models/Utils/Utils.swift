
import UIKit

struct Utils {
    
    static func toggleColorScheme(view: UIView) {
        guard let window = view.window else { return }
        let currentStyle = window.overrideUserInterfaceStyle == .unspecified ? view.traitCollection.userInterfaceStyle : window.overrideUserInterfaceStyle
        let newStyle: UIUserInterfaceStyle = (currentStyle == .dark) ? .light : .dark
        window.overrideUserInterfaceStyle = newStyle
    }
    
    
    static func createAttributedText(for expression: String, count openParenthesisCount: Int) -> NSAttributedString {
        let NaNString = NSLocalizedString("historyTitle", comment: "History title")
        let fontSize: CGFloat = (expression == NaNString) ? .x4 : .x6
        let font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textLabel,
            .font: font
        ]
        let attributedText = NSMutableAttributedString(string: expression, attributes: mainAttributes)
        if openParenthesisCount > 0 {
            let lightText = String(repeating: ")", count: openParenthesisCount)
            let lightAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .font: font
            ]
            let lightAttributedText = NSAttributedString(string: lightText, attributes: lightAttributes)
            attributedText.append(lightAttributedText)
        }
        return attributedText
    }
    
    
}
