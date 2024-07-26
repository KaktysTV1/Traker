//
//  Date + Extension.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation

extension Date {
    var onlyDate: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}

