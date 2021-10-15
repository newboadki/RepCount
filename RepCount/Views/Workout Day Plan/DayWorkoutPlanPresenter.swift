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

    private var plan: DayWorkoutPlan!
    private let workoutTemplateDataSource: WorkoutTemplatesDataSource
    private let processExerciseCompletion: ProcessExerciseCompletionInteractor

    // MARK: - Initializers

    init(plan: DayWorkoutPlan,
         workoutTemplateDataSource: WorkoutTemplatesDataSource,
         processExerciseCompletion: ProcessExerciseCompletionInteractor) {
        self.workoutViewModels = DayWorkoutPlanPresenter.map(plan: plan)        
        self.workoutTemplateDataSource = workoutTemplateDataSource
        self.plan = self.workoutTemplateDataSource.basicStrengthConditioningPlan()
        self.processExerciseCompletion = processExerciseCompletion
    }

    // MARK: - API

    func setIsCompleteForExercise(at indexPath: IndexPath) {
        // Checks before proceeding
        guard indexPath.count == 2 else {
            return
        }

        guard let workoutIndex = indexPath.first else {
            return
        }

        // Update the view model
        // Another way of doing this would be passing bindings to each exercise's isCompleted property.
        // In addition to changing that property the setter code in the binding would do the rest of the logic in this method; calling
        // the interactor.
        let exerciseIndex = indexPath[1]
        self.workoutViewModels[workoutIndex].exercises[exerciseIndex].isCompleted.toggle()
        self.workoutViewModels[workoutIndex].exercises[exerciseIndex].isEnabled = !plan.workouts[workoutIndex].workout.allExercisesCompleted

        // Process the completion event
        if let workoutDomainModel = Self.map(workoutViewModel: self.workoutViewModels[workoutIndex], plan: self.plan) {
            let processingResult = self.processExerciseCompletion.processExerciseCompletion(in: workoutDomainModel)
            switch processingResult {
                case .failure(let error):
                    errorDescription.title = "Something went wrong"
                    errorDescription.message = error.localizedDescription
                    shouldPresentError = true
                case .success(_):
                    shouldPresentError = false
            }
        } else {
            // This would be a programming error
        }
    }

    // MARK: - Domain and View model mappers

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
