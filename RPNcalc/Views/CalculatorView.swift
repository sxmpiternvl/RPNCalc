import UIKit

struct HistoryEntry {
    let infixExpression: String
    let rpnExpression: String
    let result: String
}

class CalculatorView: UIView {
    
    var dynamicClearButton: UIButton?
    
    let buttonTitles: [[ButtonTitle]] = [
        [.allClear, .openParenthesis, .closeParenthesis, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.power, .zero, .decimalSeparator, .equals]
    ]
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let displayScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let displayLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .backgroundButtons
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 14
        stack.layer.cornerRadius = 40
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let historyLabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            label.textAlignment = .right
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupButtons()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(displayScrollView)
        mainStack.addArrangedSubview(buttonsContainer)
        displayScrollView.addSubview(displayLabelContainer)
        displayLabelContainer.addSubview(historyLabel)
        displayLabelContainer.addSubview(displayLabel)
    }
    
    private func setupConstraints() {
          mainStack.anchor(
              top: safeAreaLayoutGuide.topAnchor,
              leading: leadingAnchor,
              bottom: safeAreaLayoutGuide.bottomAnchor,
              trailing: trailingAnchor,
              padding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
          )
          
          displayLabelContainer.anchor(
              top: displayScrollView.contentLayoutGuide.topAnchor,
              leading: displayScrollView.contentLayoutGuide.leadingAnchor,
              bottom: displayScrollView.contentLayoutGuide.bottomAnchor,
              trailing: displayScrollView.contentLayoutGuide.trailingAnchor
          )
        
        displayLabelContainer.heightAnchor.constraint(equalTo: displayScrollView.frameLayoutGuide.heightAnchor).isActive = true
        displayLabelContainer.widthAnchor.constraint(greaterThanOrEqualTo: displayScrollView.frameLayoutGuide.widthAnchor).isActive = true
        historyLabel.anchor(
            top: nil,
            leading: displayLabelContainer.leadingAnchor,
            trailing: displayLabelContainer.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        )
          
          displayLabel.anchor(
              top: historyLabel.bottomAnchor,
              leading: displayLabelContainer.leadingAnchor,
              bottom: displayLabelContainer.bottomAnchor,
              trailing: displayLabelContainer.trailingAnchor,
              padding: UIEdgeInsets(top: 4, left: 16, bottom: 16, right: 16)
          )
          
          displayScrollView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.45).isActive = true
      }

    //MARK: Buttons Row
    private func setupButtons() {
        buttonTitles.forEach { row in
            buttonsContainer.addArrangedSubview(createButtonRow(row))
        }
    }
    
    private func createButtonRow(_ titles: [ButtonTitle]) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 14
        rowStack.alignment = .fill
        rowStack.distribution = .fillEqually
        
        titles.forEach { buttonTitle in
            let button = createButton(buttonTitle)
            if (buttonTitle == .allClear || buttonTitle == .backspace) && dynamicClearButton == nil {
                dynamicClearButton = button
            }
            rowStack.addArrangedSubview(button)
        }
        return rowStack
    }
    
    //MARK: Create Buttons
    private func createButton(_ buttonTitle: ButtonTitle) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.layer.cornerRadius = 20
        
        switch buttonTitle {
        case .add, .subtract, .multiply, .divide, .power:
            button.backgroundColor = .operationsBackground
            button.setTitleColor(.buttonOperation, for: .normal)
        case .openParenthesis, .closeParenthesis, .allClear, .backspace:
            button.backgroundColor = .aCcolor
            button.setTitleColor(.aCtext, for: .normal)
        case .equals:
            button.backgroundColor = .equalsBackground
            button.setTitleColor(.white, for: .normal)
        default:
            button.backgroundColor = .buttonsBackground
            button.setTitleColor(.buttonLabel, for: .normal)
        }
        
        return button
    }
   
}
