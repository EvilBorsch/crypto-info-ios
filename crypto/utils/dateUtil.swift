//
//  ParceDateFromString.swift
//  crypto
//
//  Created by Алексей on 21.12.2020.
//

import Foundation

func getDateFromString(dateString: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime,
                               .withDashSeparatorInDate,
                               .withFullDate,
                               .withFractionalSeconds,
                               .withColonSeparatorInTimeZone]
    guard let date = formatter.date(from: dateString) else {
        return nil
    }
    return date
}

