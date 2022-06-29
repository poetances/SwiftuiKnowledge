//
//  ModifierPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/6.
//

import SwiftUI

/*
 struct ContentView: View {
     var body: some View {
         Text("Hello, world!")
             .background(Color.yellow)
             .font(.title)
             .dump()
     }
 }

 extension View {
     func dump() -> Self {
         print(Mirror(reflecting: self))
         return self
     }
 }
 打印结果：
 Mirror for ModifiedContent<ModifiedContent<Text, _BackgroundModifier<Color>>, _EnvironmentKeyWritingModifier<Optional<Font>>>

 从这个简单的例子我们可以看出，其实swiftui中，每次.xxx其实都是通过Modifier实现。其实都会生成一个ModifyerContent进行属性的包裹。

 Button("Hello, world!") {
 // do nothing
 }
 .background(.red)
 .frame(width: 200, height: 200)

 上面的代码并不会生成带有"Hello，world"的200*200红色按钮。这点和UIKit是有很大差别的。
 我们其实看到的是200*200的空放个，上面是红色矩形，红色矩形里面是“Hello,wrold”

 */
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

            ModifierList()
                .customRefreshAble {
                    print("refresh")
                }
        }

    }
}

struct ModifierPage_Previews: PreviewProvider {
    static var previews: some View {
        ModifierTutorial()
    }
}

// Modifer的扩展
struct ModifierList: View {

    var body: some View {
        List {
            ForEach(0..<200) { index in
                Text("\(index)").padding(.bottom)
            }
        }
    }
}

extension ModifierList {

    func customRefreshAble(_ action: @escaping () async -> ()) -> some View {
        return modifier(RefreshAbleModifier(action: action))
    }
}

struct RefreshAbleModifier: ViewModifier {


    var action: () async -> ()
    func body(content: Content) -> some View {
        content.refreshable {
            await action()
        }
    }
}


