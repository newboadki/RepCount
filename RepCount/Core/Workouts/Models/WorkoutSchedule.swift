//
//  WorkoutSchedule.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

struct WorkoutSchedule: Identifiable {
    enum TimeOfDay: String {
        case morning = "morning"
        case evening = "evening"
    }

    let id: String
    var timeOfDay: TimeOfDay
    var workout: Workout
}
