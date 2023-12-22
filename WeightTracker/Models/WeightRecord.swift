import Foundation

struct WeightRecord: Hashable {
    var id: UUID
    var weightValue: Decimal
    var date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.uuidString)
    }
    
    static func ==(lhs: WeightRecord, rhs: WeightRecord) -> Bool {
        return lhs.id.uuidString == rhs.id.uuidString
    }
}

