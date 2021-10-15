//
//  ExerciseEntity+CoreDataProperties.swift
//  RepCount
//
//  Created by Borja Arias Drake on 15.10.2021..
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var repCountGoal: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var workout: WorkoutEntity?

}

extension ExerciseEntity : Identifiable {

}
