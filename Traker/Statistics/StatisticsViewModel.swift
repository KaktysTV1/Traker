import Foundation

final class StatisticsViewModel: NSObject {
    // MARK: - Properties:
    var onChange: (() -> Void)?

    // MARK: - Private Properties:
    private let recordStore = TrackerRecordStore.shared
    private(set) var records: [TrackerRecord] = [] {
        didSet {
            onChange?()
        }
    }

    // MARK: - Methods:
    override init() {
        super.init()
        recordStore.delegate = self
        records = recordStore.records ?? []
    }

    func bestPeriodNumber() -> Int {
        var counter: [UUID: Int] = [:]
        for element in records {
            let initialCount = 1
            if counter.keys.contains(element.id) {
                var existingCount = counter[element.id]!
                existingCount += 1
                counter[element.id] = existingCount
            } else {
                counter[element.id] = initialCount
            }
        }
        return counter.values.max() ?? 1
    }

    func averageValue() -> Int {
        if !records.isEmpty {
            let groupedByDate = Dictionary(grouping: records) { Calendar.current.startOfDay(for: $0.date) }
            let averageCount = groupedByDate.values.map { Double($0.count) }.reduce(0, +) / Double(groupedByDate.count)
            return Int(averageCount)
        } else {
            return 0
        }
    }
}

extension StatisticsViewModel: TrackerRecordDelegate {
    func didUpdateStatistics() {
        records = recordStore.records ?? []
    }
}
