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


    private let workoutsDataSource: WorkoutsDataSource

    init(workoutsDataSource: WorkoutsDataSource) {
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
        return achivements
    }
}
