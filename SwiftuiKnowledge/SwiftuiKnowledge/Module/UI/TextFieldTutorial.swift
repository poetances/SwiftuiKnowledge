//
//  TextFieldTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/21.
//

import SwiftUI

// SwiftUI的输入，包括TextField、SecurityTextField、TextEditor

struct TextFieldTutorial: View {

    @State private var inputMsg = ""
    @State private var inputPwd = ""
    @State private var inputContent = ""

    @State private var isChecked = false



    var body: some View {
        VStack(alignment: .leading) {
            TextField("请输入文字", text: $inputMsg) { c in
                print(c)
            }
                .disableAutocorrection(true)
                .textCase(.lowercase)
                .keyboardType(.numberPad)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.red)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("完成") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }

            Text("已经输入的内容:\(inputMsg)")

            SecureField("密码输入", text: $inputPwd)
                .keyboardType(.numberPad)
            Text("已经输入的密码:\(inputPwd)")

            Divider()
            TextEditor(text: $inputContent)
                .tint(Color.red)
                .frame(height: 150)
                .textFieldStyle(.roundedBorder)

            HStack {
                Rectangle()
                    .foregroundColor(Color.red)
                    .frame(height: 50)
                    .cornerRadius(15)

                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.yellow)
                    .frame(height: 50)
            }

            HStack {
                Image(systemName: "icloud.slash")
                Image(systemName:  self.isChecked ? "checkmark.circle.fill" : "checkmark.square")
                    .onTapGesture {
                        self.isChecked.toggle()
                    }
            }

        }
        .frame(width: 300)
        .font(.system(size: 16))
        .textFieldStyle(.roundedBorder)


    }
}

struct TextFieldTutorial_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldTutorial()
    }
}
