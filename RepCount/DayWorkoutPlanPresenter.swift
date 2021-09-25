//
//  DayWorkoutPlanPresenter.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import SwiftUI
import CoreData

class DayWorkoutPlanPresenter: ObservableObject {

    @Published var plan: DayWorkoutPlan

    private let workoutsDataSource: WorkoutsDataSource

    init(plan: DayWorkoutPlan, workoutsDataSource: WorkoutsDataSource) {
        self.plan = plan
        self.workoutsDataSource = workoutsDataSource
    }

    func setIsCompleteForExercise(exercise: Exercise, workout: Workout) {

        let allWorkouts = plan.workouts.compactMap { schedule in
            schedule.workout
        }

        let wkIndex = allWorkouts.firstIndex { wk in
            wk.id == workout.id
        }

        let exIndex = workout.exercises.firstIndex { e in
            e.id == exercise.id
        }

        guard let wi = wkIndex,
              let ei = exIndex
        else {
            return
        }

        plan.workouts[wi].workout.exercises[ei].isCompleted.toggle()
    }

    func saveWorkout(_ workout: Workout) {
        let result = workoutsDataSource.saveWorkout(workout)

        switch result {
        case .success(_):
            break
        case .failure(_):
            break
        }
    }

    func loadWorkouts() {
        let result = workoutsDataSource.allWorkouts()
        switch result {
        case .success(let wks):
            print(wks)
            break
        case .failure(_):
            break
        }
    }
}
