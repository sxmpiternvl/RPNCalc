//import Foundation
//
//class CalculatorLogic {
//    private(set) var state: ExpressionState = .empty
//    var openParenthesisCount: Int = 0
//    
//    private let digitsHandler: DigitsHandler
//    private let operatorsHandler: OperatorsHandler
//    private let parenthesesHandler: ParenthesesHandler
//    
//    init() {
//        self.digitsHandler = DigitsHandler(calculatorLogic: self)
//        self.operatorsHandler = OperatorsHandler(calculatorLogic: self)
//        self.parenthesesHandler = ParenthesesHandler(calculatorLogic: self)
//    }
//
//    func getExpressionText() -> String {
//        switch state {
//        case .empty:
//            return ButtonTitle.zero.rawValue
//            
//        case .normal(let expression):
//            return expression
//            
//        case .undefined:
//            return "Не определено"
//            
//        case .result(let result):
//            return result
//        }
//    }
//    
//    func handleInput(_ button: ButtonTitle) {
//        switch button {
//        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
//            digitsHandler.addDigit(button.rawValue)
//        case .decimalSeparator:
//            digitsHandler.addDecimalPoint()
//        case .add, .subtract, .multiply, .divide, .power:
//            operatorsHandler.addOperator(button.rawValue)
//        case .openParenthesis:
//            parenthesesHandler.addOpenParenthesis()
//        case .closeParenthesis:
//            parenthesesHandler.addCloseParenthesis()
//        case .equals:
//            evaluateExpression()
//        case .allClear:
//            reset()
//        case .backspace:
//            deleteLastInput()
//        }
//    }
//
//    func reset() {
//        state = .empty
//        openParenthesisCount = 0
//    }
//    
//    private func evaluateExpression() {
//        guard case .normal(let expr) = state else { return }
//        guard expr.filter({ $0.isNumber }).count >= 2 else { return }
//        var expressionToEvaluate = expr
//        
//        if let last = expressionToEvaluate.last, isOperator(last) {
//            expressionToEvaluate.removeLast()
//        }
//        
//        if openParenthesisCount > 0 {
//            expressionToEvaluate.append(String(repeating: ButtonTitle.closeParenthesis.rawValue, count: openParenthesisCount))
//            openParenthesisCount = 0
//        }
//        
//        let replaced = replaceSigns(expressionToEvaluate)
//        let rpn = RPNConverter.infixToRPN(replaced)
//        let resultVal = RPNEvaluator.evaluate(rpn)
//        
//        state = resultVal.isNaN == true ? .undefined : .result(stringFromRoundedNumber(resultVal, toPlaces: 8))
//    }
//}
