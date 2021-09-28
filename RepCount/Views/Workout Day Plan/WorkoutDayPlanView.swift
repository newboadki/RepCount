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
                            Text(workoutSchedule.timeOfDay.rawValue.capitalized  + " " +  emojiCodeString(forTimeOfDay: workoutSchedule.timeOfDay))
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
        }
    }

    private func emojiCodeString(forTimeOfDay time:  WorkoutSchedule.TimeOfDay) -> String {
        switch time {
        case .morning:
            return "\u{1F305} \u{1F4AA}"
        case .evening:
            return "\u{1F303} \u{1F396} "
        }
    }
}



struct DayWorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayWorkoutPlanView()
    }
}
