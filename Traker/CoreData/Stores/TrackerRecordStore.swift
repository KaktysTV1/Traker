import Foundation
import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    // MARK: - Properties:
    static let shared = TrackerRecordStore()
    var records: [TrackerRecord]? {
        var recordsFromCD: [TrackerRecord]?
        do {
            recordsFromCD = try getAllRecords()
        } catch {
            print("Couldn't fetch records: \(error.localizedDescription)")
        }
        guard let fetchedRecords = recordsFromCD else {
            return []
        }
        return fetchedRecords
    }
    
    // MARK: - Private properties:
    private var context: NSManagedObjectContext
    
    // MARK: - Initializers:
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось инициализировать AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Methods:
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTrackerRecord(from recordCD: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let recordID = recordCD.recordID,
            let date = recordCD.date else {
            throw CDErrors.creatingRecordFromCoreDataError
        }
        let trackerRecord = TrackerRecord(id: recordID, date: date)
        return trackerRecord
    }
    
    func createCDTrackerRecord(from record: TrackerRecord) -> TrackerRecordCoreData {
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.recordID = record.id
        newRecord.date = record.date
        
        return newRecord
    }
    
    func deleteRecordFromCD(with id: UUID, and date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackersRecords = try context.fetch(request)
        let record = trackersRecords.first {
            $0.recordID == id && $0.date == date
        }
        
        if let recordToDelete = record {
            context.delete(recordToDelete)
            saveContext()
        }
    }
  
    func getRecordFromCoreData(with id: UUID) -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.recordID),
            id as CVarArg)
        
        var recordsCD: [TrackerRecordCoreData]
        do {
            recordsCD = try context.fetch(request)
        } catch {
            fatalError("\(CDErrors.recordFetchingError)")
        }
        
        guard let records = try? recordsCD.map({ try self.createTrackerRecord(from: $0)
        }) else {
            print("No records meeting the conditions")
            return []
        }
        return records
    }
    
    // MARK: - Private Methods:
    private func getAllRecords() throws -> [TrackerRecord]? {
        let request = TrackerRecordCoreData.fetchRequest()
        let objects = try context.fetch(request)
        let records = try objects.map { try self.createTrackerRecord(from: $0) }
        
        return records
    }
}


