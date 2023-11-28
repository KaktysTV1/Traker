//
//  ViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.11.2023.
//

import UIKit

class MainViewController: UIViewController, UISearchResultsUpdating {
    
    var mainImage: UIImageView = {
        let image = UIImage(named: "MainImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    var mainMassege: UILabel = {
        let label = UILabel()
        label.text = "Добавьте первый трекер"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
     
        //Добавление картинки в центр главного экрана
        constraints.append(mainImage.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(mainImage.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        //Добавление сообщения "Добавьте первый трекер"
        constraints.append(mainMassege.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor))
        constraints.append(mainMassege.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 8))
        
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupView(){
        view.addSubview(mainImage)
        view.addSubview(mainMassege)
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
    }

    @objc private func didTapButton(){
        print("tap tap tap")
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addDate(){
        let dataPiker = UIDatePicker()
        dataPiker.datePickerMode = .date
        dataPiker.locale = .current
        let addDate = UIBarButtonItem(customView: dataPiker)
        addDate.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = addDate
    }
    
    func addNewTask(){
        let newTask = UIBarButtonItem(image: UIImage(named: "PlusTask"), style: .plain, target: self, action: #selector(Self.didTapButton))
        newTask.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = newTask
    }
    
    func search() -> UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск"
        navigationItem.searchController = search
        return search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
}

