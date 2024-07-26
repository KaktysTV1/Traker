//
//  NewCategoryViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import UIKit

final class NewCategoryVC: UIViewController {
    // MARK: - Properties:
    weak var delegate: NewCategoryVCProtocol?
    
    // MARK: - Private properties:
    private var categoryName: String = ""
    
    private lazy var topTitle: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.textColor = .YPBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var textField: CustomUITextField = {
        let field = CustomUITextField(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41), placeholder: "Введите название категории")
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 16
        field.backgroundColor = .YPBackground
        field.textColor = .YPBlack
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.tintColor = .YPWhite
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .YPBlack
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .YPWhite
        setupScreenItems()
        textField.becomeFirstResponder()
        setupToHideKeyboardOnTapOnView()
    }
    
    // MARK: - Private methods:
    private func setupScreenItems() {
        view.addSubview(topTitle)
        view.addSubview(textField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 39),
            topTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            topTitle.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    @objc private func doneButtonTapped() {
        delegate?.addNewCategory(categoryName)
        self.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate:
extension NewCategoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryName = textField.text ?? ""
    }
}
