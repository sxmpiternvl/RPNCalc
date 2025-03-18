import UIKit

class CalculatorView: UIView {
    
    var dynamicClearButton: UIButton?
    
    private var isDarkMode = false
    
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
    
    private let displayContainer: UIView = {
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
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 18
        return stack
    }()
    
    private let themeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "lightbulb")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupButtons()
        setupThemeButton()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(displayScrollView)
        mainStack.addArrangedSubview(buttonsContainer)
        displayScrollView.addSubview(displayContainer)
        displayContainer.addSubview(displayLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let displayHeightConstraint = displayScrollView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.45)
        displayHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            displayContainer.topAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.topAnchor),
            displayContainer.bottomAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.bottomAnchor),
            displayContainer.leadingAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.leadingAnchor),
            displayContainer.trailingAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.trailingAnchor),
            displayContainer.heightAnchor.constraint(equalTo: displayScrollView.frameLayoutGuide.heightAnchor),
            displayContainer.widthAnchor.constraint(greaterThanOrEqualTo: displayScrollView.frameLayoutGuide.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            displayLabel.bottomAnchor.constraint(equalTo: displayContainer.bottomAnchor, constant: -16),
            displayLabel.leadingAnchor.constraint(equalTo: displayContainer.leadingAnchor, constant: 16),
            displayLabel.trailingAnchor.constraint(equalTo: displayContainer.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            themeButton.leadingAnchor.constraint(equalTo: mainStack.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            themeButton.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: 20)
        ])
        
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
        rowStack.spacing = 18
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
    
    // MARK: Theme Button
    private func setupThemeButton() {
        addSubview(themeButton)
        themeButton.addTarget(self, action: #selector(toggleTheme), for: .touchUpInside)
    }
    
    @objc private func toggleTheme() {
        isDarkMode.toggle()
        let newStyle: UIUserInterfaceStyle = isDarkMode ? .dark : .light
        guard let window = window else { return }
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            window.overrideUserInterfaceStyle = newStyle
        }, completion: nil)
    }
}
