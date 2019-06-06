import Foundation

struct List {
    let name: String
    let createdAt: Date
    let archived: Bool
    
    init(name: String, createdAt: Date = Date(), archived: Bool = false) {
        self.name = name
        self.createdAt = createdAt
        self.archived = archived
    }
}
