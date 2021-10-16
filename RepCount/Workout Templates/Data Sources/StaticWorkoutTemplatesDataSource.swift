//
//  StaticWorkoutTemplatesDataSource.swift
//  RepCount
//
//  Created by Borja Arias Drake on 13.10.2021..
//

import Foundation

struct StaticWorkoutTemplatesDataSource: WorkoutTemplatesDataSource {
    
    func basicStrengthConditioningPlan() -> DayWorkoutPlan {
        return DayWorkoutPlan(workouts: [
                                WorkoutSchedule(id: "morning wk",
                                                timeOfDay: .morning,
                                                workout: self.basicStrengthConditioning(workoutId: 1)),
                                
                                WorkoutSchedule(id: "evening wk",
                                                timeOfDay: .evening,
                                                workout: self.basicStrengthConditioning(workoutId: 2))])
    }
    
    func basicStrengthConditioning(workoutId: Int) -> Workout {
        return Workout(id: workoutId,
                       name: "Basic Strength",
                       exercises: [Exercise(id: workoutId * 100 + 0, name: "squats", repCountGoal: 20),
                                   Exercise(id: workoutId * 100 + 1, name: "Bicep rotating curls", repCountGoal: 20),
                                   Exercise(id: workoutId * 100 + 2, name: "Bicep rotating curls", repCountGoal: 20),
                                   Exercise(id: workoutId * 100 + 3, name: "Bicep bar curls", repCountGoal: 10),
                                   Exercise(id: workoutId * 100 + 4, name: "Bicep bar curls", repCountGoal: 10),
                                   Exercise(id: workoutId * 100 + 5, name: "Bentover tricep extensions", repCountGoal: 10),
                                   Exercise(id: workoutId * 100 + 6, name: "Push-ups 1x20", repCountGoal: 20),
                                   Exercise(id: workoutId * 100 + 7, name: "Abs", repCountGoal: 30),
                                   Exercise(id: workoutId * 100 + 8, name: "Push-ups 1x10", repCountGoal: 10),
                                   Exercise(id: workoutId * 100 + 9, name: "Calf compressions",repCountGoal: 20)])
    }
}
