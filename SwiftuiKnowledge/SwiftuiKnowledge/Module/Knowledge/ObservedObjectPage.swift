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

            Divider()

            Text("David count is \(david.count)")
            Button("增加Count") {
                david.incrementCounter()
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

    private(set) var count = 10

    var type: String
    init(type: String) {
        self.type = type

    }


    // 我们甚至可以手动触发
    func incrementCounter() {
        count += 1

        // 我们发现，通过objectWillChange，直接调用send，同样是可以触发刷新的。
        objectWillChange.send()
    }

    deinit {
        print("person deinit---\(type)")
    }
}
