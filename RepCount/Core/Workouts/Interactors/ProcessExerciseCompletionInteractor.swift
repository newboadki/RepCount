//
//  ProcessExerciseCompletionInteractor.swift
//  RepCount
//
//  Created by Borja Arias Drake on 13.10.2021..
//

import Foundation
import Combine

struct ProcessExerciseCompletionInteractor {

    enum ProcessingResult {
        case saved
        case noOp
    }

    private let workoutsPersistenceDataSource: WorkoutsPersistenceStorageDataSource

    init(workoutsPersistenceDataSource: WorkoutsPersistenceStorageDataSource) {
        self.workoutsPersistenceDataSource = workoutsPersistenceDataSource
    }

    func processExerciseCompletion(in workout: Workout) -> AnyPublisher<ProcessingResult, Error> {
        if workout.allExercisesCompleted {
            return self.saveWorkout(workout)
        } else {
            return Just(.noOp).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }

    private func saveWorkout(_ workout: Workout) -> AnyPublisher<ProcessingResult, Error> {
        var workoutCopy = workout
        workoutCopy.date = Date()
        return workoutsPersistenceDataSource.saveWorkout(workoutCopy)
            .map { _ in
                .saved
            }
            .eraseToAnyPublisher()
    }
}
