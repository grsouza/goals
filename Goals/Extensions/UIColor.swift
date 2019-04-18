//
//  UIColor.swift
//  MyGoalsApp
//
//  Created by Guilherme Souza on 08/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

extension UIColor {
    /// Creates a UIColor from hexadecimal number.
    ///
    /// - Parameter value: Number in hexadecimal format, example: 0x54C6EB
    /// - Returns: The created UIColor.
    static func hex(value: UInt32) -> UIColor {
        let red = CGFloat((value & 0xFF0000) >> 16)
        let green = CGFloat((value & 0x00FF00) >> 8)
        let blue = CGFloat(value & 0x0000FF)
        return UIColor.rgba(red, green, blue)
    }
    
    /// Creates a UIColor with RGBA format with float numbers. No need for dividing by 255.
    ///
    /// - Parameters:
    ///   - r: red value
    ///   - g: green value
    ///   - b: blue value
    ///   - a: alpha value, defaults to 1
    /// - Returns: The created UIColor
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
