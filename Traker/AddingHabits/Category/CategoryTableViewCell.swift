import UIKit

final class CategoryTableViewCell: UITableViewCell {
    // MARK: - Properties:
    static let reuseIdentifier = "CategoryCellID"

    // MARK: - Private properties:
    private lazy var cellTitleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17)
        title.textColor = .YPBlack
        title.translatesAutoresizingMaskIntoConstraints = false

        return title
    }()

    private lazy var checkMark: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - LifeCycle:
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .YPBackground
        self.selectionStyle = .none
        configureCellUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods:
    func configureCell(categoryName: String, checkmarkStatus: Bool) {
        cellTitleLabel.text = categoryName
        checkMark.isHidden = checkmarkStatus
    }

    func setCheckMark(isHiden: Bool) {
        checkMark.isHidden = isHiden
    }

    func getCellTextLabelText() -> String {
        guard let text = self.cellTitleLabel.text else { return ""}
        return text
    }

    // MARK: - Private Methods:
    private func configureCellUI() {
        contentView.addSubview(cellTitleLabel)
        contentView.addSubview(checkMark)

        NSLayoutConstraint.activate([
            cellTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.heightAnchor.constraint(equalToConstant: 24),
            checkMark.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
