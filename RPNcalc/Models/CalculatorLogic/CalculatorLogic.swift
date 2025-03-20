import Foundation

enum ExpressionState {
    case empty
    case normal(String)
    case undefined
    case result(String)
}

class CalculatorLogic: CalculatorLogicProtocol {
    var openParenthesisCount: Int = 0
    var lastInfixExpression: String = ""
    var history: [HistoryEntry] = []
    private(set) var state: ExpressionState = .empty
    private let numbersLogic = NumbersLogic()
    private let operatorsLogic = OperatorsLogic()
    private let parenthesisLogic = ParenthesisLogic()
    private let utils = CalculatorUtils()

    func getExpressionText() -> String {
        switch state {
        case .empty:
            return ButtonTitle.zero.rawValue
        case .normal(let expression):
            return expression
        case .undefined:
            return "Не определено"
        case .result(let result):
            return result
        }
    }
    
    func handleInput(_ button: ButtonTitle) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            numbersLogic.addDigit(button.rawValue, currentState: &state)
        case .decimalSeparator:
            numbersLogic.addDecimalPoint(currentState: &state)
        case .add:
            operatorsLogic.addOperator(ButtonTitle.add.rawValue, currentState: &state)
        case .subtract:
            operatorsLogic.addOperator(ButtonTitle.subtract.rawValue, currentState: &state)
        case .multiply:
            operatorsLogic.addOperator(ButtonTitle.multiply.rawValue, currentState: &state)
        case .divide:
            operatorsLogic.addOperator(ButtonTitle.divide.rawValue, currentState: &state)
        case .power:
            operatorsLogic.addOperator(ButtonTitle.power.rawValue, currentState: &state)
        case .openParenthesis:
            parenthesisLogic.addOpenParenthesis(currentState: &state, openParenthesisCount: &openParenthesisCount)
        case .closeParenthesis:
            parenthesisLogic.addCloseParenthesis(currentState: &state, openParenthesisCount: &openParenthesisCount)
        case .equals:
            evaluateExpression()
        case .backspace:
              backspace()
          case .allClear:
              allClear()
        }
    }
        
    private func backspace() {
          switch state {
          case .normal(var expr):
              if let last = expr.last, String(last) == ButtonTitle.openParenthesis.rawValue {
                  openParenthesisCount -= 1
              }
              expr.removeLast()
              state = expr.isEmpty ? .empty : .normal(expr)
          default:
              break
          }
      }
      
      private func allClear() {
          state = .empty
          openParenthesisCount = 0
      }
    
    private func evaluateExpression() {
        guard case .normal(let expr) = state else { return }
        guard expr.filter({ $0.isNumber }).count >= 2 else { return }
        
        var expressionToEvaluate = expr
        
        if let last = expressionToEvaluate.last, utils.isOperator(last) {
            expressionToEvaluate.removeLast()
        }
        
        if openParenthesisCount > 0 {
            expressionToEvaluate.append(String(repeating: ButtonTitle.closeParenthesis.rawValue, count: openParenthesisCount))
            openParenthesisCount = 0
        }
        
        let preparedExpression = utils.prepareExpression(expressionToEvaluate)
        let rpn = RPNConverter.infixToRPN(preparedExpression)
        let resultValue = RPNEvaluator.evaluate(rpn)
        
        guard !resultValue.isNaN else {
            state = .undefined
            return
        }
        
        let resultStr = utils.formatNumber(resultValue, toPlaces: 8)
        
        let rpnForHistory = RPNConverter.infixToRPN(preparedExpression)
        let rpnExpression = rpnForHistory.joined(separator: " ")
        
        let entry = HistoryEntry(infixExpression: expr, rpnExpression: rpnExpression, result: resultStr)
        history.append(entry)        
        lastInfixExpression = expr

        state = .result(resultStr)
    }

}
