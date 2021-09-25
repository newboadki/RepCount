//
//  AchivementsPresenter.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI

struct AchivementViewModel: Identifiable {

    var id: String {
        get {
            name + "\(repCount)"
        }
    }

    var name: String

    var repCount: Int
}

class AchivementsPresenter: ObservableObject {

    @Published var achivements = [AchivementViewModel]()

    private let achivementsCalculator: AchivementsCalculator

    init(achivementsCalculator: AchivementsCalculator) {
        self.achivementsCalculator = achivementsCalculator
    }

    func viewDidAppear() {
        let results = achivementsCalculator.achievements()

        switch results {
            case .success(let retrievedAchivements):
            var newAchivements = [AchivementViewModel]()
            for (key, value) in retrievedAchivements {
                newAchivements.append(AchivementViewModel(name: key, repCount: value))
            }
            self.achivements = newAchivements

            case .failure(let error):
                break
        }
    }
}
