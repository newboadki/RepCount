//
//  Date+Formatting.swift
//  RepCount
//
//  Created by Borja Arias Drake on 28.09.2021..
//

import Foundation

extension Date {

  func toyyyyMMddStringRepresentation() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter.string(from: self)
  }
}
