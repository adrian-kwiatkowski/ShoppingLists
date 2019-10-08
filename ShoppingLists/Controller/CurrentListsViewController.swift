import UIKit
import SnapKit

final class CurrentListsViewController: UIViewController {
    
    // MARK: Properties
    
    private var currentLists: [List] = []
    private let dataManager = ListDataManager()
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ListTableViewCell.self, forCellReuseIdentifier: "CurrentListCell")
        return view
    }()
    
    // MARK: Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Current lists"
        
        setupUI()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: Private methods
    
    private func fetchData() {
        currentLists.removeAll()
        currentLists = dataManager.fetchLists()
        tableView.reloadData()
    }
    
    private func createNewList(name: String) {
        dataManager.createNewList(with: name)
        fetchData()
    }

    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.right.left.bottom.top.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTapped))
    }
    
    @objc private func addNewTapped() {
        showPromptWithTextField(title: "Create new list:") { (listName) in
            self.createNewList(name: listName)
        }
    }
}

// MARK: TableView Delegate + DataSource

extension CurrentListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentListCell", for: indexPath) as? ListTableViewCell else { fatalError("Unable to dequeue ListTableViewCell") }
        let currentList = currentLists[indexPath.row]
        cell.textLabel?.text = currentList.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = currentLists[indexPath.row]
        
        let productVC = ProductsViewController(displayMode: .currentList, parentList: selectedList)
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Archive") {  (contextualAction, view, boolValue) in
            let selectedList = self.currentLists[indexPath.row]
            self.dataManager.archive(selectedList)
            self.fetchData()
        }
        contextItem.backgroundColor = UIColor.darkGray
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}
