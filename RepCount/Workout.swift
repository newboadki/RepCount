//
//  Workout.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import Foundation
import SwiftUI

struct DayWorkoutPlan {

    static let BasicStrengthPlan = basicStrengthConditioningPlan()
    var workouts: [WorkoutSchedule]

    private static func basicStrengthConditioningPlan() -> DayWorkoutPlan {
        DayWorkoutPlan(workouts: [WorkoutSchedule(id: "morning wk", timeOfDay: .morning, workout: Workout.basicStrengthConditioning(workoutId: 1)),
                                  WorkoutSchedule(id: "evening wk", timeOfDay: .evening, workout: Workout.basicStrengthConditioning(workoutId: 2))])
    }
}

struct WorkoutSchedule: Identifiable {
    enum TimeOfDay: String {
        case morning = "morning"
        case evening = "evening"
    }

    let id: String
    var timeOfDay: TimeOfDay
    var workout: Workout
}

struct Workout: Identifiable, Codable {

    let id: Int
    var name: String
    var exercises: [Exercise]

    static func basicStrengthConditioning(workoutId: Int) -> Workout {
        return Workout(id: workoutId,
                       name: "Basic Strength",
                       exercises: [Exercise(id: workoutId + 0, name: "squats", repCountGoal: 20),
                                   Exercise(id: workoutId + 1, name: "Bicep rotating curls", repCountGoal: 20),
                                   Exercise(id: workoutId + 2, name: "Bicep rotating curls", repCountGoal: 20),
                                   Exercise(id: workoutId + 3, name: "Bicep bar curls", repCountGoal: 10),
                                   Exercise(id: workoutId + 4, name: "Bicep bar curls", repCountGoal: 10),
                                   Exercise(id: workoutId + 5, name: "Bentover tricep extensions", repCountGoal: 10),
                                   Exercise(id: workoutId + 6, name: "Push-ups 1x20", repCountGoal: 20),
                                   Exercise(id: workoutId + 7, name: "Abs", repCountGoal: 30),
                                   Exercise(id: workoutId + 8, name: "Push-ups 1x10", repCountGoal: 10),
                                   Exercise(id: workoutId + 11, name: "Calf compressions",repCountGoal: 20)])
    }
}

struct Exercise: Identifiable, Codable {

    let id: Int

    let name: String

    // The number of repetitions per series
    let repCountGoal: Int

    var isCompleted: Bool = false
}


