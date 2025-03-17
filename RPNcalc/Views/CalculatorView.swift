import UIKit

class CalculatorView: UIView {
    
    var dynamicClearButton: UIButton?
    
    private var isDarkMode = false
    
    let buttonTitles: [[String]] = [
        ["AC", "(", ")", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["^", "0", ".", "="]
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
        setupConstraints()
        setupButtons()
        setupThemeButton()
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
        mainStack.setConstraint(.top, toGuide: self.safeAreaLayoutGuide, constant: 20)
        mainStack.setConstraint(.leading, toView: self, constant: 20)
        mainStack.setConstraint(.trailing, toView: self, constant: -20)
        mainStack.setConstraint(.bottom, toGuide: self.safeAreaLayoutGuide, constant: -20)
        
        let displayHeightConstraint = displayScrollView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.45)
        displayHeightConstraint.isActive = true
        
        displayContainer.setConstraint(.top, toGuide: displayScrollView.contentLayoutGuide)
        displayContainer.setConstraint(.bottom, toGuide: displayScrollView.contentLayoutGuide)
        displayContainer.setConstraint(.leading, toGuide: displayScrollView.contentLayoutGuide)
        displayContainer.setConstraint(.trailing, toGuide: displayScrollView.contentLayoutGuide)
        
        displayContainer.heightAnchor.constraint(equalTo: displayScrollView.frameLayoutGuide.heightAnchor).isActive = true
        displayContainer.widthAnchor.constraint(greaterThanOrEqualTo: displayScrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        displayLabel.setConstraint(.bottom, toView: displayContainer, constant: -16)
        displayLabel.setConstraint(.leading, toView: displayContainer, constant: 16)
        displayLabel.setConstraint(.trailing, toView: displayContainer, constant: -16)
    }
    
    //MARK: Buttons Row
    
    private func setupButtons() {
        buttonTitles.forEach { row in
            let rowStack = createButtonRow(row)
            buttonsContainer.addArrangedSubview(rowStack)
        }
    }
    
    private func createButtonRow(_ titles: [String]) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 18
        rowStack.alignment = .fill
        rowStack.distribution = .fillEqually
        
        titles.forEach { title in
            let button = createButton(title)
            if (title == "AC" || title == "⌫") && dynamicClearButton == nil {
                dynamicClearButton = button
            }
            rowStack.addArrangedSubview(button)
        }
        return rowStack
    }
    
    //MARK: Create Buttons
    private func createButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.layer.cornerRadius = 20
        
        switch title {
        case "+", "-", "×", "÷", "^":
            button.backgroundColor = .operationsBackground
            button.setTitleColor(.buttonOperation, for: .normal)
        case "(", ")", "AC", "⌫":
            button.backgroundColor = .aCcolor
            button.setTitleColor(.aCtext, for: .normal)
        case "=":
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
        
        themeButton.setConstraint(.top, toGuide: self.safeAreaLayoutGuide, constant: 30)
        themeButton.setConstraint(.leading, toView: self, constant: 30)
        
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
//
