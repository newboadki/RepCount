//
//  ProcessExerciseCompletionInteractor.swift
//  RepCount
//
//  Created by Borja Arias Drake on 13.10.2021..
//

import Foundation

struct ProcessExerciseCompletionInteractor {

    enum ProcessingResult {
        case saved
        case noOp
    }

    private let workoutsPersistenceDataSource: WorkoutsPersistenceStorageDataSource

    init(workoutsPersistenceDataSource: WorkoutsPersistenceStorageDataSource) {
        self.workoutsPersistenceDataSource = workoutsPersistenceDataSource
    }

    func processExerciseCompletion(in workout: Workout) -> Result<ProcessingResult, Error> {
        if workout.allExercisesCompleted {
            return self.saveWorkout(workout)
        } else {
            return .success(.noOp)
        }
    }

    private func saveWorkout(_ workout: Workout) -> Result<ProcessingResult, Error> {
        var workoutCopy = workout
        workoutCopy.date = Date()
        let result = workoutsPersistenceDataSource.saveWorkout(workoutCopy)

        switch result {
            case .success(_):
                return .success(.saved)

            case .failure(let error):
                return .failure(error)
        }
    }
}
