//import Foundation
//
//class OperatorsHandler {
//    private weak var calculatorLogic: CalculatorLogic?
//    
//    init(calculatorLogic: CalculatorLogic) {
//        self.calculatorLogic = calculatorLogic
//    }
//
//    func addOperator(_ op: String) {
//        switch calculatorLogic?.state {
//        case .undefined:
//            calculatorLogic?.state = .normal(ButtonTitle.zero.rawValue + op)
//        case .empty:
//            calculatorLogic?.state = (op == ButtonTitle.subtract.rawValue) ? .normal(ButtonTitle.subtract.rawValue) : .normal(ButtonTitle.zero.rawValue + op)
//        case .result(let val):
//            calculatorLogic?.state = .normal(val + op)
//        case .normal(var expr):
//            guard let last = expr.last else {
//                expr += op
//                calculatorLogic?.state = .normal(expr)
//                return
//            }
//
//            switch last {
//            case Character(ButtonTitle.openParenthesis.rawValue):
//                if op == ButtonTitle.subtract.rawValue {
//                    expr += op
//                }
//                calculatorLogic?.state = .normal(expr)
//                
//            case _ where last.isNumber || last == Character(ButtonTitle.closeParenthesis.rawValue):
//                expr += op
//                calculatorLogic?.state = .normal(expr)
//
//            case _ where isOperator(last) && op != ButtonTitle.subtract.rawValue:
//                expr.removeLast()
//                expr += op
//                calculatorLogic?.state = .normal(expr)
//
//            default:
//                expr += op
//                calculatorLogic?.state = .normal(expr)
//            }
//        }
//    }
//
//    private func isOperator(_ char: Character) -> Bool {
//        return [ButtonTitle.add.rawValue, ButtonTitle.subtract.rawValue, ButtonTitle.multiply.rawValue, ButtonTitle.divide.rawValue, ButtonTitle.power.rawValue].contains(String(char))
//    }
//}
