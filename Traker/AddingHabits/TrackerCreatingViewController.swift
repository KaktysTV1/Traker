import Foundation
import UIKit

enum HabitOrEvent {
    case habit
    case event
    
    var titleText: String {
        switch self {
        case .habit:
            return "Новая привычка"
        case .event:
            return "Новое событие"
        }
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

protocol TrackerCreatingDelegate: AnyObject {
    func transitData(_ tracker: Tracker, and category: String)
}

final class TrackerCreatingViewController: UIViewController {
    // MARK: - Properties:
    weak var delegate: TrackerCreatingDelegate?
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
    var trackerName: String = ""
    
    // MARK: - Private properties:
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
    
    private var selectedEmoji: String = "" {
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
        scroll.decelerationRate = .init(rawValue: 1)
        
        return scroll
    }()
    
    private lazy var topTitle: UILabel = {
        let label = UILabel()
        label.text = trackerType.titleText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .YPBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var textField: CustomUITextField = {
        let field = CustomUITextField(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41), placeholder: "Введите название трекера")
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
        label.text = "Ограничение 38 символов"
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
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 16,bottom: 0,right: 0)
        button.setTitle("Категория", for: .normal)
        button.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        if trackerType == .habit{
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
        label.textColor = .YPGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dividerLine: UIView = {
        let divider = UIView()
        divider.backgroundColor = .YPGray
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
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 16,bottom: 0,right: 0)
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        button.setTitle("Расписание", for: .normal)
        
        return button
    }()
    
    private lazy var selectedDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .YPGray
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
        button.setTitle("Отменить", for: .normal)
        
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cоздать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .YPWhite
        button.backgroundColor = .YPGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        view.backgroundColor = .YPWhite
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        configureScreenItems()
        setupConstraints()
        textField.becomeFirstResponder()
        createButtonCondition()
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
        
        var constraints = [
            topTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 39),
            topTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            topTitle.heightAnchor.constraint(equalToConstant: 22),
            topTitle.widthAnchor.constraint(equalToConstant: 149),
            
            scrollView.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: 38),
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
                selectedDaysLabel.heightAnchor.constraint(equalToConstant: 22),
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
    
    private func createButtonCondition() {
        if trackerType == .habit {
            createButton.isEnabled = !selectedDays.isEmpty && textField.text?.isEmpty == false && !selectedCategory.isEmpty && !selectedEmoji.isEmpty && selectedColor != nil
        } else if trackerType == .event {
            createButton.isEnabled = textField.text?.isEmpty == false && !selectedCategory.isEmpty && !selectedEmoji.isEmpty && selectedColor != nil
        }
        if createButton.isEnabled {
            createButton.backgroundColor = .YPBlack
        } else {
            createButton.backgroundColor = .YPGray
        }
    }
    
    // MARK: - Objc-Methods:
    @objc private func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        var tracker: Tracker?
        if trackerType == .habit {
            tracker = Tracker(id: UUID(), name: trackerName, schedule: selectedDays, color: selectedColor ?? .clear, emoji: selectedEmoji)
        } else if trackerType == .event {
            tracker = Tracker(id: UUID(), name: trackerName, schedule: Weekday.allCases, color: selectedColor ?? .clear, emoji: selectedEmoji)
        }
        guard let tracker = tracker else { return }
        self.dismiss(animated: true)
        delegate?.transitData(tracker, and: selectedCategory)
    }
    
    @objc private func showCategories() {
        let viewToPresent = CategoriesViewController()
        viewToPresent.delegate = self
        self.present(viewToPresent, animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
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
        
        let weekDays: [String] = ["Понедельник","Вторник","Среда","Четверг","Пятница"]
        let weekEnd: [String] = ["Суббота", "Воскресенье"]
        let week: [String] = ["Понедельник","Вторник","Среда","Четверг","Пятница", "Суббота", "Воскресенье"]
        
        let selectedDaysRawValues = selectedDays.map { $0.rawValue }
        
        if weekDays.allSatisfy(selectedDaysRawValues.contains(_:)) && weekDays.count == selectedDaysRawValues.count {
            selectedDaysLabel.text = "Будни"
        } else if weekEnd.allSatisfy(selectedDaysRawValues.contains(_:)) && weekEnd.count == selectedDays.count {
            selectedDaysLabel.text = "Выходные дни"
        } else if week.allSatisfy(selectedDaysRawValues.contains(_:)) {
            selectedDaysLabel.text = "Все дни"
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
        case sectionsEnum.emojiCell.rawValue:
            return emojies.count
        case sectionsEnum.colorCell.rawValue:
            return colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case sectionsEnum.emojiCell.rawValue:
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell()}
            emojiCell.emojiLabel.text = emojies[indexPath.row]
            if selectedEmojiIndexPath == indexPath {
                emojiCell.selectionView.backgroundColor = .YPLightGray
                selectedEmoji = emojiCell.emojiLabel.text ?? ""
            }
            return emojiCell
            
        case sectionsEnum.colorCell.rawValue:
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
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseId, for: indexPath) as! SupplementaryView
        headerView.titleLabel.font = .boldSystemFont(ofSize: 19)
        
        switch indexPath.section {
        case sectionsEnum.emojiCell.rawValue:
            headerView.titleLabel.text = "Emoji"
        case sectionsEnum.colorCell.rawValue:
            headerView.titleLabel.text = "Цвет"
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
        case sectionsEnum.emojiCell.rawValue:
            if selectedEmojiIndexPath == indexPath {
                selectedEmojiIndexPath = nil
                selectedEmoji = ""
            } else {
                selectedEmojiIndexPath = indexPath
            }
            collectionView.reloadData()
        case sectionsEnum.colorCell.rawValue:
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
