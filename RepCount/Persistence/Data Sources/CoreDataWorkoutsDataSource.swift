//
//  WorkoutsDataSource.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import Foundation
import CoreData
import Combine

class CoreDataWorkoutsDataSource: WorkoutsPersistenceDataSource {

    enum OperationError: String, Error {
        case couldNotRetrieveRecords = "Unable to retrieve the records from the storage system."
    }

    private let coreDataController: CoreDataPersistenceController

    init(coreDataController: CoreDataPersistenceController) {
        self.coreDataController = coreDataController
    }

    func saveWorkout(_ workout: Workout) -> Result<Void, Error> {        
        let viewContext = coreDataController.container.viewContext
        let workoutEntity = WorkoutEntity(context: viewContext)
        workoutEntity.name = workout.name
        var coreDataExercises: [ExerciseEntity] = []
        for ex in workout.exercises {
            let exerciseEntity = ExerciseEntity(context: viewContext)
            exerciseEntity.name = ex.name
            exerciseEntity.repCountGoal = Int64(ex.repCountGoal)
            exerciseEntity.isCompleted = ex.isCompleted
            exerciseEntity.workout = workoutEntity
            coreDataExercises.append(exerciseEntity)
        }

        workoutEntity.addToExercises(NSSet(array: coreDataExercises))

        do {
            try viewContext.save()
            return .success(())
        } catch {
            return .failure(error as NSError)
        }
    }

    func allWorkouts() -> Future<[Workout], Error> {
        return Future { promise in
            let context = CoreDataPersistenceController.shared.container.newBackgroundContext()
            context.perform {
                let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")

                do {
                    let result = try context.fetch(request)
                    let allWorkouts: [Workout] = result.compactMap { workoutEntity in
                        var exercises = [Exercise]()
                        if let exerciseEntities = workoutEntity.exercises {
                            for exerciseEntity in exerciseEntities {
                                if let exEntity = exerciseEntity as? ExerciseEntity {
                                    exercises.append(Exercise(id: exEntity.objectID.hashValue,
                                                              name: exEntity.name!,
                                                              repCountGoal: Int(exEntity.repCountGoal),
                                                              isCompleted: exEntity.isCompleted))
                                }
                            }
                        }
                        return Workout(id: workoutEntity.objectID.hashValue,
                                       name: workoutEntity.name!,
                                       date: workoutEntity.date,
                                       exercises: exercises)
                    }
                    promise(.success(allWorkouts))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
