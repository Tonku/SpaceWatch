//
//  Extensions.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 3/4/2023.
//

import UIKit

extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)!
        return UIFont(descriptor: descriptor, size: 0)
    }
}
