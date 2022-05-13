//
//  Array+Uniquing.swift
//  RepCount
//
//  Created by Borja Arias Drake on 28.09.2021..
//

import Foundation

extension Collection {

  // Returns an array of O where all values of a given property are unique
  func uniqued<T>(_ map: (Element) -> T) -> AnyCollection<Element>
  where Element: Hashable, T: Equatable {
    var seen = Set<Element>()  //(workouts.compactMap { $0.date })
    for item in self {
      if !seen.contains(where: { seenObject in
        map(seenObject) == map(item)
      }) {
        seen.insert(item)
      }
    }

    return AnyCollection(seen)
  }
}
