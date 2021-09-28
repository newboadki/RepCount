//
//  AchivementsView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 23.09.2021..
//

import SwiftUI

struct AchivementsView: View {

    @EnvironmentObject private var presenter: AchivementsPresenter
    
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
