import UIKit
import SnapKit

final class ProductsViewController: UIViewController {

    // MARK: Properties

    enum DisplayMode {
        case currentList
        case archivedList
    }
    
    private var parentList: List
    private var products: [Product] = []
    private let dataManager = DataManager()
    private let displayMode: DisplayMode
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        return view
    }()
    
    // MARK: Initializers
    
    init(displayMode: DisplayMode, parentList: List) {
        self.displayMode = displayMode
        self.parentList = parentList
        super.init(nibName: nil, bundle: nil)
        title = parentList.name
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
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: Private methods
    
    private func fetchData() {
        products.removeAll()
        products = dataManager.fetchProducts(for: parentList)
        tableView.reloadData()
    }
    
    private func createNewProduct(name: String) {
        dataManager.createNewProduct(with: name, parentList: parentList)
        fetchData()
    }
    
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
        showPromptWithTextField(title: "New product name:") { (productName) in
            self.createNewProduct(name: productName)
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
        cell.textLabel?.text = products[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedProduct = products[indexPath.row]
            dataManager.delete(selectedProduct)
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            fetchData()
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
