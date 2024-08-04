import UIKit

final class TrackerCell: UICollectionViewCell {
    // MARK: - Properties:
    static let reuseID = "TrackersCell"
    weak var delegate: TrackerCellDelegate?
    var isPinned: Bool = false
    public var preview: UIView {
        return topView
    }
    public var id: UUID? {
        return trackerID ?? nil
    }

    // MARK: - Private properties:
    private var isCompleted: Bool = false
    private var trackerID: UUID?
    private let plusImage = UIImage(named: "plus")
    private let doneImage = UIImage(named: "checkmark")
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .YPBlue
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16

        return view
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .YPBackground
        label.font = .systemFont(ofSize: 16)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 14
        label.textAlignment = .center
        label.text = "😍"

        return label
    }()

    private lazy var trackerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "Learn swift"
        label.textColor = .YPWhite

        return label
    }()

    private lazy var pinnedImageView: UIImageView = {
        let pinnedImage = UIImage(named: "pin")
        let imageView = UIImageView(image: pinnedImage)
        imageView.layer.backgroundColor = UIColor.clear.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white

        return imageView
    }()

    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()

    private lazy var daysCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.text = "\(0.days())"

        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .YPWhite
        button.imageEdgeInsets = UIEdgeInsets(top: 11.72, left: 11.72, bottom: 12.07, right: 11.65)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.backgroundColor = topView.backgroundColor
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Methods:
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cellConfig(id: UUID,
                    name: String,
                    color: UIColor,
                    emoji: String,
                    isEnabled: Bool,
                    isCompleted: Bool,
                    completedDays: Int,
                    isPinned: Bool) {
        let numberOfCompletedDays = completedDays
        let daysString = NSLocalizedString("completedDays", comment: "")
        let localizedString = String.localizedStringWithFormat(daysString, numberOfCompletedDays)

        self.trackerID = id
        self.trackerNameLabel.text = name
        self.topView.backgroundColor = color
        self.emojiLabel.text = emoji
        self.plusButton.backgroundColor = color
        self.plusButton.isEnabled = isEnabled
        self.daysCounterLabel.text = localizedString
        self.isCompleted = isCompleted
        self.isPinned = isPinned

        let image = isCompleted ? doneImage : plusImage
        plusButton.setImage(image, for: .normal)
        plusButton.alpha = isCompleted ? 0.3 : 1

        pinnedImageView.isHidden = !isPinned
    }
    // MARK: - Private methods:
    private func configureCell() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        daysCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        topView.addSubview(emojiLabel)
        topView.addSubview(trackerNameLabel)
        topView.addSubview(pinnedImageView)
        bottomView.addSubview(daysCounterLabel)
        bottomView.addSubview(plusButton)

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            topView.heightAnchor.constraint(equalToConstant: 90),
            emojiLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 28),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28),
            trackerNameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 44),
            trackerNameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12),
            pinnedImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -4),
            pinnedImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            pinnedImageView.widthAnchor.constraint(equalToConstant: 24),
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),

            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 58),
            daysCounterLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            daysCounterLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            daysCounterLabel.widthAnchor.constraint(equalToConstant: 101),
            daysCounterLabel.heightAnchor.constraint(equalToConstant: 18),

            plusButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    // MARK: - Objc-Methods:
    @objc private func plusButtonTapped() {
        guard let id = trackerID else { return }
        delegate?.checkIfCompleted(for: id)
    }
}
