//
//  PropertyWrapperPage.swift
//  SwiftuiKnowledge
//
//  Created by ZhuChaoJun on 2022/6/28.
//

import SwiftUI

struct PropertyWrapperPage: View {

    var age: Int = 12

    @UserDefault("isLike", defaultValue: true)
    static var like: Bool

    var body: some View {
        Button("UserDefaults-get") {
            print(UserDefaults.standard.firstEnter)
        }.buttonStyle(.plain).padding(.bottom)

        Button("UserDefaults-set") {
            UserDefaults.standard.firstEnter = true
        }.padding(.bottom)

        // 如果我们想使用属性包装器，那么我们可以仿照系统的Appstorage
        Button("PropertyWrapper-get") {
            print(PropertyWrapperPage.like)
        }.padding(.bottom)

        Button("PropertyWrapper-set") {
            PropertyWrapperPage.like = false
        }.padding(.bottom)

    }
}

struct PropertyWrapperPage_Previews: PreviewProvider {
    static var previews: some View {
        PropertyWrapperPage()
    }
}


// 比如这种写法，就是比较传统的写法
extension UserDefaults {

    enum Keys {
        static let firstEnter = "firstEnter"
    }

    var firstEnter: Bool {
        set {
            set(newValue, forKey: Keys.firstEnter)
        }
        get {
            bool(forKey: Keys.firstEnter)
        }
    }
}


// propertywrapper
@propertyWrapper // 告诉编译器，这是一个属性包装器
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    // 必须要实现该方法
    var wrappedValue: Value {
        get { UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }

    }
}
