import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var history: [HistoryEntry] = []
    var onDeleteEntry: ((Int) -> Void)?
    var onClearHistory: (() -> Void)?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHistoryViewController()
        setupConstraints()
        setupNavigationBarButton()
    }
    
    private func setupHistoryViewController() {
        view.backgroundColor = .systemBackground
        title = "История"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView
            .anchor(
                top: view.topAnchor,
                leading: view.leadingAnchor,
                bottom: view.bottomAnchor,
                trailing: view.trailingAnchor
            )
    }
    
    private func setupNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Очистить",
            style: .plain,
            target: self,
            action: #selector(
                clearHistory
            )
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(
                done
            )
        )
    }
    
    @objc func clearHistory() {
        history.removeAll()
        tableView.reloadData()
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let entry = history[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Инфикс: \(entry.infixExpression)\nRPN: \(entry.rpnExpression)\nРезультат: \(entry.result)"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            history.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
