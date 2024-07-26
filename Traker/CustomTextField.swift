//
//  CustomTextField.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation
import UIKit

final class CustomUITextField: UITextField {
    // MARK: - Properties:
    let insets: UIEdgeInsets
    // MARK: - Initializers:
    init(insets: UIEdgeInsets, placeholder text: String) {
        self.insets = insets
        super.init(frame: .zero)
        
        placeholder = text
        clearButtonMode = .whileEditing
        
        textColor = .YPGray
        font = .systemFont(ofSize: 17, weight: .regular)
        layer.masksToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .YPBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Insets:
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
               return originalRect.offsetBy(dx: -5, dy: 0)
    }
}
