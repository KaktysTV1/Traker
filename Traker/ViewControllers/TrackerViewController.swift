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
    private var completedTrackers: [TrackerRecord] = []

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
        collectionView.dataSource = self
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TrackerCell
        cell.contentView.backgroundColor = .ypBlack
        return cell
    }
}

