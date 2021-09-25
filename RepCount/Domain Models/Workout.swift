//
//  Workout.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import Foundation
import SwiftUI

struct Workout: Identifiable, Codable {

    let id: Int
    var name: String
    var exercises: [Exercise]    
}

struct Exercise: Identifiable, Codable {

    let id: Int
    let name: String
    let repCountGoal: Int
    var isCompleted: Bool = false
}


