//
//  ButtonTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/21.
//

import SwiftUI

struct ButtonTutorial: View {
    @State private var items = [Item]()

    var body: some View {
        // basic
        // addToContainers
        // systemButton
        customButton
    }


}

// MARK: - basic
extension ButtonTutorial {
    var basic: some View {
        VStack {
            HStack {
                // 直接初始化
                Button("button1", action: button1Click)
                    .font(.title)
                    .foregroundColor(Color.red)

                // lable是泛型，遵循View协议
                Button(action: button2Click) {
                    Text("button2")
                        .font(.title)
                }

            }
        }
    }

    func button1Click() {

        print("button1 click")
    }

    func button2Click() {
        print("button2 click")
    }
}

// MARK: - basic use
extension ButtonTutorial {
    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let desc: String
    }


    var addToContainers: some View {
        List {
            ForEach(items) { item in
                Text(item.title)
            }
            Button("Add item", action: addItemButtonClick)
        }
    }

    func addItemButtonClick() {
        let newitem = Item(title: "new item title", desc: Date.now.description)
        items.append(newitem)
    }
}

// MARK: - system config
extension ButtonTutorial {

    var systemButton: some View {
        VStack {
            // 点击有hover样式，类似flutter中EvalteAteButton。
            Button("DefaultStyle") {
                print("默认样式")
            }
            .buttonStyle(DefaultButtonStyle())

            // 点击没有返回样式，类似flutter中TextButton。
            Button("PlainButtonStyle") {
                print("PlainButtonStyle")
            }
            .buttonStyle(PlainButtonStyle())

            // 和DefaultButtonStyle没什么两样
            Button("BorderlessButtonStyle") {
                print("BorderlessButtonStyle")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

// MARK: - custom config
extension ButtonTutorial {

    var customButton: some View {
        VStack {

            Button("RoundedRectangleButtonStyle") {
                print("RoundedRectangleButtonStyleClick")

            }.buttonStyle(RoundedRectangleButtonStyle())

            Button("DoubleTapStyle") {
                print("DoubleTapStyle")
            }.buttonStyle(DoubleTapStyle())
        }
    }

    // configuration有两个参数，lable和isPress。
    // labe其实就是button的创建时候的lable，isPress是点击，也就是点击时候的状态
    struct RoundedRectangleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {

            configuration.label
                .foregroundColor(Color.black)
                .padding()
                .background(Color.yellow.cornerRadius(5))
                .scaleEffect(configuration.isPressed ? 0.95:1.0)

        }
    }

    // PrimitiveButtonStyleConfiguration但是isPressed现在被trigger()函数所取代:
    struct DoubleTapStyle: PrimitiveButtonStyle {
        func makeBody(configuration: Configuration) -> some View {

            // 点击两次触发trigger方法
            configuration.label
                .onTapGesture(count: 2, perform: configuration.trigger)
        }
    }

}

struct ButtonTutorial_Previews: PreviewProvider {
    static var previews: some View {
        ButtonTutorial()
    }
}
