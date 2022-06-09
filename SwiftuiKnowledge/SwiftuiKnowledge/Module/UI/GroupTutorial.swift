//
//  ListTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/24.
//

import SwiftUI

struct GroupTutorial: View {

    @State private var layoutV = false
    var body: some View {
        Group {

            if layoutV {
                VStack {
                    Text("你好，")
                    Text("世界")
                }
            } else {
                HStack {
                    Text("你好，")
                    Text("世界")
                }
            }

            Button("改变布局") {
                layoutV = !layoutV
            }.padding(.top)
        }
    }
}

struct GroupTutorial_Previews: PreviewProvider {
    static var previews: some View {
        GroupTutorial()
    }
}
