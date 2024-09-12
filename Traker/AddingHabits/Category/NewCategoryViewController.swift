import UIKit

enum EventType {
    case creating
    case editing
}

final class NewCategoryViewController: UIViewController {
    // MARK: - Properties:
    static let didChangeCategoryName = Notification.Name(rawValue: "DidChangeCategoryName")
    var editingCategoryName: String?

    // MARK: - Private properties:
    private let eventType: EventType
    private var categoryName: String = ""
    private let categoryStore = TrackerCategoryStore.shared
    private var controllerTitle: String {
        switch eventType {
        case .creating:
            return L10n.Localizable.Title.newCategory
        case .editing:
            return L10n.Localizable.Title.editingCategory
        }
    }

    private lazy var topTitle: UILabel = {
        let label = UILabel()
        label.text = controllerTitle
        label.textColor = .YPBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)

        return label
    }()

    private lazy var textField: CustomUITextField = {
        let field = CustomUITextField(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41), placeholder: L10n.Localizable.Title.enterCategory)
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
        button.setTitle(L10n.Localizable.Button.done, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
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

        if eventType == .editing {
            textField.text = editingCategoryName
        }
    }

    // MARK: - Private methods:
    init(eventType: EventType) {
        self.eventType = eventType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func doneButtonCondition() {
        guard let currentText = textField.text else {
            return
        }
        doneButton.isEnabled = !currentText.isEmpty
        if doneButton.isEnabled {
            doneButton.backgroundColor = .YPBlack
            doneButton.tintColor = .YPWhite
        } else {
            doneButton.backgroundColor = .YPGrayGray
            doneButton.tintColor = .YPOnlyWhite
        }
    }

    // MARK: - Objc-Methods:
    @objc private func doneButtonTapped() {
        if eventType == .creating {
            do {
                try categoryStore.createCoreDataCategory(with: categoryName)
            } catch {
                print(CDErrors.creatingCoreDataCategoryError)
            }
        } else if eventType == .editing {
            guard let editingCategoryName = editingCategoryName else { return }
            categoryStore.update(categoryName: editingCategoryName, with: categoryName)
        }
        NotificationCenter.default.post(name: NewCategoryViewController.didChangeCategoryName, object: self)
        self.dismiss(animated: true)
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
