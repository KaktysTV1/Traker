//
//  Date + Extension.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation

extension Date {
    func sameDay(_ date: Date) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
    
    func dayBefore(_ date: Date) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
    }
}

