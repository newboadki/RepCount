//
//  CheckmarkView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

struct CheckmarkButton: View {

    let workout: Workout
    let exercise: Exercise
    @EnvironmentObject private var presenter: DayWorkoutPlanPresenter

    var body: some View {
        Button(action: {
            presenter.setIsCompleteForExercise(exercise: exercise, workout: workout)
        }, label: {
            let isOn = exercise.isCompleted

            if isOn {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        })
    }
}

struct CheckmarkButton_Previews: PreviewProvider {

    static private let workout = Workout.basicStrengthConditioning(workoutId: 0)
    static private let exercise = workout.exercises[0]

    static var previews: some View {
        CheckmarkButton(workout: workout,
                        exercise: exercise)
    }
}
