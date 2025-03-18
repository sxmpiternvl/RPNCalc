//import Foundation
//
//class DigitsHandler {
//    private weak var calculatorLogic: CalculatorLogic?
//    
//    init(calculatorLogic: CalculatorLogic) {
//        self.calculatorLogic = calculatorLogic
//    }
//
//    func addDigit(_ digit: String) {
//        switch calculatorLogic?.state {
//        case .undefined, .empty, .result(_):
//            calculatorLogic?.state = .normal(digit)
//        case .normal(let expression):
//            if digit == ButtonTitle.zero.rawValue {
//                let newExpr = (expression == ButtonTitle.zero.rawValue) ? digit : (expression + digit)
//                calculatorLogic?.state = .normal(newExpr)
//            }
//            else {
//                calculatorLogic?.state = .normal(expression + digit)
//            }
//        default:
//            break
//        }
//    }
//
//    func addDecimalPoint() {
//        switch calculatorLogic?.state {
//        case .undefined, .empty, .result(_):
//            calculatorLogic?.state = .normal(ButtonTitle.zero.rawValue + ButtonTitle.decimalSeparator.rawValue)
//        case .normal(let expr):
//            if let last = expr.last, last == "(" || isOperator(last) {
//                calculatorLogic?.state = .normal(expr + ButtonTitle.zero.rawValue + ButtonTitle.decimalSeparator.rawValue)
//            } else {
//                var currentNumber = ""
//                for char in expr.reversed() {
//                    if char.isNumber || String(char) == ButtonTitle.decimalSeparator.rawValue {
//                        currentNumber.append(char)
//                    } else {
//                        break
//                    }
//                }
//                if currentNumber.contains(ButtonTitle.decimalSeparator.rawValue) {
//                    return
//                }
//                calculatorLogic?.state = .normal(expr + ButtonTitle.decimalSeparator.rawValue)
//            }
//        }
//    }
//}
