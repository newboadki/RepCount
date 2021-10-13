//
//  DayWorkoutPlan+Data.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import Foundation

extension DayWorkoutPlan {

    static func basicStrengthConditioningPlan() -> DayWorkoutPlan {
        DayWorkoutPlan(workouts: [
            WorkoutSchedule(id: "morning wk",
                            timeOfDay: .morning,
                            workout: Workout.basicStrengthConditioning(workoutId: 0)),

            WorkoutSchedule(id: "evening wk",
                            timeOfDay: .evening,
                            workout: Workout.basicStrengthConditioning(workoutId: 1))])
    }
}
