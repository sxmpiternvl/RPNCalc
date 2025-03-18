//import Foundation
//
//class ParenthesesHandler {
//    private weak var calculatorLogic: CalculatorLogic?
//    
//    init(calculatorLogic: CalculatorLogic) {
//        self.calculatorLogic = calculatorLogic
//    }
//
//    func addOpenParenthesis() {
//        switch calculatorLogic?.state {
//        case .undefined, .empty, .result(_):
//            calculatorLogic?.state = .normal(ButtonTitle.openParenthesis.rawValue)
//            calculatorLogic?.openParenthesisCount = 1
//            
//        case .normal(var expr):
//            guard let last = expr.last else {
//                expr.append(ButtonTitle.openParenthesis.rawValue)
//                calculatorLogic?.openParenthesisCount += 1
//                calculatorLogic?.state = .normal(expr)
//                return
//            }
//            
//            let isLastCharacterValid = last.isNumber || last == Character(ButtonTitle.closeParenthesis.rawValue)
//            
//            if isLastCharacterValid {
//                expr.append(ButtonTitle.multiply.rawValue)
//            }
//            
//            expr.append(ButtonTitle.openParenthesis.rawValue)
//            calculatorLogic?.openParenthesisCount += 1
//            calculatorLogic?.state = .normal(expr)
//        }
//    }
//    
//    func addCloseParenthesis() {
//        guard calculatorLogic?.openParenthesisCount ?? 0 > 0 else { return }
//        switch calculatorLogic?.state {
//        case .undefined, .empty, .result(_):
//            return
//            
//        case .normal(var expr):
//            if let last = expr.last, last == Character(ButtonTitle.openParenthesis.rawValue) || isOperator(last) {
//                return
//            }
//            
//            expr.append(ButtonTitle.closeParenthesis.rawValue)
//            calculatorLogic?.openParenthesisCount -= 1
//            calculatorLogic?.state = .normal(expr)
//        }
//    }
//    
//    private func isOperator(_ char: Character) -> Bool {
//        return [ButtonTitle.add.rawValue, ButtonTitle.subtract.rawValue, ButtonTitle.multiply.rawValue, ButtonTitle.divide.rawValue, ButtonTitle.power.rawValue].contains(String(char))
//    }
//}
