import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    // MARK: - Properties:
    static let reuseIdentifier = "ColorCell"
    let colorView = UIView()
    let selectionView = UIView()
    
    // MARK: - Initializers:
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionView.isHidden = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods:
    private func setupViews() {
        selectionView.isHidden = true
        selectionView.backgroundColor = .clear
        selectionView.layer.borderColor = colorView.backgroundColor?.cgColor
        selectionView.layer.cornerRadius = 8
        selectionView.layer.masksToBounds = true
        selectionView.layer.borderWidth = 4
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8
    }
    
    private func setupConstraints() {
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(colorView)
        contentView.addSubview(selectionView)
        
        NSLayoutConstraint.activate([
            selectionView.widthAnchor.constraint(equalToConstant: 52),
            selectionView.heightAnchor.constraint(equalToConstant: 52),
            selectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
