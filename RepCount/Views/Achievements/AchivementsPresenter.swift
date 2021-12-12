//
//  AchivementsPresenter.swift
//  RepCount
//
//  Created by Borja Arias Drake on 25.09.2021..
//

import SwiftUI
import Combine

struct AchivementViewModel: Identifiable {

    var id: String {
        get {
            name + "\(repCount)"
        }
    }

    var name: String

    var repCount: Int
}

final class AchivementsPresenter: ObservableObject {

    @Published var achivements = [AchivementViewModel]()

    private let achivementsCalculator: AchivementsAggregatorInteractor
    private var cancellables = Set<AnyCancellable>()

    init(achivementsCalculator: AchivementsAggregatorInteractor) {
        self.achivementsCalculator = achivementsCalculator
    }

    func onAppear() {
        achivementsCalculator.achievements()
            .receive(on: DispatchQueue.global())
            .map(achivementsDictionaryToModelMapper)
            .catch { error in
                Just([AchivementViewModel]())
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.achivements, on: self)
            .store(in: &cancellables)
    }

    private func achivementsDictionaryToModelMapper(_ achivementsDictionary: [String : Int]) -> [AchivementViewModel] {
        var newAchivements = [AchivementViewModel]()
        for (key, value) in achivementsDictionary {
            newAchivements.append(AchivementViewModel(name: key, repCount: value))
        }
        return newAchivements
    }
}
