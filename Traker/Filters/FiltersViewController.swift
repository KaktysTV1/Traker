import Foundation
import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func selectedFilter(_ filter: Filters)
}

final class FiltersViewController: UIViewController {
    // MARK: - Properties:
    weak var delegate: FiltersViewControllerDelegate?
    var selectedFilter: Filters?

    // MARK: - Private Properties:
    private let filters: [Filters] = Filters.allCases
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Localizable.Filter.filtersTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .YPBlack
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var filtersTable: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        table.isScrollEnabled = false
        table.isMultipleTouchEnabled = false
        table.separatorStyle = .singleLine
        table.separatorColor = .YPGrayGray
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.alwaysBounceVertical = true
        table.register(FiltersTableViewCell.self, forCellReuseIdentifier: FiltersTableViewCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self

        return table
    }()

    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .YPWhite
        configureUI()
    }

    // MARK: - Methods

    // MARK: - Private Methods:
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(filtersTable)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),

            filtersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            filtersTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -374)
        ])
    }
}

// MARK: - UITableViewDataSource:
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersTableViewCell.reuseIdentifier) as? FiltersTableViewCell else {
            print("Unable to dequeue cell with identifier: \(FiltersTableViewCell.reuseIdentifier)")
            return UITableViewCell()
        }
        let filterName = filters[indexPath.row].name
        let checkmarkStatus = filterName != selectedFilter?.name
        cell.configureCell(filtersName: filterName, checkmarkStatus: checkmarkStatus)

        if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }

}
// MARK: - UITableViewDelegate:
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell else {
            return
        }
        let isHidden = false
        cell.setCheckMark(isHiden: isHidden)

        let filter = filters[indexPath.row]
        delegate?.selectedFilter(filter)

        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell else {
            return
        }
        cell.setCheckMark(isHiden: true)
    }
}
