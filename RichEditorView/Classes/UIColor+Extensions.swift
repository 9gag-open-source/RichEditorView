//
//  UIColor+Extensions.swift
//  Pods
//
//  Created by Caesar Wirth on 10/9/16.
//
//

import Foundation

internal extension UIColor {

    /// Hexadecimal representation of the UIColor.
    /// For example, UIColor.blackColor() becomes "#000000".
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)

        let r = Int(255.0 * red)
        let g = Int(255.0 * green)
        let b = Int(255.0 * blue)

        let str = String(format: "#%02x%02x%02x", r, g, b)
        return str
    }
    
    static func rgbStringToUIColor(rgbString:String) -> UIColor {
        let scanner = Scanner(string: rgbString)
        var junk, red, green, blue: NSString?
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: &junk)
        scanner.scanUpToCharacters(from: CharacterSet.punctuationCharacters, into: &red)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: &junk)
        scanner.scanUpToCharacters(from: CharacterSet.punctuationCharacters, into: &green)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: &junk)
        scanner.scanUpToCharacters(from: CharacterSet.punctuationCharacters, into: &blue)
        guard let _red = red, let _green = green, let _blue = blue else {
            return UIColor.clear
        }
        return UIColor(red: CGFloat(_red.floatValue/255.0), green: CGFloat(_green.floatValue/255.0), blue: CGFloat(_blue.floatValue/255.0), alpha: 1.0)
    }

}
