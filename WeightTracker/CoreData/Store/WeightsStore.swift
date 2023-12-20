import Foundation
import CoreData
import UIKit

enum WeightsStoreError: Error {
    case recordNotFound
    case internalError
    case decodeRecordError
    case unexpectedMultipleResult
}

final class WeightsStore: NSObject {
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func list(withSort: [NSSortDescriptor]) throws -> [WeightCoreData] {
        let request = WeightCoreData.fetchRequest()
        request.sortDescriptors = withSort
        return try context.fetch(request)
    }
    
    func add(record: WeightRecord) throws {
        let recordCoreData = WeightCoreData(context: context)
        recordCoreData.weightValue = (record.weightValue) as NSDecimalNumber
        recordCoreData.date = record.date
        
        context.safeSave()
    }
    
    func delete(record: WeightRecord) throws {
        let request = WeightCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(WeightCoreData.date), Calendar.current.startOfDay(for: record.date) as NSDate)
        
        guard let records = try? context.fetch(request) else {
            throw WeightsStoreError.internalError
        }
        if records.count < 1 {
            throw WeightsStoreError.recordNotFound
        }
        if records.count > 1 {
            throw WeightsStoreError.unexpectedMultipleResult
        }
        
        context.delete(records.first!)
        context.safeSave()
    }
    
    func clear() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = WeightCoreData.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        
        try context.execute(deleteRequest)
        
        context.safeSave()
    }
}
