//
//  WorkoutView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import SwiftUI

struct DayWorkoutPlanView: View {

    @EnvironmentObject private var presenter: DayWorkoutPlanPresenter

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(presenter.plan.workouts) { workoutSchedule in
                        VStack {
                            Text(workoutSchedule.timeOfDay.rawValue.capitalized)
                                .font(.title)
                            WorkoutView(workout: workoutSchedule.workout)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                    NavigationLink(destination: AchivementsView()) {
                        Text("Achivements")
                            .bold()
                            .foregroundColor(.white)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.green))
                    }
)
            }
            .padding(.vertical, 20)
            .onAppear {
                presenter.loadWorkouts()
            }
        }
    }
}

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
        }
        .padding(20)
    }
}

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

struct DayWorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayWorkoutPlanView()
    }
}
