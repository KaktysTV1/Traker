import Foundation
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func checkIfCompleted(for id: UUID)
}

final class TrackersViewController: UIViewController {
    // MARK: - Properties:
    var currentDay: Int?
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    // MARK: - Private properties:
    private var filterStorage = FilterStorage()
    private var alertPresenter: AlertPresenterProtocol?
    private var newCategoryVCObserver: NSObjectProtocol?
    private let trackerStore = TrackerStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private let yandexMetrica = YandexMetrica.shared
    private var isSearching: Bool = false
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.layer.backgroundColor = UIColor.PickerColor.cgColor
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.tintColor = .YPBlue
        picker.calendar.firstWeekday = 2
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

        return picker
    }()

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = L10n.Localizable.Title.search
        bar.backgroundImage = .none
        bar.backgroundColor = .none
        bar.searchTextField.backgroundColor = .SearchBarColor
        bar.searchBarStyle = .minimal
        bar.searchTextField.clearButtonMode = .never
        bar.updateHeight(height: 36)

        return bar
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .YPWhite
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseID)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseId)

        return collection
    }()

    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .YPBlack
        indicator.backgroundColor = .YPGray
        indicator.layer.cornerRadius = 8
        indicator.layer.masksToBounds = true
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Localizable.Filter.filtersTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .YPBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.YPOnlyWhite, for: .normal)
        button.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)

        return button
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .YPWhite

        alertPresenter = AlertPresenter(delegate: self)
        trackerStore.delegate = self
        updateCategories()
        updateCompletedTrackers()
        reloadVisibleCategories()
        screenItemsSetup()
        navBarSetup()
        setupToHideKeyboardOnTapOnView()
        newCategoryVCObserver = NotificationCenter.default.addObserver(
            forName: NewCategoryViewController.didChangeCategoryName,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            updateCategories()
            reloadVisibleCategories()
        }
    }

    // MARK: - Private methods:
    private func screenItemsSetup() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(stubImageView)
        self.view.addSubview(stubLabel)
        self.view.addSubview(filtersButton)
        collectionView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36),

            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stubLabel.heightAnchor.constraint(equalToConstant: 18),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 51),
            activityIndicator.widthAnchor.constraint(equalToConstant: 51),

            filtersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 131),
            filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.heightAnchor.constraint(equalToConstant: 50)

        ])
    }

    private func navBarSetup() {
        if let navigationBar = navigationController?.navigationBar {
            title = L10n.Localizable.Title.trackers
            navigationBar.prefersLargeTitles = true

            let rightButton = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = rightButton

            let leftButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
            leftButton.tintColor = .YPBlack
            navigationItem.leftBarButtonItem = leftButton
        }
    }

    private func showOrHideEmptyLabels() {
        configureEmptyLabels()
        if !visibleCategories.isEmpty {
            stubLabel.isHidden = true
            stubImageView.isHidden = true
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
            stubLabel.isHidden = false
            stubImageView.isHidden = false
        }
    }

    private func configureEmptyLabels() {
        if visibleCategories.isEmpty && (filterStorage.filter == .notCompletedTrackers || filterStorage.filter == .completedTrackers) || isSearching {
            stubImageView.image = UIImage(named: "notFound")
            stubLabel.text = L10n.Localizable.Title.notFoundTitle
        } else {
            stubImageView.image = UIImage(named: "starLight")
            stubLabel.text = L10n.Localizable.Title.emptyTrackersStub
        }
    }

    private func reloadVisibleCategories() {
        activityIndicator.startAnimating()
        let filterText = (searchBar.searchTextField.text ?? "").lowercased()
        let component = Calendar.current.component(.weekday, from: datePicker.date)

        let pinnedTrackers = categories.flatMap { category in
            category.includedTrackers.filter { $0.isPinned }
        }
        let pinnedCategory = TrackerCategory(name: L10n.Localizable.Title.pinnedTitle, includedTrackers: pinnedTrackers)
        currentDay = component

        let restCategories: [TrackerCategory] = categories.compactMap { category in
            let trackers = category.includedTrackers.filter { !$0.isPinned }

            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, includedTrackers: trackers)
        }

        if pinnedTrackers.isEmpty {
            categories = restCategories
        } else {
            categories = [pinnedCategory] + restCategories
        }

        let filteredCategories: [TrackerCategory] = categories.compactMap { category in
            let trackers = category.includedTrackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule?.contains { weekDay in
                    weekDay.calendarNumber == currentDay
                } == true
                return textCondition && dateCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, includedTrackers: trackers)
        }

        if filterStorage.filter == .completedTrackers {
            filtersButton.setTitleColor(.YPRed, for: .normal)
            let completedCategories: [TrackerCategory] = filteredCategories.compactMap { category in
                let filteredTrackers = category.includedTrackers.filter { tracker in
                    let idExists = completedTrackers.contains { record in
                        return record.id == tracker.id && record.date.sameDay(datePicker.date)
                    }
                    return idExists
                }
                if !filteredTrackers.isEmpty {
                    return TrackerCategory(name: category.name, includedTrackers: filteredTrackers)
                } else {
                    return nil
                }
            }
            visibleCategories = completedCategories
        } else if filterStorage.filter == .notCompletedTrackers {
            filtersButton.setTitleColor(.YPRed, for: .normal)
            let notCompletedCategories: [TrackerCategory] = filteredCategories.compactMap { category in
                let filteredTrackers = category.includedTrackers.filter { tracker in
                    let idNotExists = !completedTrackers.contains { record in
                        return record.id == tracker.id && record.date.sameDay(datePicker.date)
                    }
                    return idNotExists
                }
                if !filteredTrackers.isEmpty {
                    return TrackerCategory(name: category.name, includedTrackers: filteredTrackers)
                } else {
                    return nil
                }
            }
            visibleCategories = notCompletedCategories
        } else {
            visibleCategories = filteredCategories
        }
        configureOverScroll(cellCount: visibleCategories.flatMap({ $0.includedTrackers }).count)
        configureEmptyLabels()
        collectionView.reloadData()
        activityIndicator.stopAnimating()
        showOrHideEmptyLabels()
    }

    private func updateCategories() {
        categories = categoryStore.categories
    }

    private func updateCompletedTrackers() {
        if let records = recordStore.records {
            self.completedTrackers = records
        } else {
            self.completedTrackers = []
        }
    }

    private func showDeleteAlert(for tracker: Tracker) {
        let alertModel = AlertModel(title: L10n.Localizable.Title.deleteTrackerTitle, message: nil, firstButtonText: L10n.Localizable.Button.delete, secondButtonText: L10n.Localizable.Button.cancel) { [weak self] in
            guard let self = self else { return }
            yandexMetrica.sendReport(about: Analytics.Events.click, and: Analytics.Items.delete, on: Analytics.Screens.mainScreen)
            self.activityIndicator.startAnimating()
            self.trackerStore.deleteTracker(tracker)
            self.recordStore.deleteAllRecordFromCD(for: tracker.id)
            self.activityIndicator.stopAnimating()
        }
        alertPresenter?.showAlert(model: alertModel)
    }

    private func pinTracker(_ tracker: Tracker) {
        trackerStore.pinTrackerCoreData(tracker)
    }

    private func configureOverScroll(cellCount: Int) {
        let cellHeight: CGFloat = 148
        let headerHeight: CGFloat = 23
        let buttonHeight: CGFloat = 50
        let contentHeight = cellHeight * CGFloat(cellCount) + headerHeight * CGFloat(cellCount)
        let availableSpace = collectionView.frame.height
        let difference = availableSpace - contentHeight
        if difference <= CGFloat(10) {
            collectionView.contentInset.bottom = buttonHeight
            collectionView.alwaysBounceVertical = true
        } else {
            collectionView.contentInset.bottom = 0
            collectionView.alwaysBounceVertical = false
        }
    }

    private func showOrHideFiltersButton(depending category: [TrackerCategory]) {
        filtersButton.isHidden = category.isEmpty && (filterStorage.filter == .allTrackers || filterStorage.filter == .todayTrackers)
    }

    // MARK: - Objc-Methods:
    @objc private func datePickerValueChanged() {
        if filterStorage.filter == .todayTrackers {
            filterStorage.filter = .allTrackers
        }
        reloadVisibleCategories()
    }

    @objc private func plusButtonTapped() {
        yandexMetrica.sendReport(about: Analytics.Events.click, and: Analytics.Items.addTrack, on: Analytics.Screens.mainScreen)

        let viewToPresent = HabitOrEventViewController()
        self.present(viewToPresent, animated: true)
    }

    @objc private func filtersButtonTapped() {
        yandexMetrica.sendReport(about: Analytics.Events.click, and: Analytics.Items.filter, on: Analytics.Screens.mainScreen)
        let viewToPresent = FiltersViewController()
        viewToPresent.delegate = self
        viewToPresent.selectedFilter = filterStorage.filter
        present(viewToPresent, animated: true)
    }
}

