//
//  StatePage.swift
//  SwiftuiKnowledge
//
//  Created by ZhuChaoJun on 2022/6/10.
//

import SwiftUI


struct StatePage: View {

    @State private var count = 0

    private var _count1 = 0


    var body: some View {
        VStack {
            DetailView(count: count)
            DetailView1(number: count)

            Button("add count") {
                count += 1
                print("当前地址：", Mems.ptr(ofVal: &count))
            }
        }
    }

    mutating func addCountButtonClick() {
        _count1 += 1
    }
}

struct DetailView: View {
    let count: Int
    var body: some View {
        Text("detail view count: \(count)")
            .padding(.bottom)
    }
}

struct DetailView1: View {

    @State private var number: Int

    init(number: Int) {
        self.number = number
    }

    var body: some View {
        VStack {
            Text("DetailView1 number: \(number)")
                .padding(.bottom)

            Button("add number") {
                number += 1
            }.padding(.bottom)
        }
    }
}


struct StatePage_Previews: PreviewProvider {
    static var previews: some View {
        StatePage()
    }
}
