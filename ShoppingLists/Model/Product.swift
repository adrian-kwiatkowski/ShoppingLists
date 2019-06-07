import Foundation

struct Product {
    let name: String
    let lastModificationDate: Date
    let parentList: (name: String, lastModificationDate: Date)
    
    init(name: String, lastModificationDate: Date = Date(), parentList: (name: String, lastModificationDate: Date)) {
        self.name = name
        self.lastModificationDate = lastModificationDate
        self.parentList = parentList
    }
}
