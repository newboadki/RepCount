//
//  AchivementsView.swift
//  RepCount
//
//  Created by Borja Arias Drake on 23.09.2021..
//

import SwiftUI

struct AchivementsView: View {
    var body: some View {
        VStack {
            Text("You've completed 120 workout.")
            Text("You've done 1029 push ups.")
            Text("You've done 4000 Abs.")
        }

    }
}

struct AchivementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchivementsView()
    }
}
