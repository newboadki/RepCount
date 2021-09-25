//
//  CoreDataWorkout.swift
//  RepCount
//
//  Created by Borja Arias Drake on 20.09.2021..
//

import Foundation

class CoreDataWorkout: NSObject, Codable, NSSecureCoding {

    static var supportsSecureCoding: Bool = true
    var workout: Workout

    func encode(with coder: NSCoder) {
        do {
            let workoutData = try JSONEncoder().encode(workout)
            coder.encode(workoutData)
        } catch {

        }
    }

    required init?(coder: NSCoder) {
        guard let data = coder.decodeData(),
              let decodedWorkout = try? JSONDecoder().decode(Workout.self, from: data)
        else {
            return nil
        }

        self.workout = decodedWorkout
    }

    init(workout: Workout) {
        self.workout = workout
    }
}