// MARK: - UICollectionViewDelegate:
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying, actionProvider: { _ in
            let tracker = self.visibleCategories[indexPath.section].includedTrackers[indexPath.row]
            let pinTitle = tracker.isPinned ? L10n.Localizable.Button.unpinTitle : L10n.Localizable.Button.pinTitle
            let pinAction = UIAction(title: pinTitle, handler: { [weak self] _ in
                guard let self else { return }

                self.pinTracker(tracker)
            })

            let editAction = UIAction(title: L10n.Localizable.Button.editTitle, handler: { [weak self] _ in
                guard let self else { return }
                if let categoryName = categoryStore.categories.first(where: { $0.includedTrackers.contains { $0.name == tracker.name } })?.name {
                    yandexMetrica.sendReport(about: Analytics.Events.click, and: Analytics.Items.edit, on: Analytics.Screens.mainScreen)
                    let viewToPresent = TrackerCreatingViewController(trackerType: .habit)
                    viewToPresent.editingTracker = tracker
                    viewToPresent.selectedCategory = categoryName
                    print(categoryName)
                    self.present(viewToPresent, animated: true)
                }
            })

            let deleteAction = UIAction(title: L10n.Localizable.Button.delete, attributes: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                self.showDeleteAlert(for: tracker)

            })
            let contextMenu = UIMenu(children: [pinAction, editAction, deleteAction])
            return contextMenu
        })
        return configuration
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil}
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else {
            return nil
        }
        let previewView = cell.preview
        let targetedPreview = UITargetedPreview(view: previewView)

        return targetedPreview
    }
}

