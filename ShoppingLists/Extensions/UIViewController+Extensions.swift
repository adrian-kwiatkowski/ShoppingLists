import UIKit

extension UIViewController {
    
    func showPromptWithTextField(title: String, submitAction: @escaping ((String) -> ( )) ) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let answer = alertController.textFields![0].text else { return }
            guard !answer.isEmpty else { return }
            submitAction(answer)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
