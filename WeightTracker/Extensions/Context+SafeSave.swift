import Foundation
import CoreData

extension NSManagedObjectContext {
    func safeSave() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                print("failed to save context: \(error)")
                self.rollback()
            }
        }
    }
}
