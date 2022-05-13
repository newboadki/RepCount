//
//  Application+Injection.swift
//  RepCount
//
//  Created by Borja Arias Drake on 12.12.2021..
//

import Resolver

extension Resolver: ResolverRegistering {
    
    private static var workoutPersistenceDataSource: WorkoutsPersistenceDataSource = {
        return CoreDataWorkoutsDataSource(coreDataController: CoreDataPersistenceController())
    }()
    
    public static func registerAllServices() {
                
        // Workout persistence data source
        register {
            Self.workoutPersistenceDataSource
        }
        .implements(WorkoutsPersistenceGetterDataSource.self)

        register {
            Self.workoutPersistenceDataSource
        }
        .implements(WorkoutsPersistenceStorageDataSource.self)
        
        // Workout template data source
        register {
            StaticWorkoutTemplatesDataSource()
        }
        .implements(WorkoutTemplatesDataSource.self)
        .scope(.application)
        
        // Presenters
        register {
            DayWorkoutPlanPresenter(plan: StaticWorkoutTemplatesDataSource().basicStrengthConditioningPlan(),
                                           workoutTemplateDataSource: Resolver.resolve(),
                                           processExerciseCompletion: ProcessExerciseCompletionInteractor(workoutsPersistenceDataSource: Resolver.resolve()))
        }
        
        register { AchivementsPresenter(achivementsCalculator: AchivementsAggregatorInteractor(workoutsDataSource: Resolver.resolve())) }
    }
}
