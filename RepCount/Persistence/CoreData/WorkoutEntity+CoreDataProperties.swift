//
//  WorkoutEntity+CoreDataProperties.swift
//  RepCount
//
//  Created by Borja Arias Drake on 15.10.2021..
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension WorkoutEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension WorkoutEntity : Identifiable {

}