// MARK: - UICollectionViewDelegateFlowLayout:
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.size.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: params.leftInset, bottom: 11, right: params.rightInset)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        showOrHideFiltersButton(depending: visibleCategories)
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerViewSize = headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)

        return headerViewSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
}

// MARK: - UICollectionViewDataSource:
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].includedTrackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseID, for: indexPath) as? TrackerCell else { return UICollectionViewCell()}
        cell.delegate = self
        let tracker = visibleCategories[indexPath.section].includedTrackers[indexPath.row]

        let isCompleted = completedTrackers.contains { record in
            tracker.id == record.id && record.date.sameDay(datePicker.date)
        }
        let isEnabled = datePicker.date.dayBefore(Date()) || Date().sameDay(datePicker.date)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        let isPinned = tracker.isPinned

        cell.cellConfig(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            isEnabled: isEnabled,
            isCompleted: isCompleted,
            completedDays: completedDays,
            isPinned: isPinned)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseId, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        headerView.titleLabel.text = visibleCategories[indexPath.section].name
        headerView.titleLabel.font = .boldSystemFont(ofSize: 19)

        return headerView
    }
}

// MARK: - TrackerCellDelegate:
extension TrackersViewController: TrackerCellDelegate {
    func checkIfCompleted(for id: UUID) {
        yandexMetrica.sendReport(about: Analytics.Events.click, and: Analytics.Items.track, on: Analytics.Screens.mainScreen)
        if let index = completedTrackers.firstIndex(where: { $0.id == id && $0.date.sameDay(datePicker.date) }) {
            let recordToDelete = completedTrackers[index]
            completedTrackers.remove(at: index)
            try? recordStore.deleteRecordFromCD(with: recordToDelete.id, and: recordToDelete.date)
        } else { completedTrackers.append(TrackerRecord(id: id, date: datePicker.date))
            try? trackerStore.updateTrackerRecord(with: TrackerRecord(id: id, date: datePicker.date))

        }
    }
}

// MARK: - UITextSearchBarDelegate:
extension TrackersViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
        }
        reloadVisibleCategories()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.searchTextField.text else { return }
        isSearching = text.isEmpty ? false : true
        if text.isEmpty {
            searchBar.showsCancelButton = false
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = nil
        searchBar.showsCancelButton = false
        reloadVisibleCategories()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

// MARK: - TrackersStoreDelegate:
extension TrackersViewController: TrackerDelegate {
    func didUpdateTrackers() {
        updateCategories()
        updateCompletedTrackers()
        reloadVisibleCategories()
    }
}

// MARK: - FiltersViewControllerDelegate
extension TrackersViewController: FiltersViewControllerDelegate {
    func selectedFilter(_ filter: Filters) {
        filterStorage.filter = filter
        switch filter {
        case .allTrackers:
            filtersButton.setTitleColor(.YPOnlyWhite, for: .normal)
            reloadVisibleCategories()
        case .todayTrackers:
            filtersButton.setTitleColor(.YPOnlyWhite, for: .normal)
            datePicker.date = Date()
            reloadVisibleCategories()
        case .completedTrackers:
            reloadVisibleCategories()
        case .notCompletedTrackers:
            reloadVisibleCategories()
        }
    }
}
