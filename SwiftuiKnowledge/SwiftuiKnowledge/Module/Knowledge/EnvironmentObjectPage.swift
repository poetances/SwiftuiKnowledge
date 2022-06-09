//
//  SDEnvironmentObjectPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/23.
//

import SwiftUI

struct EnvironmentObjectPage: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack {
            Text("David score is \(settings.score)")
            Button("增加分数") {
                settings.score += 1
            }.buttonStyle(.automatic)

        }
    }
}

struct SDEnvironmentObjectPage_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentObjectPage()
    }
}

class UserSettings: ObservableObject {

    @Published var score = 80
}
