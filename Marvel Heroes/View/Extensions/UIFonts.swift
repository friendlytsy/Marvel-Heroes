//
//  UIFonts.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 23.09.2021.
//

import UIKit

extension UIFont {
    static let regular = UIFont(name: "Arial", size: 18.0)!
    static let light = UIFont(name: "Apple Symbols", size: 16.0)!

    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: size)!
    }

    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Black", size: size)!
    }
}
