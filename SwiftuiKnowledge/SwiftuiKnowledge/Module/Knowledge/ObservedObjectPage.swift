//
//  SDObservedObject.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/23.
//

import SwiftUI

struct ObservedObjectPage: View {
    @ObservedObject var david = Person(type: "ObservedObject")
    var body: some View {
        VStack {
            Text("David score is \(david.score)")
            Button("增加分数") {
                david.score += 1
            }.buttonStyle(.automatic)

        }.onDisappear {
            print("SDObservedObjectPage-disappear")
        }
    }
}

struct SDObservedObject_Previews: PreviewProvider {
    static var previews: some View {
        ObservedObjectPage()
    }
}


class Person: ObservableObject {
    @Published var score = 80

    var type: String
    init(type: String) {
        self.type = type
    }

    deinit {
        print("person deinit---\(type)")
    }
}
