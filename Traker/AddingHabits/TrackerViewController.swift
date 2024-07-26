//
//  ViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.11.2023.
//

import Foundation
import UIKit

protocol HabitOrEventDelegate: AnyObject {
    func addTracker(_ tracker: Tracker, and category: String, from: HabitOrEventViewController)
}

protocol TrackerCellDelegate: AnyObject {
    func checkIfCompleted(for id: UUID, at indexPath: IndexPath)
}

final class TrackersViewController: UIViewController {
    
    
    // MARK: - Properties:
    private var currentDate: Date?
    private var categories: [TrackerCategory] = Mocks.trackers
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private properties:
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
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
        bar.placeholder = "Поиск"
        bar.backgroundColor = .clear
        bar.searchBarStyle = .minimal
        bar.searchTextField.clearButtonMode = .never
        bar.updateHeight(height: 36)
        
        return bar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseID)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseId)
        
        return collection
    }()
    
    private lazy var stubImageView: UIImageView = {
        let image = UIImage(named: "starLight")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .YPWhite
        
        reloadData()
        screenItemsSetup()
        navBarSetup()
        setupToHideKeyboardOnTapOnView()
    }
    
    // MARK: - Private methods:
    private func screenItemsSetup() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(stubImageView)
        self.view.addSubview(stubLabel)
        
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func navBarSetup() {
        if let navigationBar = navigationController?.navigationBar {
            title = "Трекеры"
            navigationBar.prefersLargeTitles = true
            
            let rightButton = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = rightButton
            
            let leftButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
            leftButton.tintColor = .YPBlack
            navigationItem.leftBarButtonItem = leftButton
        }
    }
    
    private func showOrHideStubs() {
        stubLabel.isHidden = !visibleCategories.isEmpty
        stubImageView.isHidden = !visibleCategories.isEmpty
        collectionView.isHidden = visibleCategories.isEmpty
    }
    
    private func reloadData() {
        datePickerValueChanged()
    }
    
    private func reloadVisibleCategories() {
        let filterText = (searchBar.searchTextField.text ?? "").lowercased()
        let component = Calendar.current.component(.weekday, from: datePicker.date)
        
        let today = Date()
        let calendar = Calendar.current
        
        let weekdayComponent = DateComponents(weekday: component)
        currentDate = calendar.nextDate(after: today, matching: weekdayComponent, matchingPolicy: .nextTime)
        
        print(currentDate as Any)
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.includedTrackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule?.contains { weekDay in
                    weekDay.calendarNumber == component
                } == true
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, includedTrackers: trackers)
        }
        collectionView.reloadData()
        showOrHideStubs()
    }
    
    // MARK: - Objc-Methods:
    @objc private func datePickerValueChanged() {
        reloadVisibleCategories()
    }
    
    @objc private func plusButtonTapped() {
        let viewToPresent = HabitOrEventViewController()
        viewToPresent.delegate = self
        self.present(viewToPresent, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout:
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.size.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: params.leftInset, bottom: 11, right: params.rightInset)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
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
            record.id == tracker.id && record.date.onlyDate == datePicker.date.onlyDate
        }
        let isEnabled = datePicker.date <= Date() || Date().onlyDate == datePicker.date.onlyDate
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        
        cell.cellConfig(
            id: tracker.id,
            name: tracker.name,
            color: .YPColorSelection1,
            emoji: "🤓",
            isEnabled: isEnabled,
            isCompleted: isCompleted,
            completedDays: completedDays,
            indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseId, for: indexPath) as! SupplementaryView
        headerView.titleLabel.text = visibleCategories[indexPath.section].name
        headerView.titleLabel.font = .boldSystemFont(ofSize: 19)
        
        return headerView
    }
}

// MARK: - HabitOrEventDelegate:
extension TrackersViewController: HabitOrEventDelegate {
    func addTracker(_ tracker: Tracker, and category: String, from: HabitOrEventViewController) {
        var updatedCategory: TrackerCategory?
        var index: Int?
        
        for i in 0..<categories.count {
            if categories[i].name == category {
                updatedCategory = categories[i]
                index = i
            }
        }
        
        if updatedCategory == nil {
            categories.append(TrackerCategory(name: category, includedTrackers: [tracker]))
        } else {
            let newIncludedTrackers = (updatedCategory?.includedTrackers ?? []) + [tracker]
            let sortedNewTrackers = newIncludedTrackers.sorted { $0.name < $1.name }
            let newCategory = TrackerCategory(name: category, includedTrackers: sortedNewTrackers)
            categories.remove(at: index ?? 0)
            categories.insert(newCategory, at: index ?? 0)
        }
        visibleCategories = categories
        showOrHideStubs()
        collectionView.reloadData()
    }
}

// MARK: - TrackerCellDelegate:
extension TrackersViewController: TrackerCellDelegate {
    func checkIfCompleted(for id: UUID, at indexPath: IndexPath) {
        if let index = completedTrackers.firstIndex(where: { tracker in
            tracker.id == id && tracker.date.onlyDate == datePicker.date.onlyDate
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(id: id, date: datePicker.date))
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UITextSearchBarDelegate:
extension TrackersViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            searchBar.showsCancelButton = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        reloadVisibleCategories()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadVisibleCategories()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}
