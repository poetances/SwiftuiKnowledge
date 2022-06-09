//
//  ViewBuilderPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/6.
//

import SwiftUI

// @_functionBuilder struct ViewBuilder
// 像VStack就是基于
struct ViewBuilderPage: View {

    var body: some View {
        VStack {
            HStack{
                Text("hello1")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.purple)
                    .font(.title)
                Text("world")
            }
            .frame(height: 300)
            Button("Mirror") {
                // Mirror for TupleView<(HStack<TupleView<(Text, Text)>>, ModifiedContent<Button<Text>, ButtonStyleModifier<DefaultButtonStyle>>)>
                let mirror = Mirror(reflecting: body)

                print(mirror.children, mirror.children.count, mirror.subjectType)
            }
            .buttonStyle(.automatic)
        }
    }
}

struct ViewBuilderPage_Previews: PreviewProvider {
    static var previews: some View {
        ViewBuilderPage()
    }
}
