import Foundation

enum CDErrors: Error {
    case creatingTrackerFromModelError
    case creatingCategoryFromModelError
    case creatingCoreDataCategoryError
    case categoryTitleError
    case categoryTrackersError
    case getCoreDataCategoryError
    case creatingCoreDataTrackerError
    case recordCoreDataCreatingError
    case recordFetchingError
    case creatingRecordFromCoreDataError
    case categoryFetchedResultsControllerPerformFetchError
}
