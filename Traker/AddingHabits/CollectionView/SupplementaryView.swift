//
//  SupplementaryView.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation
import UIKit

final class SupplementaryView: UICollectionReusableView {
    // MARK: - Properties:
    static let reuseId = "SupplementaryView"
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .YPBlack
        
        return label
    }()
    
    // MARK: - Methods:
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 28),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
