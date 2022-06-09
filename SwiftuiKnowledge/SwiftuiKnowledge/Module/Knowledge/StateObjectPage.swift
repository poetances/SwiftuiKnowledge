//
//  SDStateObjectPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/24.
//

import SwiftUI

struct StateObjectPage: View {
    @StateObject var david = Person(type: "ObservedObject")
    var body: some View {
        VStack {
            Text("David score is \(david.score)")
            Button("增加分数") {
                david.score += 1
            }.buttonStyle(.automatic)

        }.onDisappear {
            print("SDStateObjectPage-disappear")
        }
    }
}

struct SDStateObjectPage_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectPage()
    }
}

