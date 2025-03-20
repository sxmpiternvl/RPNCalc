import Foundation

struct CalculatorUtils: CalculatorUtilsProtocol {
    
    func prepareExpression(_ input: String) -> [String] {
        var result = input
        result = result.replacingOccurrences(of: "÷", with: "/")
        result = result.replacingOccurrences(of: "×", with: "*")
        
        var output: [String] = []
        let chars = result.split(separator: "")
        for i in 0..<chars.count {
            let char = chars[i]
            switch char {
            case "-":
                if i == 0 || chars[i - 1] == "(" {
                    output.append("0")
                }
                output.append(String(char))
            default:
                output.append(String(char))
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
