import Foundation
import CoreData

enum ContextError: Error {
    case saveContextError
}

extension NSManagedObjectContext {
    func safeSave() throws {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                print("failed to save context: \(error)")
                self.rollback()
                throw ContextError.saveContextError
            }
        }
    }
}
