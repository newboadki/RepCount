//
//  RepCountApp.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import SwiftUI

@main
struct RepCountApp: App {

    static let workoutsDataSource = CoreDataWorkoutsDataSource(coreDataController: CoreDataPersistenceController())
    let persistenceController = CoreDataPersistenceController.shared
    let achivementsPresenter = AchivementsPresenter(achivementsCalculator: AchivementsAggregatorInteractor(workoutsDataSource: workoutsDataSource))
    let dayPlanPresenter =  DayWorkoutPlanPresenter(plan: StaticWorkoutTemplatesDataSource().basicStrengthConditioningPlan(),
                                                    workoutTemplateDataSource: StaticWorkoutTemplatesDataSource(), processExerciseCompletion: ProcessExerciseCompletionInteractor(workoutsPersistenceDataSource: workoutsDataSource))

    var body: some Scene {
        WindowGroup{

            DayWorkoutPlanView()
                .environmentObject(dayPlanPresenter)
                .environmentObject(achivementsPresenter)
        }
    }
}
