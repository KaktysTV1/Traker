import Foundation
import UIKit
import CoreData

protocol TrackerRecordDelegate: AnyObject {
    func didUpdateStatistics()
}

final class TrackerRecordStore: NSObject {
    // MARK: - Properties:
    weak var delegate: TrackerRecordDelegate?
    static let shared = TrackerRecordStore()
    var records: [TrackerRecord]? {
        guard
            let fetchedResultController = self.recordsFetchedResultsController,
            let objects = fetchedResultController.fetchedObjects,
            let records = try? objects.map({ try createTrackerRecord(from: $0) }) else {
            return []
        }
        return records
    }

    // MARK: - Private properties:
    private var context: NSManagedObjectContext
    private var recordsFetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?

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

        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordID", ascending: false)]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.recordsFetchedResultsController = controller
        try? controller.performFetch()
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

    func deleteAllRecordFromCD(for id: UUID) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordID), id as CVarArg)
        guard let trackersRecords = try? context.fetch(request) else {
            return
        }

        trackersRecords.forEach {
            context.delete($0)
        }
        saveContext()
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
            print("Нет записей удовлетворяющих условию")
            return []
        }
        return records
    }

    // MARK: - Private Methods:
    func getAllRecords() throws -> [TrackerRecord]? {
        let request = TrackerRecordCoreData.fetchRequest()
        let objects = try context.fetch(request)
        let records = try objects.map { try self.createTrackerRecord(from: $0) }

        return records
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let delegate = delegate {
            delegate.didUpdateStatistics()
        }
    }
}
