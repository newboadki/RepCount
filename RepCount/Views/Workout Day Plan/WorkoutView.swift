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

                Button(action: {
                    self.presenter.saveWorkout(workout)
                }, label: {
                    Text("Save")
                        .bold()
                        .foregroundColor(.white)
                })
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange))
            }

            VStack(alignment: .leading) {
                ForEach(workout.exercises) { exercise in
                    HStack {
                        CheckmarkButton(workout: workout, exercise: exercise)
                        Text("\(exercise.name) x \(exercise.repCountGoal)")
                            .font(.system(size: 17))
                    }.padding(.vertical, 2)
                }
            }
            .alert(isPresented: $presenter.shouldPresentError) {
                Alert(title: Text(presenter.errorDescription.title),
                      message: Text(presenter.errorDescription.message),
                      dismissButton: .default(Text("OK")))
            }
        }
        .padding(20)
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout.basicStrengthConditioning(workoutId: 0))
    }
}
