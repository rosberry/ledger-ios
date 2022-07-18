//
//  Copyright © 2021 Rosberry. All rights reserved.
//

import Foundation
import StoreKit

public extension SKProductSubscriptionPeriod {
    var period: Period {
        switch unit {
        case .day:
            if numberOfUnits % 7 == 0 {
                return .week(numberOfUnits / 7)
            }
            return .day(numberOfUnits)
        case .week:
            return .week(numberOfUnits)
        case .month:
            return .month(numberOfUnits)
        case .year:
            return .year(numberOfUnits)
        @unknown default:
            return .unknown
        }
    }

    enum Period {
        case day(_ count: Int)
        case week(_ count: Int)
        case month(_ count: Int)
        case year(_ count: Int)
        case unknown

        public func description() -> String {
            switch self {
            case let .day(count):
               return descriptionPeriod("day", count: count)
            case let .week(count):
               return descriptionPeriod("week", count: count)
            case let .month(count):
               return descriptionPeriod("month", count: count)
            case let .year(count):
               return descriptionPeriod("year", count: count)
            case .unknown:
                return "N/A"
            }
        }

        public func descriptionWithFormate(_ dateFormate: String = "d MMMM, yyyy") -> String {
            var dateComponents: DateComponents = .init()
            switch self {
            case let .day(count):
                dateComponents.day = count
            case let .week(count):
                dateComponents.weekOfMonth = count
            case let .month(count):
                dateComponents.month = count
            case let .year(count):
                dateComponents.year = count
            case .unknown:
                return "N/A"
            }
            return descriptionEnded(dateComponents, dateFormat: dateFormate)
        }

        public var numberOfUnits: Int? {
            switch self {
            case .day(let count), .week(let count), .month(let count), .year(let count):
                return count
            case .unknown:
                return nil
            }
        }

        private func descriptionPeriod(_ period: String, count: Int) -> String {
            count <= 1 ? "\(count) " + period : "\(count) " + period + "s"
        }

        private func descriptionEnded(_ dateComponents: DateComponents, dateFormat: String) -> String {
            let date = Calendar.current.date(byAdding: dateComponents, to: Date()) ?? .init()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date)
        }
    }
}
