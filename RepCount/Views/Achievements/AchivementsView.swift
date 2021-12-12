//
//  AchivementsView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 23.09.2021..
//

import SwiftUI
import Resolver

struct AchivementsView: View {

    @ObservedObject private var presenter: AchivementsPresenter = Resolver.resolve()
    
    var body: some View {
        VStack {
            ForEach(presenter.achivements) { achivement in
                Text(achivement.name + " x \(achivement.repCount)")
            }
        }
        .onAppear {
            presenter.onAppear()
        }

    }
}

struct AchivementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchivementsView()
    }
}
