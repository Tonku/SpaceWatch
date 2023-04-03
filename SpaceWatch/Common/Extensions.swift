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

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }

    func convertToFormattedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d, MMMM, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        guard let date = self.convertToDate() else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
}
