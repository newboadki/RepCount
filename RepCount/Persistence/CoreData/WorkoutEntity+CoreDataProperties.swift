//
//  WorkoutEntity+CoreDataProperties.swift
//  RepCount
//
//  Created by Borja Arias Drake on 20.09.2021..
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged var workout: CoreDataWorkout?

}

extension WorkoutEntity : Identifiable {

}
