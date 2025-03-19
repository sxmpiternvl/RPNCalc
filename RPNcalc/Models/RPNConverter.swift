
protocol RPNConverterProtocol {
    static func infixToRPN(_ input: [String]) -> [String]
}

struct RPNConverter: RPNConverterProtocol {
    static func infixToRPN(_ input: [String]) -> [String] {
        var output: [String] = []
        var operatorStack: [String] = []
        var currentNumber = ""
        
        for token in input {
            switch token {
            case _ where token.first?.isNumber == true || token.first == ".":
                currentNumber.append(token)
                
            case "(":
                if !currentNumber.isEmpty {
                    output.append(currentNumber)
                    currentNumber = ""
                }
                operatorStack.append(token)
                
            case ")":
                if !currentNumber.isEmpty {
                    output.append(currentNumber)
                    currentNumber = ""
                }
                while let last = operatorStack.last, last != "(" {
                    output.append(last)
                    operatorStack.removeLast()
                }
                operatorStack.removeLast()
                
            default:
                if !currentNumber.isEmpty {
                    output.append(currentNumber)
                    currentNumber = ""
                }
                while let last = operatorStack.last, last != "(",
                      getPriority(token) <= getPriority(last) {
                    output.append(last)
                    operatorStack.removeLast()
                }
                operatorStack.append(token)
            }
        }
        
        if !currentNumber.isEmpty {
            output.append(currentNumber)
        }
        
        while let last = operatorStack.last {
            operatorStack.removeLast()
            if last != "(" {
                output.append(last)
            }
        }
        
        print("RPN expression: \(output)")
        
        return output
    }
    
    private static func getPriority(_ token: String) -> Int {
        switch token {
        case "+", "-":
            return 1
        case "*", "/":
            return 2
        case "^":
            return 3
        default:
            return 0
        }
    }
}
