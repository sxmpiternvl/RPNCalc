import Foundation

func isOperator(_ char: Character) -> Bool {
      return [ButtonTitle.add.rawValue, ButtonTitle.subtract.rawValue, ButtonTitle.multiply.rawValue, ButtonTitle.divide.rawValue, ButtonTitle.power.rawValue].contains(String(char))
  }

