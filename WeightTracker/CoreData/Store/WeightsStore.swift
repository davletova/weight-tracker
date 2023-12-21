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
        
        var records: [WeightCoreData] = []
        
        do {
            records = try context.fetch(request)
        } catch {
            print("list records failed: \(error)")
            throw WeightsStoreError.internalError
        }
        
        return records
    }
    
    func add(record: WeightRecord) throws {
        let request = WeightCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        var records: [WeightCoreData] = []
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(WeightCoreData.date), Calendar.current.startOfDay(for: record.date) as NSDate)
        do {
            records = try context.fetch(request)
        } catch {
            print("failed to get records in current day: \(error)")
            throw WeightsStoreError.internalError
        }
        
        if records.count != 0 {
            throw WeightsStoreError.unexpectedMultipleResult
        }
        
        let recordCoreData = WeightCoreData(context: context)
        recordCoreData.weightValue = (record.weightValue) as NSDecimalNumber
        recordCoreData.date = Calendar.current.startOfDay(for: record.date)
        
        try context.safeSave()
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
        try context.safeSave()
    }
    
    func clear() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = WeightCoreData.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        
        try context.execute(deleteRequest)
        
        try context.safeSave()
    }
}
