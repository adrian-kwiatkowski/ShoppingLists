import UIKit
import SnapKit

final class CurrentListsViewController: UIViewController {
    
    // MARK: Properties
    
    private var currentLists: [String] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ListTableViewCell.self, forCellReuseIdentifier: "CurrentListCell")
        return view
    }()
    
    // MARK: Initializers

    init(currentLists: [String]) {
        self.currentLists = currentLists
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
        tableView.reloadData()
    }
    
    // MARK: Private methods

    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.right.left.bottom.top.equalToSuperview()
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTapped))
    }
    
    @objc private func addNewTapped() {
        showPromptWithTextField(title: "New list name:") { (listName) in
            self.currentLists.append(listName)
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
        cell.textLabel?.text = currentList
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = currentLists[indexPath.row]
        
        let productVC = ProductsViewController(displayMode: .currentList, listName: selectedList, products: ["current product 1", "current product 2", "current product 3", "current product 4"])
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let archive = UITableViewRowAction(style: .normal, title: "Archive") { (action, indexPath) in
            let selectedList = self.currentLists[indexPath.row]
            print("archive list: \(selectedList)")
        }
        
        archive.backgroundColor = UIColor.darkGray
        
        return [archive]
    }
}
