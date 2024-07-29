//
//  ColorTransformer.swift
//  Tracker
//
//  Created by Руслан Халилулин on 20.11.2023.
//

import Foundation
import UIKit

@objc(ColorTransformer)
final class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: ColorTransformer.self))
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }
    
    // Регистрация трансформатора
    static func register() {
        let transformer = ColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
