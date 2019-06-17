import UIKit
import SnapKit

final class ArchivedListsViewController: UIViewController {

    // MARK: Properties
    
    private var archivedLists: [List] = []
    private let dataManager = DataManager()
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ListTableViewCell.self, forCellReuseIdentifier: "ArchivedListCell")
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
        
        title = "Archived lists"
        
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
        archivedLists.removeAll()
        archivedLists = dataManager.fetchArchivedLists()
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.right.left.bottom.top.equalToSuperview()
        }
    }
}

// MARK: TableView Delegate + DataSource

extension ArchivedListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archivedLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArchivedListCell", for: indexPath) as? ListTableViewCell else { fatalError("Unable to dequeue ListTableViewCell") }
        let archivedList = archivedLists[indexPath.row]
        cell.textLabel?.text = archivedList.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = archivedLists[indexPath.row]
        
        let productVC = ProductsViewController(displayMode: .archivedList, parentList: selectedList)
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedList = archivedLists[indexPath.row]
            dataManager.delete(selectedList)
            archivedLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            fetchData()
        }
    }
}
