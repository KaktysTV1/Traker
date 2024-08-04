//
//  StatisticScreen.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 26.11.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    // MARK: - Private properties:
    private let viewModel: StatisticsViewModel
    private var bestPeriodCount: Int?
    private var idealDaysCount: Int? = 0
    private var averageValueCount: Int?
    private var completedTrackersCount: Int?

    private lazy var stubLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.text = L10n.Localizable.Title.noDataToAnalyze
        label.textColor = .YPBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var stubImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "sadSmile")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private lazy var bestPeriodView: UIView = {
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        gradientView.layer.cornerRadius = 16
        gradientView.layer.masksToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        return gradientView
    }()

    private lazy var bestPeriodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.text = L10n.Localizable.Title.bestPeriod
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var bestPeriodCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .YPBlack
        label.text = String(bestPeriodCount ?? 0)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var idealDaysView: UIView = {
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        gradientView.layer.cornerRadius = 16
        gradientView.layer.masksToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        return gradientView
    }()

    private lazy var idealDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.text = L10n.Localizable.Title.idealDays
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var idealDaysCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .YPBlack
        label.text = String(idealDaysCount ?? 0)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var completedTrackersView: UIView = {
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        gradientView.layer.cornerRadius = 16
        gradientView.layer.masksToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        return gradientView
    }()

    private lazy var completedTrackersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.text = L10n.Localizable.Title.completedTrackers
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var completedTrackersCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .YPBlack
        label.text = String(completedTrackersCount ?? 0)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var averageValueView: UIView = {
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        gradientView.layer.cornerRadius = 16
        gradientView.layer.masksToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        return gradientView
    }()

    private lazy var averageValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        label.text = L10n.Localizable.Title.averageValue
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var averageValueCounter: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .YPBlack
        label.text = String(averageValueCount ?? 0)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - LifeCycle:
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addGradientsToViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .YPWhite

        setupNavBar()
        updateLabelsValues()
        setupUI()
        viewModel.onChange = { [weak self] in
            guard let self = self else { return }
            updateLabelsValues()
            self.showOrHideEmptyLabels()
        }
        showOrHideEmptyLabels()
    }

    // MARK: - Private methods:
    init() {
        viewModel = StatisticsViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        [stubLabel, stubImage, stackView].forEach { self.view.addSubview($0) }
        [bestPeriodLabel, bestPeriodCounter].forEach { bestPeriodView.addSubview($0) }
        [idealDaysLabel, idealDaysCounter].forEach { idealDaysView.addSubview($0) }
        [completedTrackersLabel, completedTrackersCounter].forEach { completedTrackersView.addSubview($0)
        }
        [averageValueLabel, averageValueCounter].forEach {
            averageValueView.addSubview($0)
        }
        [bestPeriodView, idealDaysView, completedTrackersView, averageValueView].forEach { stackView.addArrangedSubview($0)
        }
    }

    private func setupUI() {
        addSubviews()
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            stubImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            stubLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),

            bestPeriodView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bestPeriodView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            idealDaysView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            idealDaysView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            completedTrackersView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            completedTrackersView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            averageValueView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            averageValueView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            bestPeriodLabel.leadingAnchor.constraint(equalTo: bestPeriodView.leadingAnchor, constant: 12),
            bestPeriodLabel.bottomAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: -12),
            bestPeriodLabel.trailingAnchor.constraint(equalTo: bestPeriodView.trailingAnchor, constant: -12),
            idealDaysLabel.leadingAnchor.constraint(equalTo: idealDaysView.leadingAnchor, constant: 12),
            idealDaysLabel.bottomAnchor.constraint(equalTo: idealDaysView.bottomAnchor, constant: -12),
            idealDaysLabel.trailingAnchor.constraint(equalTo: idealDaysView.trailingAnchor, constant: -12),
            completedTrackersLabel.leadingAnchor.constraint(equalTo: completedTrackersView.leadingAnchor, constant: 12),
            completedTrackersLabel.bottomAnchor.constraint(equalTo: completedTrackersView.bottomAnchor, constant: -12),
            completedTrackersLabel.trailingAnchor.constraint(equalTo: completedTrackersView.trailingAnchor, constant: -12),
            averageValueLabel.leadingAnchor.constraint(equalTo: averageValueView.leadingAnchor, constant: 12),
            averageValueLabel.bottomAnchor.constraint(equalTo: averageValueView.bottomAnchor, constant: -12),
            averageValueLabel.trailingAnchor.constraint(equalTo: averageValueView.trailingAnchor, constant: -12),

            bestPeriodCounter.leadingAnchor.constraint(equalTo: bestPeriodView.leadingAnchor, constant: 12),
            bestPeriodCounter.trailingAnchor.constraint(equalTo: bestPeriodView.trailingAnchor, constant: -12),
            bestPeriodCounter.topAnchor.constraint(equalTo: bestPeriodView.topAnchor, constant: 12),
            bestPeriodCounter.bottomAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: -37),
            idealDaysCounter.leadingAnchor.constraint(equalTo: idealDaysView.leadingAnchor, constant: 12),
            idealDaysCounter.trailingAnchor.constraint(equalTo: idealDaysView.trailingAnchor, constant: -12),
            idealDaysCounter.topAnchor.constraint(equalTo: idealDaysView.topAnchor, constant: 12),
            idealDaysCounter.bottomAnchor.constraint(equalTo: idealDaysView.bottomAnchor, constant: -37),
            completedTrackersCounter.leadingAnchor.constraint(equalTo: completedTrackersView.leadingAnchor, constant: 12),
            completedTrackersCounter.trailingAnchor.constraint(equalTo: completedTrackersView.trailingAnchor, constant: -12),
            completedTrackersCounter.topAnchor.constraint(equalTo: completedTrackersView.topAnchor, constant: 12),
            completedTrackersCounter.bottomAnchor.constraint(equalTo: completedTrackersView.bottomAnchor, constant: -37),
            averageValueCounter.leadingAnchor.constraint(equalTo: averageValueView.leadingAnchor, constant: 12),
            averageValueCounter.trailingAnchor.constraint(equalTo: averageValueView.trailingAnchor, constant: -12),
            averageValueCounter.topAnchor.constraint(equalTo: averageValueView.topAnchor, constant: 12),
            averageValueCounter.bottomAnchor.constraint(equalTo: averageValueView.bottomAnchor, constant: -37),

            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -210)
        ])
    }

    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            title = L10n.Localizable.Title.statistics
            navBar.prefersLargeTitles = true
        }
    }

    private func showOrHideEmptyLabels() {
        if completedTrackersCount == nil {
            stubImage.isHidden = false
            stubLabel.isHidden = false
            stackView.isHidden = true
        } else if completedTrackersCount == 0 {
            stubImage.isHidden = false
            stubLabel.isHidden = false
            stackView.isHidden = true
        } else {
            stubImage.isHidden = true
            stubLabel.isHidden = true
            stackView.isHidden = false
        }
    }

    private func addGradientsToViews() {
        bestPeriodView.addGradientBorder(colors: [UIColor(hex: "#FD4C49"), UIColor(hex: "#46E69D"), UIColor(hex: "#007BFA")], width: 2)
        idealDaysView.addGradientBorder(colors: [UIColor(hex: "#FD4C49"), UIColor(hex: "#46E69D"), UIColor(hex: "#007BFA")], width: 2)
        completedTrackersView.addGradientBorder(colors: [UIColor(hex: "#FD4C49"), UIColor(hex: "#46E69D"), UIColor(hex: "#007BFA")], width: 2)
        averageValueView.addGradientBorder(colors: [UIColor(hex: "#FD4C49"), UIColor(hex: "#46E69D"), UIColor(hex: "#007BFA")], width: 2)
    }

    private func updateLabelsValues() {
        completedTrackersCount = viewModel.records.count
        completedTrackersCounter.text = "\(completedTrackersCount ?? 0)"
        bestPeriodCount = viewModel.bestPeriodNumber()
        bestPeriodCounter.text = "\(bestPeriodCount ?? 0)"
        averageValueCount = viewModel.averageValue()
        averageValueCounter.text = "\(averageValueCount ?? 0)"
    }
}
