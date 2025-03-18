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
        displayScrollView.addSubview(displayLabelContainer)
        displayLabelContainer.addSubview(displayLabel)
    }
    
    private func setupConstraints() {
        mainStack.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        )
        
        displayLabelContainer.anchor(
            top: displayScrollView.contentLayoutGuide.topAnchor,
            leading: displayScrollView.contentLayoutGuide.leadingAnchor,
            bottom: displayScrollView.contentLayoutGuide.bottomAnchor,
            trailing: displayScrollView.contentLayoutGuide.trailingAnchor
        )
        
        displayLabelContainer.heightAnchor.constraint(equalTo: displayScrollView.frameLayoutGuide.heightAnchor).isActive = true
        displayLabelContainer.widthAnchor.constraint(greaterThanOrEqualTo: displayScrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        displayLabel.anchor(
            leading: displayLabelContainer.leadingAnchor,
            bottom: displayLabelContainer.bottomAnchor,
            trailing: displayLabelContainer.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        )
        
        themeButton.anchor(
            top: mainStack.topAnchor,
            leading: mainStack.safeAreaLayoutGuide.leadingAnchor,
            padding: UIEdgeInsets(top: 20, left: 20,  bottom: 0, right: 0)
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
