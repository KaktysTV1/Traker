//
//  ViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.11.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var mainImage: UIImageView = {
        let image = UIImage(named: "MainImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var mainMassege: UILabel = {
        let label = UILabel()
        label.text = "Добавьте первый трекер"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellIdentifier = "cell"
    
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = [
        TrackerCategory(
            headerName: "Домашний уют",
            trackerArray: [
                Tracker(id: 1, name: "Поливать цветы", color: .magenta, emoji: "❤️", schedule: [1, 2, 3, 4, 5])
            ]
        ),
        TrackerCategory(
            headerName: "Радостные мелочи",
            trackerArray: [
                Tracker(id: 2, name: "Котяра заслонил камеру", color: .orange, emoji: "😻", schedule: [1, 2, 3, 4, 5]),
                Tracker(id: 3, name: "Бабушка прислала открытку в Telegram", color: .red, emoji: "🌺",     schedule: [1, 2, 3, 4, 5]),
                Tracker(id: 4, name: "Свидание в апреле", color: .blue, emoji: "❤️",                      schedule: [1, 2, 3, 4, 5,])
            ]
        )
    ]
    private var completedTrackers: [TrackerRecord] = [
        TrackerRecord(id: 1, date: Date()),
        TrackerRecord(id: 2, date: Date())
    ]
    private var currentDatePicker: Date = Date()
    private let calendar = Calendar(identifier: .gregorian)
    
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //Добавление картинки в центр главного экрана
        constraints.append(mainImage.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(mainImage.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        //Добавление сообщения "Добавьте первый трекер"
        constraints.append(mainMassege.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor))
        constraints.append(mainMassege.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 8))
        
        constraints.append(collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView(){
        view.addSubview(mainImage)
        view.addSubview(mainMassege)
        view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White")
        setupView()
        addNewTask()
        setupConstraints()
        search()
        setupNavBar()
        addDate()
        setupCollectionView()
    }
    
    @objc private func didTapButton(){
        let createNewTask = UINavigationController(rootViewController: SelectTypeTrackerViewController())
        present(createNewTask, animated: true)
    }
    
    private func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addDate(){
        let dataPiker = UIDatePicker()
        dataPiker.datePickerMode = .date
        dataPiker.locale = .current
        let addDate = UIBarButtonItem(customView: dataPiker)
        addDate.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = addDate
    }
    
    private func addNewTask(){
        let newTask = UIBarButtonItem(image: UIImage(named: "PlusTask"), style: .plain, target: self, action: #selector(Self.didTapButton))
        newTask.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = newTask
    }
    
    private func search(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск"
        navigationItem.searchController = search
    }
    
    private func setupCollectionView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TrackerCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 16, bottom: 24, right: 16)
    }
    
    private func getRecordTracker(withId id: UInt) -> [TrackerRecord] {
        completedTrackers.filter{$0.id == id}
    }
    
    private func trackerComptite(withId id: UInt) -> Bool {
        return getRecordTracker(withId: id).contains {
            calendar.isDate($0.date, equalTo: currentDatePicker, toGranularity: .day)
        }
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = allCategories[section].trackerArray.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TrackerCell
        
        let tracker: Tracker = allCategories[indexPath.section].trackerArray[indexPath.row]
        
        cell.setupTrackerCell(descriptionName: tracker.name,
                              emoji: tracker.emoji,
                              descriptionViewBackgroundColor: tracker.color,
                              completionButtonTintColor: tracker.color,
                              trackerID: tracker.id,
                              counter: getRecordTracker(withId: tracker.id).count,
                              completionFlag: trackerComptite(withId: tracker.id))
        
        cell.delegate = self
        
        return cell
        
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerCellHeader
        
        if categories.isEmpty{ return view }
        view.titleLabel.text = categories[indexPath.section].headerName
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 16, right: 0)
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func recordTrackerCompletionForSelectedDate(id: UInt) {
            var newRecord = completedTrackers
        newRecord.append(TrackerRecord(id: id, date: currentDatePicker))
            completedTrackers = newRecord
        }
        func removeTrackerCompletionForSelectedDate(id: UInt) {
            let newRecord = completedTrackers.filter {
                ($0.id != id) ||
                ($0.id == id &&
                 !calendar.isDate($0.date, equalTo: currentDatePicker, toGranularity: .day))
            }
            completedTrackers = newRecord
        }
}
