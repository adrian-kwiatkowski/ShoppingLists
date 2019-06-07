import Foundation

struct Product {
    let name: String
    let lastModificationDate: Date
    let parentList: List
    
    init(name: String, lastModificationDate: Date = Date(), parentList: List) {
        self.name = name
        self.lastModificationDate = lastModificationDate
        self.parentList = parentList
    }
}
