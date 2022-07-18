//
//  Copyright © 2021 Rosberry. All rights reserved.
//

import Foundation
import StoreKit

public final class IntroductoryOffer: CustomStringConvertible {

    public let price: String
    public let period: SKProductSubscriptionPeriod.Period
    public let paymentMode: SKProductDiscount.PaymentMode

    public var description: String {
       return "[\(price)] with period \(period)"
    }

    public init?(_ storeProduct: SKProduct) {
        guard let introductoryPrice = storeProduct.introductoryPrice else {
            return nil
        }

        let locale = storeProduct.priceLocale
        paymentMode = introductoryPrice.paymentMode
        price = introductoryPrice.price.localizedPrice(for: locale)
        period = introductoryPrice.subscriptionPeriod.period
    }
}
