import Foundation
import CoreData
import UIKit

enum WeightsStoreError: Error {
    case recordNotFound
    case internalError
    case decodeRecordError
    case unexpectedMultipleResult
}

protocol WeightsStoreProtocol {
    func listRecords(withSort: [NSSortDescriptor]) throws -> [WeightRecord]
    func addRecord(record: WeightRecord) throws
    @discardableResult
    func updateRecord(_ updateRecord: WeightRecord) throws -> WeightRecord
    func deleteRecord(by id: UUID) throws
}

final class WeightsStore: NSObject, WeightsStoreProtocol {
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func listRecords(withSort: [NSSortDescriptor]) throws -> [WeightRecord] {
        let request = WeightCoreData.fetchRequest()
        request.sortDescriptors = withSort
        
        var recordsCoreData: [WeightCoreData] = []
        
        do {
            recordsCoreData = try context.fetch(request)
        } catch {
            print("list records failed: \(error)")
            throw WeightsStoreError.internalError
        }
        
        return recordsCoreData.map { WeightRecord(id: $0.recordId!, weightValue: $0.weightValue! as Decimal, date: $0.date!) }
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
