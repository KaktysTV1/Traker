//
//  SelectTypeTrackerViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 30.11.2023.
//

import UIKit

final class SelectTypeTrackerViewController: UIViewController {
    
   private var createHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычки", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createNewTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var createIrregularEvent: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createNewIrregularEvent), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavBar()
        view.backgroundColor = .ypWhite
    }
    
    @objc private func createNewTask(){
        print("create new task")
    }
    
    @objc private func createNewIrregularEvent(){
        print("Create irregular event")
    }
    
    private func setupNavBar(){
        navigationItem.title = "Создание трека"
    }
    
    private func setupConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        constraints.append(stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor))
        
        constraints.append(createHabitButton.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(createIrregularEvent.heightAnchor.constraint(equalToConstant: 60))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView(){
        view.addSubview(stackView)
        stackView.addArrangedSubview(createHabitButton)
        stackView.addArrangedSubview(createIrregularEvent)
    }
}
