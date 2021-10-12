//
//  Workout.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import Foundation
import SwiftUI

struct Workout: Identifiable, Codable, Hashable {

    let id: IndexPath
    let name: String
    var date: Date?
    var exercises: [Exercise]

    /// An alternative version with better performance would be for the Workout class to observe all exercises.
    /// One way of doing this would be via KVO, another one using Combine and Observable Object and @Published.
    /// However that would require changing Exercise to be a class instead of a struct. Which at the moment I consider unwanted.
    var allExercisesCompleted: Bool {
        get {
            exercises.reduce(true) { partialResult, exercise in
                partialResult && exercise.isCompleted
            }
        }
    }

    func modifying(id: IndexPath? = nil, name: String? = nil, date: Date? = nil, exercises: [Exercise]? = nil) -> Workout {
        return Workout(id: id ?? self.id,
                       name: name ?? self.name,
                       date: date ?? self.date,
                       exercises: exercises ?? self.exercises)
    }
}

struct Exercise: Identifiable, Codable, Equatable, Hashable {

    let id: IndexPath
    let name: String
    let repCountGoal: Int
    var isCompleted: Bool = false

    func modifying(id: IndexPath? = nil, name: String? = nil, repCountGoal: Int? = nil, isCompleted: Bool? = nil) -> Exercise {
        return Exercise(id: id ?? self.id,
                        name: name ?? self.name,
                        repCountGoal: repCountGoal ?? self.repCountGoal,
                        isCompleted: isCompleted ?? self.isCompleted)
    }
}
