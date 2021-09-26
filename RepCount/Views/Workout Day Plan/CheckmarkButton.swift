//
//  CheckmarkView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

// MARK: - PREFERENCES
//struct WorkoutChangedCopmpletionStatePreference: PreferenceKey {
//    static var defaultValue: Bool = false
//    static func reduce(value: inout Bool, nextValue: () -> Bool) {
//        value = value && nextValue()
//    }
//}
//
//extension View {
//    func workoutChangedCompletionState(_ value: Bool) -> some View {
//        preference(key: WorkoutChangedCopmpletionStatePreference.self, value: value)
//    }
//}

struct CheckmarkButton: View {

    let workout: Workout
    let exercise: Exercise
    let isDisabled: Bool
    @EnvironmentObject private var presenter: DayWorkoutPlanPresenter

    private var color: Color {
        get {
            isDisabled ? .gray.opacity(0.4) : .blue
        }
    }

    var body: some View {

        Button(action: {
            presenter.setIsCompleteForExercise(exercise: exercise, workout: workout)
        }, label: {
            let isOn = exercise.isCompleted

            if isOn {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(color)
            } else {
                Image(systemName: "circle")
                    .font(.title)
                    .foregroundColor(color)
            }
        })
        .disabled(self.isDisabled)
    }
}

struct CheckmarkButton_Previews: PreviewProvider {

    static private let workout = Workout.basicStrengthConditioning(workoutId: 0)
    static private let exercise = workout.exercises[0]

    static var previews: some View {
        CheckmarkButton(workout: workout,
                        exercise: exercise,
                        isDisabled: false)
    }
}
