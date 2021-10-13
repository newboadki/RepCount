//
//  WorkoutView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

struct WorkoutView: View {

    let workout: WorkoutViewModel
    @EnvironmentObject private var presenter: DayWorkoutPlanPresenter

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text(workout.title)
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
        WorkoutView(workout: WorkoutViewModel(id: IndexPath(indexes: [0]),
                                              title: "",
                                              exercises: [ExerciseViewModel(id: IndexPath(indexes: [0, 0]), title: "Exercise 1", isEnabled: true, isCompleted: false)]))
            .environmentObject(DayWorkoutPlanPresenter(plan: DayWorkoutPlan(workouts: []),
                                                       workoutTemplateDataSource: StaticWorkoutTemplatesDataSource(), processExerciseCompletion: ProcessExerciseCompletionInteractor(workoutsPersistenceDataSource: CoreDataWorkoutsDataSource(coreDataController: CoreDataPersistenceController()))))
    }
}

struct WorkoutRow: View {

    let workout: WorkoutViewModel
    let exercise: ExerciseViewModel

    var body: some View {
        HStack {

            CheckmarkButton(exercise: exercise,
                            isDisabled: self.workout.allExercisesCompleted)

            Text(exercise.title)
                .font(.system(size: 17))
                .foregroundColor(self.workout.allExercisesCompleted ? .gray.opacity(0.4) : .black)
        }
        .padding(.vertical, 2)
    }
}
