import Foundation
import UIKit

enum HabitOrEvent {
    case habit
    case event
    
    var titleText: String {
        switch self {
        case .habit:
            return L10n.Localizable.Title.newHabit
        case .event:
            return L10n.Localizable.Title.newEvent
        }
    }
    
    var editingTitle: String {
        return L10n.Localizable.Title.habitEditing
    }
}

protocol ScheduleViewControllerDelegate: AnyObject {
    var selectedDays: [Weekday] { get set }
    func showSelectedDays()
}

protocol CategoryViewControllerDelegate: AnyObject {
    var selectedCategory: String { get set }
    func showSelectedCategory()
}

final class TrackerCreatingViewController: UIViewController {
    // MARK: - Properties:
    var trackerType: HabitOrEvent
    var selectedDays: [Weekday] = [] {
        didSet {
            createButtonCondition()
        }
    }
    
    var selectedCategory: String = "" {
        didSet {
            createButtonCondition()
        }
    }
    var editingTracker: Tracker?
    var trackerName: String = ""
    
    // MARK: - Private properties:
    private let yandexMetrica = YandexMetrica.shared
    private let trackerStore = TrackerStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStrore = TrackerRecordStore.shared
    private let emojies: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                                     "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                                     "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let colors: [UIColor] = [
        .YPColorSelection1, .YPColorSelection2, .YPColorSelection3,
        .YPColorSelection4, .YPColorSelection5, .YPColorSelection6,
        .YPColorSelection7, .YPColorSelection8, .YPColorSelection9,
        .YPColorSelection10, .YPColorSelection11, .YPColorSelection12,
        .YPColorSelection13, .YPColorSelection14, .YPColorSelection15,
        .YPColorSelection16, .YPColorSelection17, .YPColorSelection18
    ]
    
    private let params = GeometricParams(cellCount: 6, leftInset: 18, rightInset: 18, cellSpacing: 5)
    
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    private var selectedEmoji: String? {
        didSet {
            createButtonCondition()
        }
    }
    
    private var selectedColor: UIColor? {
        didSet {
            createButtonCondition()
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isMultipleTouchEnabled = true
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.decelerationRate = .init(rawValue: 0.5)
        
        return scroll
    }()
    
    private lazy var topTitle: UILabel = {
        let label = UILabel()
        label.text = editingTracker == nil ? trackerType.titleText : L10n.Localizable.Title.habitEditing
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .YPBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var completedDaysLabel: UILabel = {
        let completedDaysCounter = recordStrore.records?.filter({ $0.id == editingTracker?.id }).count
        let counter = UILabel()
        counter.font = .boldSystemFont(ofSize: 32)
        counter.textColor = .YPBlack
        counter.textAlignment = .center
        counter.text = "\(completedDaysCounter?.days() ?? 0.days())"
        counter.translatesAutoresizingMaskIntoConstraints = false
        
        return counter
    }()
    
    private lazy var textField: CustomUITextField = {
        let field = CustomUITextField(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41), placeholder: L10n.Localizable.Field.enterTrackerName)
        field.backgroundColor = .YPBackground
        field.textColor = .YPBlack
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return field
    }()
    
    private lazy var limitationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .YPRed
        label.textAlignment = .center
        label.text = L10n.Localizable.Field.lettersLimit
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .YPBlack
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.contentHorizontalAlignment = .leading
        button.backgroundColor = .YPBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.setTitle(L10n.Localizable.Title.category, for: .normal)
        button.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        if trackerType == .habit {
            button.layer.cornerRadius = 16
            button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            button.layer.cornerRadius = 16
        }
        
        return button
    }()
    
    private lazy var selectedCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .YPGrayGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dividerLine: UIView = {
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        return divider
    }()
    
    private lazy var chevronImage1: UIImageView = {
        let imageView = UIImageView()
        let chevron = UIImage(named: "chevron")
        imageView.image = chevron
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var chevronImage2: UIImageView = {
        let imageView = UIImageView()
        let chevron = UIImage(named: "chevron")
        imageView.image = chevron
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .YPBlack
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.backgroundColor = .YPBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        button.setTitle(L10n.Localizable.Title.schedule, for: .normal)
        
        return button
    }()
    
    private lazy var selectedDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .YPGrayGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseId)
        
