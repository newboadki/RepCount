//
//  DayWorkoutPlanPresenter.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import SwiftUI
import CoreData

struct WorkoutScheduleViewModel {
    let title: String
    let workouts: [WorkoutViewModel]
}

struct WorkoutViewModel: Identifiable {
    let id: IndexPath
    let title: String
    var exercises: [ExerciseViewModel]

    var allExercisesCompleted: Bool {
        get {
            exercises.reduce(true) { partialResult, exercise in
                partialResult && exercise.isCompleted
            }
        }
    }
}

struct ExerciseViewModel: Identifiable {
    let id: IndexPath
    let title: String
    var isEnabled: Bool
    var isCompleted: Bool
}

class DayWorkoutPlanPresenter: ObservableObject {

    struct ErrorDescription {
        var title: String = ""
        var message: String = ""
    }
    
    @Published var workoutViewModels: [WorkoutViewModel]
    @Published var shouldPresentError = false
    var errorDescription = ErrorDescription()

    private var plan: DayWorkoutPlan
    private let workoutsDataSource: WorkoutsDataSource

    //probably we want to retrieve the plan from an interactor or data source
    init(plan: DayWorkoutPlan, workoutsDataSource: WorkoutsDataSource) {
        self.workoutViewModels = DayWorkoutPlanPresenter.map(plan: plan)
        self.plan = plan
        self.workoutsDataSource = workoutsDataSource
    }

    func setIsCompleteForExercise(at indexPath: IndexPath) {
        // Checks before proceeding
        guard indexPath.count == 2 else {
            return
        }

        guard let workoutIndex = indexPath.first else {
            return
        }

        // Update the view model
        let exerciseIndex = indexPath[1]
        self.workoutViewModels[workoutIndex].exercises[exerciseIndex].isCompleted.toggle()
        self.workoutViewModels[workoutIndex].exercises[exerciseIndex].isEnabled = !plan.workouts[workoutIndex].workout.allExercisesCompleted

        // Save the completed workout
        if self.workoutViewModels[workoutIndex].allExercisesCompleted {
            // Save
            if let workoutForSaving = Self.map(workoutViewModel: self.workoutViewModels[workoutIndex], plan: self.plan) {
                self.saveWorkout(workoutForSaving)
                // Update the UI with some message or dissabling the workout
                // Disable save
            }
        } else {
            // It should not be possible to edit the workout once completed
        }
    }

    func saveWorkout(_ workout: Workout) {
        var workoutCopy = workout
        workoutCopy.date = Date()
        let result = workoutsDataSource.saveWorkout(workoutCopy)

        switch result {
        case .success(_):
            shouldPresentError = false

        case .failure(let error ):
            errorDescription.title = "Something went wrong"
            errorDescription.message = error.localizedDescription
            shouldPresentError = true
        }
    }

    private static func map(plan: DayWorkoutPlan) -> [WorkoutViewModel] {
        var mappedWorkouts = [WorkoutViewModel]()
        for (workoutIndex, workoutSchedule) in plan.workouts.enumerated() {
            var mappedExercises = [ExerciseViewModel]()
            for (exerciseIndex, exercise) in workoutSchedule.workout.exercises.enumerated() {
                mappedExercises.append(ExerciseViewModel(id: IndexPath(indexes: [workoutIndex, exerciseIndex]),
                                                         title: exercise.name + "" + "\(exercise.repCountGoal)",
                                                         isEnabled: !workoutSchedule.workout.allExercisesCompleted,
                                                         isCompleted: exercise.isCompleted))
            }

            mappedWorkouts.append(WorkoutViewModel(id: IndexPath(indexes: [workoutIndex]),
                                                   title: workoutSchedule.workout.name,
                                                   exercises: mappedExercises))
        }

        return mappedWorkouts
    }

    // should be an interactor, retrieve from data source
    private static func map(workoutViewModel: WorkoutViewModel, plan: DayWorkoutPlan) -> Workout? {
        var mappedExercises = [Exercise]()
        for exerciseViewModel in workoutViewModel.exercises {
            let allExercises = plan.workouts.flatMap { workoutSchedule in
                return workoutSchedule.workout.exercises
            }
            if let soughtExercise = allExercises.first(where: { currentExercise in
                currentExercise.id == exerciseViewModel.id
            }) {
                let modifiedExercise = soughtExercise.modifying(isCompleted: exerciseViewModel.isCompleted)
                mappedExercises.append(modifiedExercise)
            }
        }

        let workouts = plan.workouts.map { schedule in
            return schedule.workout
        }

        if let soughtWorkout = workouts.first(where: { wk in
            wk.id == workoutViewModel.id
        }) {
            let modifiedWorkout = soughtWorkout.modifying(exercises: mappedExercises)
            return modifiedWorkout
        }

        return nil
    }

}
