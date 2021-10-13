//
//  AchivementsCalculator.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import Foundation
import Combine

struct AchivementsCalculator {

    typealias Achievements = [String : Int]

    enum OperationError: String, Error {
        case couldNotRetrieveRecords = "Unable to retrieve the records from the storage system."
    }


    private let workoutsDataSource: WorkoutsPersistenceGetterDataSource

    init(workoutsDataSource: WorkoutsPersistenceGetterDataSource) {
        self.workoutsDataSource = workoutsDataSource
    }

    func achievements() -> AnyPublisher<Achievements, Error> {
        return workoutsDataSource.allWorkouts()
            .map(workoutToAchievementsDictionaryMapper)
            .eraseToAnyPublisher()
    }

    private func workoutToAchievementsDictionaryMapper(_ workouts: [Workout]) -> Achievements {
        var achivements = [String : Int]()
        for workout in workouts {
            for exercise in workout.exercises {
                guard exercise.isCompleted else {
                    continue
                }

                if let previousValue = achivements[exercise.name] {
                    achivements[exercise.name] = previousValue + exercise.repCountGoal
                } else {
                    achivements[exercise.name] = exercise.repCountGoal
                }
            }
        }
        achivements["Workouts completed"] = workouts.count

        let workoutsFromdistinctDays = workouts.uniqued { $0.date?.toyyyyMMddStringRepresentation() }

        achivements["# of days worked out"] = workoutsFromdistinctDays.count

        return achivements
    }
}
