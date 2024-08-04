import Foundation

final class CategoryViewModel: NSObject {
    // MARK: - Properties:
    var onChange: (() -> Void)?

    // MARK: - Private Properties:
    private let categoryStore = TrackerCategoryStore.shared
    private let trackersStore = TrackerStore.shared
    private let recordStore = TrackerRecordStore.shared
    private(set) var categories = [TrackerCategory]() {
        didSet {
            onChange?()
        }
    }

    // MARK: - Methods:
    override init() {
        super.init()
        categoryStore.delegate = self
        categories = categoryStore.categories
    }

    func deleteCategory(_ title: String) {
        guard let trackers = categories.first(where: { $0.name == title })?.includedTrackers else {
            return
        }
        trackers.forEach({ trackersStore.deleteTracker($0) })
        trackers.forEach { recordStore.deleteAllRecordFromCD(for: $0.id) }
        if let categoryToDelete = try? categoryStore.getCategoryWith(title: title) {
            categoryStore.deleteCategory(categoryToDelete)
        } else {
            return
        }
    }
}

// MARK: - TrackerCategoryDelegate
extension CategoryViewModel: TrackerCategoryDelegate {
    func updateCategories() {
        categories = categoryStore.categories
    }
}
