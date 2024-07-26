import Foundation
import UIKit

final class EmojiCell: UICollectionViewCell {
    // MARK: - Properties:
    static let reuseIdentifier = "EmojiCell"
    let emojiLabel = UILabel()
    let selectionView = UIView()
    // MARK: - Methods:
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionView.backgroundColor = .clear
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectionView.backgroundColor = .clear
        selectionView.layer.masksToBounds = true
        selectionView.layer.cornerRadius = 16
        emojiLabel.font = .systemFont(ofSize: 32)

        contentView.addSubview(selectionView)
        selectionView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            selectionView.widthAnchor.constraint(equalToConstant: 52),
            selectionView.heightAnchor.constraint(equalToConstant: 52),
            emojiLabel.centerXAnchor.constraint(equalTo: selectionView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: selectionView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
