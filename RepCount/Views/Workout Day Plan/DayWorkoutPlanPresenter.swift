//
//  DayWorkoutPlanPresenter.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import SwiftUI
import CoreData
import Combine

struct WorkoutScheduleViewModel {
    let title: String
    let workouts: [WorkoutViewModel]
}

struct WorkoutViewModel: Identifiable {
    let id: Int
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
    let id: Int
    let title: String
    var isEnabled: Bool
    var isCompleted: Bool
}

final class DayWorkoutPlanPresenter: ObservableObject {

    // MARK: - Internal
    
    struct ErrorDescription {
        var titleKey: String = ""
        var message: String = ""
    }
    
    @Published var workoutViewModels: [WorkoutViewModel]
    @Published var shouldPresentError = false
    var errorDescription = ErrorDescription()

    // MARK: - Private
    
    private var plan: DayWorkoutPlan!
    private let workoutTemplateDataSource: WorkoutTemplatesDataSource
    private let processExerciseCompletion: ProcessExerciseCompletionInteractor
    private var processingCompletionCancellable: AnyCancellable?

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

    func setIsCompleteForExercise(withId id: Int) {
        let (foundWorkoutIndex, foundExerciseIndex) = findIndexes(forExerciseId: id)
        guard let workoutIndex = foundWorkoutIndex, let exerciseIndex = foundExerciseIndex else {
            return
        }
        updateViewModel(workoutIndex: workoutIndex, exerciseIndex: exerciseIndex)
        processCompletionEvent(workoutIndex: workoutIndex)
    }

    // MARK: - Private helpers

    private func findIndexes(forExerciseId id: Int) -> (workoutIndex: Int?, exerciseIndex: Int?) {
        for (workoutIndex, workout) in self.workoutViewModels.enumerated() {
            let workoutIds = workout.exercises.compactMap { $0.id }
            if let firstIndexOfExerciseId = workoutIds.firstIndex(of: id) {
                return (workoutIndex: workoutIndex, exerciseIndex: firstIndexOfExerciseId)
            }
        }

        return (workoutIndex: nil, exerciseIndex: nil)
    }

    private func updateViewModel(workoutIndex: Int, exerciseIndex: Int) {
        // Update the view model
        // Another way of doing this would be passing bindings to each exercise's isCompleted property.
        // In addition to changing that property the setter code in the binding would do the rest of the logic in this method; calling
        // the interactor.
        self.workoutViewModels[workoutIndex].exercises[exerciseIndex].isCompleted.toggle()
        self.workoutViewModels[workoutIndex].exercises[exerciseIndex].isEnabled = !plan.workouts[workoutIndex].workout.allExercisesCompleted
    }

    private func processCompletionEvent(workoutIndex: Int) {
        if let workoutDomainModel = Self.map(workoutViewModel: self.workoutViewModels[workoutIndex], plan: self.plan) {
            self.processingCompletionCancellable = self.processExerciseCompletion.processExerciseCompletion(in: workoutDomainModel)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .failure(let completionError):
                            self.errorDescription.titleKey = "generic.error.title"
                            self.errorDescription.message = completionError.localizedDescription
                            self.shouldPresentError = true
                        case .finished:
                            self.processingCompletionCancellable = nil
                    }
                },
                receiveValue: { processingResult in
                    switch processingResult {
                        case .saved, .noOp:
                            self.shouldPresentError = false
                    }
                })
        } else {
            fatalError("Programmer error.")
        }
    }

    // MARK: - Domain and View model mappers

    private static func map(plan: DayWorkoutPlan) -> [WorkoutViewModel] {
        var mappedWorkouts = [WorkoutViewModel]()
        for workoutSchedule in plan.workouts {
            var mappedExercises = [ExerciseViewModel]()
            for exercise in workoutSchedule.workout.exercises {
                mappedExercises.append(ExerciseViewModel(id: exercise.id,
                                                         title: exercise.name + "" + "\(exercise.repCountGoal)",
                                                         isEnabled: !workoutSchedule.workout.allExercisesCompleted,
                                                         isCompleted: exercise.isCompleted))
            }

            mappedWorkouts.append(WorkoutViewModel(id: workoutSchedule.workout.id,
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
