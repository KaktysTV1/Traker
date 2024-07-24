//
//  ColorCell.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    // MARK: - Properties:
    static let reuseIdentifier = "ColorCell"
    let colorView = UIView()
    
    // MARK: - Methods:
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
