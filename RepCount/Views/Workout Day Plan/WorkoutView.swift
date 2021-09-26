//
//  WorkoutView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

struct WorkoutView: View {

    let workout: Workout
    @EnvironmentObject private var presenter: DayWorkoutPlanPresenter

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text(workout.name)
                    .font(.headline)
                    .padding(.vertical, 5)

                Spacer()

                if workout.allExercisesCompleted {
                    Text("COMPLETED")
                        .font(.system(size: 11))
                        .bold()
                        .foregroundColor(.white)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.orange))
                }
            }

            VStack(alignment: .leading) {
                ForEach(workout.exercises) { exercise in
                    WorkoutRow(workout: workout, exercise: exercise)
                }
            }
        }
        .padding(20)
        .alert(isPresented: $presenter.shouldPresentError) {
            Alert(title: Text(presenter.errorDescription.title),
                  message: Text(presenter.errorDescription.message),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout.basicStrengthConditioning(workoutId: 0))
    }
}

struct WorkoutRow: View {

    let workout: Workout
    let exercise: Exercise

    var body: some View {
        HStack {

            CheckmarkButton(workout: workout,
                            exercise: exercise,
                            isDisabled: self.workout.allExercisesCompleted)

            Text("\(exercise.name) x \(exercise.repCountGoal)")
                .font(.system(size: 17))
                .foregroundColor(self.workout.allExercisesCompleted ? .gray.opacity(0.4) : .black)
        }
        .padding(.vertical, 2)
    }
}
