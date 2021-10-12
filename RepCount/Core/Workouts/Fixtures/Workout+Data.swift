//
//  Workout+Data.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import Foundation

extension Workout {

    static func basicStrengthConditioning(workoutId: Int) -> Workout {
        return Workout(id: IndexPath(indexes: [workoutId]),
                       name: "Basic Strength",
                       exercises: [Exercise(id: IndexPath(indexes: [workoutId, 0]), name: "squats", repCountGoal: 20),
                                   Exercise(id:IndexPath(indexes: [workoutId, 1]), name: "Bicep rotating curls", repCountGoal: 20),
                                   Exercise(id:IndexPath(indexes: [workoutId, 2]), name: "Bicep rotating curls", repCountGoal: 20),
                                   Exercise(id:IndexPath(indexes: [workoutId, 3]), name: "Bicep bar curls", repCountGoal: 10),
                                   Exercise(id:IndexPath(indexes: [workoutId, 4]), name: "Bicep bar curls", repCountGoal: 10),
                                   Exercise(id:IndexPath(indexes: [workoutId, 5]), name: "Bentover tricep extensions", repCountGoal: 10),
                                   Exercise(id:IndexPath(indexes: [workoutId, 6]), name: "Push-ups 1x20", repCountGoal: 20),
                                   Exercise(id:IndexPath(indexes: [workoutId, 7]), name: "Abs", repCountGoal: 30),
                                   Exercise(id:IndexPath(indexes: [workoutId, 8]), name: "Push-ups 1x10", repCountGoal: 10),
                                   Exercise(id:IndexPath(indexes: [workoutId, 9]), name: "Calf compressions",repCountGoal: 20)])
    }
}
