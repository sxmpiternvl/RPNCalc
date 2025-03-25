
import Foundation

struct CalculatorUtils: CalculatorUtilsProtocol {
    
    func prepareExpression(_ input: String) -> [String] {
        let result = input.replacingOccurrences(of: "÷", with: "/")
                          .replacingOccurrences(of: "×", with: "*")
        var output: [String] = []
        let chars = Array(result)
        var i = 0
        while i < chars.count {
            let char = chars[i]
            switch char {
            case "-":
                if i == 0 || chars[i - 1] == "(" || isOperator(chars[i - 1]) {
                    output.append(ButtonTitle.openParenthesis.rawValue)
                    output.append(ButtonTitle.zero.rawValue)
                    output.append(String(char))
                    i += 1
                    while i < chars.count, chars[i].isNumber || String(chars[i]) == ButtonTitle.decimalSeparator.rawValue {
                        output.append(String(chars[i]))
                        i += 1
                    }
                    output.append(ButtonTitle.closeParenthesis.rawValue)
                    continue
                }
                output.append(String(char))
                i += 1
            default:
                output.append(String(char))
                i += 1
            }
        }
        return output
    }
    
    func formatNumber(_ value: Double, toPlaces places: Int) -> String {
        let intMax = 1e10
        let intMin = 1e-10
        if abs(value) >= intMax || (abs(value) < intMin && value != 0) {
            return String(format: "%e", value)
        }
        let multiplier = pow(10.0, Double(places))
        let roundedValue = (value * multiplier).rounded() / multiplier
        if roundedValue.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(roundedValue))"
        } else {
            return "\(roundedValue)"
        }
    }
    
    func isOperator(_ char: Character) -> Bool {
        return ["+", "-", "*", "/", "^", "×", "÷"].contains(String(char))
    }
    
}
