//
//  AchivementsCalculator.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import Foundation

struct AchivementsCalculator {

    typealias Achievements = [String : Int]

    enum OperationError: String, Error {
        case couldNotRetrieveRecords = "Unable to retrieve the records from the storage system."
    }


    private let workoutsDataSource: WorkoutsDataSource

    init(workoutsDataSource: WorkoutsDataSource) {
        self.workoutsDataSource = workoutsDataSource
    }

    func achievements() -> Result<Achievements, Error> {
        let results = workoutsDataSource.allWorkouts()


        switch results {
            case .success(let workouts):
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

                return .success(achivements)

            case .failure(_):
                return .failure(OperationError.couldNotRetrieveRecords)
        }

    }
}
