//
//  Copyright © 2021 Rosberry. All rights reserved.
//

import Foundation

public extension NSDecimalNumber {
    func localizedPrice(for locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self) ?? "N/A"
    }
}
