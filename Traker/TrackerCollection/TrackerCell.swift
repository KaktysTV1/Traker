//
//  TrackerCell.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 01.12.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func recordTrackerCompletionForSelectedDate(id: UInt)
    func removeTrackerCompletionForSelectedDate(id: UInt)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    private var completionCounter: Int = 0 {
        didSet {
            updateHabitStatisticsLabelDays()
        }
    }
    private var isCompletedToday: Bool = false {
        didSet {
            updateCompletionButtonState()
        }
    }
    
    private var trackerId: UInt = 0
    
    private var cellDescriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private var taskDescriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        label.attributedText = NSMutableAttributedString(string: "Default text", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        return label
    }()
    
    private var emojiLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var statisticLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.text = "0 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var compliteButton: UIButton = {
        let image = UIImage(named: "plus")
        var button = UIButton.systemButton(with: image!, target: self, action: #selector(compliteTask))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateHabitStatisticsLabelDays(){
        statisticLabel.text = completionCounter == 1
        ? String(completionCounter) + " день"
        : String(completionCounter) + " дней"
    }
    private func updateCompletionButtonState() {
        if isCompletedToday {
            compliteButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            compliteButton.alpha = 1
        } else {
            compliteButton.setImage(UIImage(systemName: "plus"), for: .normal)
            compliteButton.alpha = 0.3
        }
    }
    
    func setupTrackerCell(descriptionName: String,
                          emoji: String,
                          descriptionViewBackgroundColor: UIColor,
                          completionButtonTintColor: UIColor,
                          trackerID: UInt,
                          counter: Int,
                          completionFlag: Bool) {
        taskDescriptionLabel.text = descriptionName
        emojiLabel.text = emoji
        cellDescriptionView.backgroundColor = descriptionViewBackgroundColor
        compliteButton.tintColor = completionButtonTintColor
        completionCounter = counter
        trackerId = trackerID
        isCompletedToday = completionFlag
    }
    
    private func setupView(){
        contentView.addSubview(cellDescriptionView)
        contentView.addSubview(statisticLabel)
        contentView.addSubview(compliteButton)
        
        cellDescriptionView.addSubview(taskDescriptionLabel)
        cellDescriptionView.addSubview(emojiLabel)
    }
    
    private func setupConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(cellDescriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(cellDescriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(cellDescriptionView.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(cellDescriptionView.heightAnchor.constraint(equalToConstant: 90))
        
        constraints.append(emojiLabel.leadingAnchor.constraint(equalTo: taskDescriptionLabel.leadingAnchor, constant: 12))
        constraints.append(emojiLabel.topAnchor.constraint(equalTo: taskDescriptionLabel.topAnchor, constant: 12))
        
        constraints.append(taskDescriptionLabel.leadingAnchor.constraint(equalTo: cellDescriptionView.leadingAnchor, constant: 12))
        constraints.append(taskDescriptionLabel.trailingAnchor.constraint(equalTo: cellDescriptionView.trailingAnchor, constant: -12))
        constraints.append(taskDescriptionLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8))
        constraints.append(taskDescriptionLabel.bottomAnchor.constraint(equalTo: cellDescriptionView.bottomAnchor, constant: -12))
        
        constraints.append(statisticLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12))
        constraints.append(statisticLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12))
        constraints.append(statisticLabel.topAnchor.constraint(equalTo: cellDescriptionView.bottomAnchor, constant: 16))
        constraints.append(statisticLabel.centerYAnchor.constraint(equalTo: statisticLabel.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc private func compliteTask(){
        print("Task is complite")
    }
}
