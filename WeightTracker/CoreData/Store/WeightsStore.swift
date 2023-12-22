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
    
    func addRecord(record: WeightRecord) throws {
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
        recordCoreData.recordId = record.id
        recordCoreData.weightValue = record.weightValue as NSDecimalNumber
        recordCoreData.date = Calendar.current.startOfDay(for: record.date)
        
        try context.safeSave()
    }
    
    @discardableResult
    func updateRecord(_ updateRecord: WeightRecord) throws -> WeightRecord {
        let oldRecord = try getRecord(by: updateRecord.id)
        
        oldRecord.weightValue = updateRecord.weightValue as NSDecimalNumber
        oldRecord.date = Calendar.current.startOfDay(for: updateRecord.date)
        
        try context.safeSave()
        
        return updateRecord
    }
    
    func deleteRecord(by id: UUID) throws {
        context.delete(try getRecord(by: id))
        try context.safeSave()
    }
    
    func getRecord(by id: UUID) throws -> WeightCoreData {
        print("get record ", id)
        let request = WeightCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(WeightCoreData.recordId), id.uuidString)
        request.fetchLimit = 1
    
        var result: [WeightCoreData] = []
        do {
            result = try context.fetch(request)
        } catch {
            print("failed to get record: \(error)")
            throw WeightsStoreError.internalError
        }

        if result.count == 0 {
            throw WeightsStoreError.recordNotFound
        }
        
        return result[0]
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
