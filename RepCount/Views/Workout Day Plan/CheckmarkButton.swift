//
//  CheckmarkView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

struct CheckmarkButton: View {

    let exercise: ExerciseViewModel
    let isDisabled: Bool
    // TODO: CAN we use a binding instead of the presenteer
    // TODO: Exploore what a binding to a position in an array does
    //   @Published var array: [Int] = []
    //   $presenter.array[0]  -> Binding<Int>
    // The binding would need to capture an index variable, to be able to access a position in the array.
    @EnvironmentObject private var presenter: DayWorkoutPlanPresenter

    private var color: Color {
        get {
            isDisabled ? .gray.opacity(0.4) : .blue
        }
    }

    var body: some View {

        Button(action: {
            presenter.setIsCompleteForExercise(at: exercise.id)
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

    static private let workout = StaticWorkoutTemplatesDataSource().basicStrengthConditioning(workoutId: 0)
    static private let exercise = ExerciseViewModel(id: IndexPath(indexes: [0,0]),
                                                    title: workout.exercises[0].name,
                                                    isEnabled: true,
                                                    isCompleted: false)

    static var previews: some View {
        CheckmarkButton(exercise: exercise, isDisabled: false)
    }
}
