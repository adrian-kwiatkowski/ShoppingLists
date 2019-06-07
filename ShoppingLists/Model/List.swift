import Foundation

struct List {
    let name: String
    let lastModificationDate: Date
    let archived: Bool
    
    init(name: String, lastModificationDate: Date = Date(), archived: Bool = false) {
        self.name = name
        self.lastModificationDate = lastModificationDate
        self.archived = archived
    }
}
