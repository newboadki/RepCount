//
//  WorkoutsDataSource.swift
//  RepCount
//
//  Created by Borja Arias Drake on 11.10.2021..
//

import Combine

protocol WorkoutsDataSource {
    func saveWorkout(_ workout: Workout) -> Result<Void, Error>
    func allWorkouts() -> Future<[Workout], Error>
}
