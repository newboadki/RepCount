//
//  WorkoutCoreDataTransformator.swift
//  RepCount
//
//  Created by Borja Arias Drake on 20.09.2021..
//

import UIKit

class WorkoutToDataTransformer: NSSecureUnarchiveFromDataTransformer {

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return CoreDataWorkout.self
    }

    override class var allowedTopLevelClasses: [AnyClass] {
        return [CoreDataWorkout.self]
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let wk = value as? CoreDataWorkout else {
            fatalError("Wrong data type: value must be a UIColor object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(wk)
    }
}

extension NSValueTransformerName {
    static let workoutToDataTransformer = NSValueTransformerName(rawValue: "WorkoutToDataTransformer")
}
