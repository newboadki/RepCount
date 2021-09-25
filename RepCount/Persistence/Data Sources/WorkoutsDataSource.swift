//
//  WorkoutsDataSource.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import Foundation
import CoreData

class WorkoutsDataSource {

    enum OperationError: String, Error {
        case couldNotRetrieveRecords = "Unable to retrieve the records from the storage system."
    }

    private let coreDataController: CoreDataPersistenceController

    init(coreDataController: CoreDataPersistenceController) {
        self.coreDataController = coreDataController
    }

    func saveWorkout(_ workout: Workout) -> Result<Void, Error> {        
        let viewContext = coreDataController.container.viewContext
        let newItem = WorkoutEntity(context: viewContext)
        newItem.workout = CoreDataWorkout(workout: workout)

        do {
            try viewContext.save()
            return .success(())
        } catch {
            return .failure(error as NSError)
        }
    }

    func allWorkouts() -> Result<[Workout], Error> {
        let context = CoreDataPersistenceController.shared.container.newBackgroundContext()
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")

        do {
            let result = try context.fetch(request)
            let allWorkouts = result.compactMap { workoutEntity in
                workoutEntity.workout?.workout
            }
            return .success(allWorkouts)
        } catch {
            return .failure(OperationError.couldNotRetrieveRecords)
        }
    }
}
