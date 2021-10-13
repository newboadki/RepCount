//
//  WorkoutTemplatesDataSource.swift
//  RepCount
//
//  Created by Borja Arias Drake on 13.10.2021..
//

import Foundation

protocol WorkoutTemplatesDataSource {
    func basicStrengthConditioningPlan() -> DayWorkoutPlan
}
