//
//  NewCategoryViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    // MARK: - Properties:
    weak var delegate: NewCategoryViewControllerProtocol?
    
    // MARK: - Private properties:
    private var categoryName: String = ""
    private let categoryStore = TrackerCategoryStore.shared
    
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
        field.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        
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
        doneButtonCondition()
    }
    
    // MARK: - Private methods:
    private func setupScreenItems() {
        self.view.addSubview(topTitle)
        self.view.addSubview(textField)
        self.view.addSubview(doneButton)
        
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
    
    // MARK: - Objc-Mehtods:
    @objc private func doneButtonTapped() {
        do {
            try categoryStore.createCoreDataCategory(with: categoryName)
        } catch {
            print(CDErrors.creatingCoreDataCategoryError)
        }
        
        delegate?.reloadTable()
        self.dismiss(animated: true)
    }
    
    private func doneButtonCondition() {
        guard let currentText = textField.text else {
            return
        }
        doneButton.isEnabled = !currentText.isEmpty
    }
    
    @objc private func textValueChanged() {
        doneButtonCondition()
    }
}
// MARK: - UITextFieldDelegate:
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryName = textField.text ?? ""
    }
}
