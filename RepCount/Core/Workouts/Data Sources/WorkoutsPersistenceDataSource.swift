//
//  WorkoutsDataSource.swift
//  RepCount
//
//  Created by Borja Arias Drake on 11.10.2021..
//

import Combine

protocol WorkoutsPersistenceGetterDataSource {
    func allWorkouts() -> Future<[Workout], Error>
}

protocol WorkoutsPersistenceStorageDataSource {
    func saveWorkout(_ workout: Workout) -> Future<Void, Error>
}

protocol WorkoutsPersistenceDataSource: WorkoutsPersistenceGetterDataSource & WorkoutsPersistenceStorageDataSource {
}
