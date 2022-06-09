//
//  SDAppStorePage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/24.
//

import SwiftUI

struct AppStorePage: View {
    @AppStorage("kToggleState") private var toggleState = false
    @AppStorage("kTest") private var textValue = "kTest"
    var body: some View {
        VStack {
            Toggle("开关", isOn: $toggleState)
                .padding()

            Text("当前Toggle状态: ")
                .padding(.bottom)

            Button("赋值") {
                textValue = "赋值"

            }

            Button("网络请求") {


                print(UserDefaults.standard.string(forKey: "kTest"))
                print(textValue)
            }
            
        }
    }
}

struct SDAppStorePage_Previews: PreviewProvider {
    static var previews: some View {
        AppStorePage()
    }
}
