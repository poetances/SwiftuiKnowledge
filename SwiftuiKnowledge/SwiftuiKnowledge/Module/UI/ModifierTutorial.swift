//
//  ModifierPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/6.
//

import SwiftUI

struct ModifierTutorial: View {
    var body: some View {
        VStack {
            Button("Hello,world") {

            }
            .frame(width: 200, height: 200)
            .background(.red)


            Text("Hello, world!")
                .padding()
                .background(.red)
                .padding()
                .background(.blue)
                .padding()
                .background(.green)
                .padding()
                .background(.yellow)
        }

    }
}

struct ModifierPage_Previews: PreviewProvider {
    static var previews: some View {
        ModifierTutorial()
    }
}

