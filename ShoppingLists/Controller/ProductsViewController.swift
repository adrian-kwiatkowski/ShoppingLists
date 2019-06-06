import UIKit
import SnapKit

final class ProductsViewController: UIViewController {

    // MARK: Properties
    
    private var products: [String] {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum DisplayMode {
        case currentList
        case archivedList
    }
    
    private let displayMode: DisplayMode
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        return view
    }()
    
    // MARK: Initializers
    
    init(displayMode: DisplayMode, listName: String, products: [String]) {
        self.products = products
        self.displayMode = displayMode
        super.init(nibName: nil, bundle: nil)
        title = listName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if displayMode == .currentList {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductTapped))
        }
    }
    
    @objc private func addProductTapped() {
        showPromptWithTextField(title: "New product name:") { (listName) in
            self.products.append(listName)
        }
    }
}

// MARK: TableView Delegate + DataSource

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else { fatalError("Unable to dequeue ProductTableViewCell") }
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if displayMode == .currentList {
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
}
