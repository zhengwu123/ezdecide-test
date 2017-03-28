//
//  NSDate+Zodiac.swift
//  Kelin
//
//  Created by Nurdaulet Bolatov on 5/30/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation

public enum Zodiac {
    case Ram
    case Bull
    case Twins
    case Crab
    case Lion
    case Maiden
    case Scales
    case Scorpion
    case Archer
    case MountainSeaGoat
    case WaterBearer
    case Fish
    case Undefined
}

extension NSDate {
    public var zodiac: Zodiac {
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            else { return .Undefined }
        
        let dateComponents = gregorianCalendar.components([.month, .day], from: self as Date)
        
        let month = dateComponents.month! as Int
        let day = dateComponents.day! as Int
        
        switch (month, day) {
        case (3, 21...31), (4, 1...19):
            return .Ram
        case (4, 20...30), (5, 1...20):
            return .Bull
        case (5, 21...31), (6, 1...20):
            return .Twins
        case (6, 21...30), (7, 1...22):
            return .Crab
        case (7, 23...31), (8, 1...22):
            return .Lion
        case (8, 23...31), (9, 1...22):
            return .Maiden
        case (9, 23...30), (10, 1...22):
            return .Scales
        case (10, 23...31), (11, 1...21):
            return .Scorpion
        case (11, 22...30), (12, 1...21):
            return .Archer
        case (12, 22...31), (1, 1...19):
            return .MountainSeaGoat
        case (1, 20...31), (2, 1...18):
            return .WaterBearer
        case (2, 19...29), (3, 1...20):
            return .Fish
        default:
            return .Undefined
        }
    }
}
