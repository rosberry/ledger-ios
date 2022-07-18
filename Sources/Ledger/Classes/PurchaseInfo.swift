//
//  Copyright © 2021 Rosberry. All rights reserved.
//

import Foundation

public struct PurchaseInfo: Codable {
    public enum PurchaseType: String, Codable {
        case nonConsumable
        case subscription
    }

    public let identifier: String
    public let type: PurchaseType
    public let expirationDate: Date
    public let quantity: Int

    public init(identifier: String, type: PurchaseType, expirationDate: Date = .distantFuture, quantity: Int = 1) {
        self.identifier = identifier
        self.type = type
        self.expirationDate = expirationDate
        self.quantity = quantity
    }

    init(product: Product) {
        identifier = product.identifier
        if product.period.numberOfUnits != nil {
            type = .subscription
            var dateComponents: DateComponents = .init()
            switch product.period {
            case let .day(count):
                dateComponents.day = count
            case let .week(count):
                dateComponents.weekOfYear = count
            case let .month(count):
                dateComponents.month = count
            case let .year(count):
                dateComponents.year = count
            case .unknown:
                break
            }
            expirationDate = Calendar.current.date(byAdding: dateComponents, to: Date()) ?? .init()

        }
        else {
            type = .nonConsumable
            expirationDate = .distantFuture
        }
        quantity = 1
    }

    init?(dictionary: [String: Any]) {
        guard let identifier = dictionary["product_id"] as? String else {
            return nil
        }

        self.identifier = identifier
        quantity = (dictionary["quantity"] as? Int) ?? 1
        if let expirationTimestampString = dictionary["expires_date_ms"] as? String,
           let expirationTimestamp = TimeInterval(expirationTimestampString) {
            type = .subscription
            expirationDate = Date(timeIntervalSince1970: expirationTimestamp / 1000.0)
        }
        else {
            type = .nonConsumable
            expirationDate = Date.distantFuture
        }
    }
}
