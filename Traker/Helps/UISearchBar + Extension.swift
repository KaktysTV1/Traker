//
//  UISearchBar + Extension.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation
import UIKit

extension UISearchBar {
    func updateHeight(height: CGFloat, radius: CGFloat = 8.0) {
        let image: UIImage? = UIImage.imageWithColor(color: .YPBackground, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                        }
                    }
                    continue
                }
                if let textField = subSubViews as? UITextField {
                    textField.layer.cornerRadius = radius
                    textField.clipsToBounds = true
                }
            }
        }
    }
}
