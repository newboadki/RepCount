//
//  Workout.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import Foundation
import SwiftUI

struct Workout: Identifiable, Codable {

    let id: Int
    var name: String
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
}

struct Exercise: Identifiable, Codable {

    let id: Int
    let name: String
    let repCountGoal: Int
    var isCompleted: Bool = false
}