        return collection
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .YPRed
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.YPRed.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitle(L10n.Localizable.Button.cancel, for: .normal)
        
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let title = editingTracker == nil ? L10n.Localizable.Button.create : L10n.Localizable.Button.saveTitle
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let emojiIndexPath = emojies.firstIndex(where: { $0 == selectedEmoji }) else { return }
        selectedEmojiIndexPath = IndexPath(row: emojiIndexPath, section: 0)
        
        guard let colorIndexPath = colors.firstIndex(where: { $0.isEqual(selectedColor) }) else {
            return
        }
        selectedColorIndexPath = IndexPath(row: colorIndexPath, section: 1)
    }
    override func viewDidLoad() {
        view.backgroundColor = .YPWhite
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        configureScreenItems()
        setupConstraints()
        textField.becomeFirstResponder()
        createButtonCondition()
        setupEditingTrackerUI()
    }
    
    // MARK: - Methods:
    init(trackerType: HabitOrEvent) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods:
    private func configureScreenItems() {
        self.view.addSubview(topTitle)
        self.view.addSubview(scrollView)
        self.view.addSubview(stackView)
        self.view.addSubview(completedDaysLabel)
        
        scrollView.addSubview(textField)
        scrollView.addSubview(categoryButton)
        scrollView.addSubview(collectionView)
        
        categoryButton.addSubview(chevronImage1)
        categoryButton.addSubview(selectedCategoryLabel)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        stackView.spacing = 8
        stackView.axis = .horizontal
        
        if trackerType == .habit {
            scrollView.addSubview(scheduleButton)
            scrollView.addSubview(dividerLine)
            scheduleButton.addSubview(chevronImage2)
            scheduleButton.addSubview(selectedDaysLabel)
        }
    }
    
    private func setupConstraints() {
        var collectionViewTopConstraint: NSLayoutConstraint?
        if trackerType == .event {
            scrollView.contentSize = CGSize(width: view.frame.width, height: 688)
            collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 32)
        } else if trackerType == .habit {
            scrollView.contentSize = CGSize(width: view.frame.width, height: 763)
            collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32)
        }
        
        let topInset: CGFloat = editingTracker != nil ? 116 : 38
        
        var constraints = [
            topTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 39),
            topTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 68),
            topTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -66),
            topTitle.heightAnchor.constraint(equalToConstant: 22),
            
            completedDaysLabel.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: 38),
            completedDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedDaysLabel.heightAnchor.constraint(equalToConstant: 38),
            
            scrollView.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: topInset),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            selectedCategoryLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            selectedCategoryLabel.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 39),
            selectedCategoryLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -56),
            selectedCategoryLabel.heightAnchor.constraint(equalToConstant: 22),
            
            chevronImage1.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -24),
            chevronImage1.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -31),
            
            collectionViewTopConstraint!,
            collectionView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 430),
            
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            cancelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 161),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        if trackerType == .habit {
            constraints += [
                dividerLine.heightAnchor.constraint(equalToConstant: 1),
                dividerLine.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
                dividerLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
                dividerLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
                
                scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
                scheduleButton.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
                scheduleButton.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
                scheduleButton.heightAnchor.constraint(equalToConstant: 75),
                
                chevronImage2.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -24),
                chevronImage2.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -31),
                
                selectedDaysLabel.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
                selectedDaysLabel.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 39),
                selectedDaysLabel.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -56),
                selectedDaysLabel.heightAnchor.constraint(equalToConstant: 22)
            ]
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addLimitLabel() {
        scrollView.addSubview(limitationLabel)
        NSLayoutConstraint.activate([
            limitationLabel.widthAnchor.constraint(equalToConstant: 286),
            limitationLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            limitationLabel.bottomAnchor.constraint(equalTo: categoryButton.topAnchor, constant: -32),
            limitationLabel.heightAnchor.constraint(equalToConstant: 22),
            limitationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func hideLimitLabel() {
        limitationLabel.removeFromSuperview()
    }
    
    private func setupEditingTrackerUI() {
        if let editingTracker = editingTracker {
            completedDaysLabel.isEnabled = false
            textField.text = editingTracker.name
            selectedDays = editingTracker.schedule ?? []
            selectedEmoji = editingTracker.emoji
            selectedColor = editingTracker.color
            trackerName = editingTracker.name
            
            showSelectedDays()
            showSelectedCategory()
        } else {
            completedDaysLabel.isHidden = true
        }
    }
    
    private func createButtonCondition() {
        if trackerType == .habit {
            createButton.isEnabled = !selectedDays.isEmpty && textField.text?.isEmpty == false && !selectedCategory.isEmpty && selectedEmoji != nil && selectedColor != nil
        } else if trackerType == .event {
            createButton.isEnabled = textField.text?.isEmpty == false && !selectedCategory.isEmpty && selectedEmoji != nil && selectedColor != nil
        }
        if createButton.isEnabled {
            createButton.backgroundColor = .YPBlack
            createButton.tintColor = .YPWhite
        } else {
            createButton.backgroundColor = .YPGrayGray
            createButton.tintColor = .YPOnlyWhite
        }
    }
    
    // MARK: - Objc-Methods:
    @objc private func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        var tracker: Tracker?
        if editingTracker == nil {
            if trackerType == .habit {
                tracker = Tracker(id: UUID(), name: trackerName, schedule: selectedDays, color: selectedColor ?? .clear, emoji: selectedEmoji ?? "", isPinned: false)
            } else if trackerType == .event {
                tracker = Tracker(id: UUID(), name: trackerName, schedule: Weekday.allCases, color: selectedColor ?? .clear, emoji: selectedEmoji ?? "", isPinned: false)
            }
            guard let tracker = tracker else { return }
            do {
                if let CDCategory = try categoryStore.getCategoryWith(title: selectedCategory) {
                    try trackerStore.createCoreDataTracker(from: tracker, with: CDCategory)
                }
            } catch {
                print(CDErrors.creatingCoreDataTrackerError)
            }
        } else {
            var categoryCD: TrackerCategoryCoreData?
            do {
                categoryCD = try categoryStore.getCategoryWith(title: selectedCategory)
            } catch {
                print(CDErrors.getCoreDataCategoryError)
            }
            
            guard
                let editingTracker,
                let selectedColor,
                let categoryCD,
                let selectedEmoji  else { return }
            let updatedTracker = Tracker(id: editingTracker.id, name: trackerName, schedule: selectedDays, color: selectedColor, emoji: selectedEmoji, isPinned: editingTracker.isPinned)
            trackerStore.updateTracker(updatedTracker, with: categoryCD)
        }
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func showCategories() {
        yandexMetrica.sendReport(about: Analytics.Events.open, and: nil, on: Analytics.Screens.category)
        let viewToPresent = CategoriesViewController()
        viewToPresent.delegate = self
        self.present(viewToPresent, animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
        yandexMetrica.sendReport(about: Analytics.Events.open, and: nil, on: Analytics.Screens.schedule)
        let viewToPresent = ScheduleViewController()
        viewToPresent.delegate = self
        self.present(viewToPresent, animated: true)
    }
    
    @objc private func textFieldDidChange() {
        createButtonCondition()
    }
}

// MARK: - ScheduleViewControllerDelegate:
extension TrackerCreatingViewController: ScheduleViewControllerDelegate {
    func showSelectedDays() {
        if !selectedDays.isEmpty {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 38, right: 56)
        } else {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        let weekDays: [String] = [L10n.Localizable.Day.monday, L10n.Localizable.Day.tuesday, L10n.Localizable.Day.wednesday, L10n.Localizable.Day.thursday, L10n.Localizable.Day.friday]
        let weekEnd: [String] = [L10n.Localizable.Day.saturday, L10n.Localizable.Day.sunday]
        let week: [String] = [L10n.Localizable.Day.monday, L10n.Localizable.Day.tuesday, L10n.Localizable.Day.wednesday, L10n.Localizable.Day.thursday, L10n.Localizable.Day.friday, L10n.Localizable.Day.saturday, L10n.Localizable.Day.sunday]
        
        let selectedDaysRawValues = selectedDays.map { $0.localizedName }
        
        if weekDays.allSatisfy(selectedDaysRawValues.contains(_:)) && weekDays.count == selectedDaysRawValues.count {
            selectedDaysLabel.text = L10n.Localizable.Day.weekDays
        } else if weekEnd.allSatisfy(selectedDaysRawValues.contains(_:)) && weekEnd.count == selectedDays.count {
            selectedDaysLabel.text = L10n.Localizable.Day.weekEnd
        } else if week.allSatisfy(selectedDaysRawValues.contains(_:)) {
            selectedDaysLabel.text = L10n.Localizable.Day.allDays
        } else {
            selectedDaysLabel.text = selectedDays.map { $0.shortName }.joined(separator: ", ")
        }
    }
}

// MARK: - CategoryViewControllerDelegate:
extension TrackerCreatingViewController: CategoryViewControllerDelegate {
    func showSelectedCategory() {
        selectedCategoryLabel.text = selectedCategory
        if !selectedCategory.isEmpty {
            categoryButton.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 38, right: 56)
        } else {
            categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

// MARK: - UITextFieldDelegate:
extension TrackerCreatingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerName = textField.text ?? ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let charsLimit  = 38
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count == charsLimit {
            addLimitLabel()
        } else if updatedText.count < 38 {
            hideLimitLabel()
        }
        return updatedText.count <= 38
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        hideLimitLabel()
        return true
    }
}

// MARK: - UICollectionViewDataSource:
extension TrackerCreatingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case SectionsEnum.emojiCell.rawValue:
            return emojies.count
        case SectionsEnum.colorCell.rawValue:
            return colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case SectionsEnum.emojiCell.rawValue:
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell()}
            emojiCell.emojiLabel.text = emojies[indexPath.row]
            if selectedEmojiIndexPath == indexPath {
                emojiCell.selectionView.backgroundColor = .YPLightGray
                selectedEmoji = emojiCell.emojiLabel.text ?? ""
            }
            return emojiCell
            
        case SectionsEnum.colorCell.rawValue:
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell()}
            colorCell.colorView.backgroundColor = colors[indexPath.row]
            if selectedColorIndexPath == indexPath {
                colorCell.selectionView.isHidden = false
                colorCell.selectionView.layer.borderColor = colors[indexPath.row].cgColor
                selectedColor = colors[indexPath.row]
            }
            return colorCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseId, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
        headerView.titleLabel.font = .boldSystemFont(ofSize: 19)
        
        switch indexPath.section {
        case SectionsEnum.emojiCell.rawValue:
            headerView.titleLabel.text = L10n.Localizable.Title.emoji
        case SectionsEnum.colorCell.rawValue:
            headerView.titleLabel.text = L10n.Localizable.Title.color
        default:
            headerView.titleLabel.text = "1"
        }
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout:
extension TrackerCreatingViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.size.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.rightInset)
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

// MARK: - UICollectionViewDelegate:
extension TrackerCreatingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case SectionsEnum.emojiCell.rawValue:
            if selectedEmojiIndexPath == indexPath {
                selectedEmojiIndexPath = nil
                selectedEmoji = ""
            } else {
                selectedEmojiIndexPath = indexPath
            }
            collectionView.reloadData()
        case SectionsEnum.colorCell.rawValue:
            if selectedColorIndexPath == indexPath {
                selectedColorIndexPath = nil
                selectedColor = nil
            } else {
                selectedColorIndexPath = indexPath
            }
            
            collectionView.reloadData()
        default:
            break
        }
    }
}
