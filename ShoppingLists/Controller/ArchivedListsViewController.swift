import UIKit
import SnapKit

final class ArchivedListsViewController: UIViewController {

    // MARK: Properties
    
    var archivedLists: [String]
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ListTableViewCell.self, forCellReuseIdentifier: "ArchivedListCell")
        return view
    }()
    
    // MARK: Initializers
    
    init(archivedLists: [String]) {
        self.archivedLists = archivedLists
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
        tableView.reloadData()
    }
    
    // MARK: Private methods
    
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
        cell.textLabel?.text = archivedList
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = archivedLists[indexPath.row]
        print("clicked on \(selectedList)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            archivedLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
