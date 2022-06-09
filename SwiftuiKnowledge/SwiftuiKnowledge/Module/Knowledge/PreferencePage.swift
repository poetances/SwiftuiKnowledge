//
//  PreferencePage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/2.
//

import SwiftUI

struct PreferencePage: View {
    var body: some View {
        // onPreferenceChange
        // overlayPreferenceValue
        // backgroundPreferenceValue
        // transformPreference
        anchorGeo
    }

    // MARK: onPreferenceChange
    var onPreferenceChange: some View {
        VStack {
            Text("View that sets a preference key when loaded")
                .preference(key: CustomPreferenceKey.self, value: "new value")

            Text("View that sets a preference key when loaded2")
                .preference(key: CustomPreferenceKey.self, value: "new value 2")

        }
        .onPreferenceChange(CustomPreferenceKey.self) { value in
            print(value)
        }
    }

    // MARK: overlayPreferenceValue
    var overlayPreferenceValue: some View {
        VStack {
            Text("View that sets a preference key when loaded")
                .preference(key: CustomPreferenceKey.self, value: "new value")

            Text("View that sets a preference key when loaded2")
                .preference(key: CustomPreferenceKey.self, value: "new value 2")

        }
        .overlayPreferenceValue(CustomPreferenceKey.self) { value in
            Text(value)
                .background(.purple)
        }
    }

    // MARK: backgroundPreferenceValue
    var backgroundPreferenceValue: some View {
        VStack {
            Text("View that sets a preference key when loaded")
                .preference(key: CustomPreferenceKey.self, value: "new value")

            Text("View that sets a preference key when loaded2")
                .preference(key: CustomPreferenceKey.self, value: "new value 2")

        }
        .backgroundPreferenceValue(CustomPreferenceKey.self) { value in
            Text(value)
                .background(.purple)
        }
    }

    // MARK: transform
    var transformPreference: some View {

        VStack {
            Text("View that sets a preference key when loaded")
                .transformPreference(CustomPreferenceKey.self) { value in
                    value += "append"
                }
                .background(.red)
                .offset(x: 0, y: -50)
        }
        .onPreferenceChange(CustomPreferenceKey.self) { value in
            print("onPreferenceChange::", value)
        }
    }

    // MARK: anchor preference
    var anchorGeo: some View {
        Text("I have a box 📦 around me")
            .anchorPreference(key: BoundsPreferenceKey.self, value: .bounds) { value in
                value
            }
            .overlayPreferenceValue(BoundsPreferenceKey.self) { preferences in
                
                GeometryReader { geometry in
                    preferences.map { anchor in
                        Rectangle()
                            .stroke()
                            .frame(
                                width: geometry[anchor].width,
                                height: geometry[anchor].height
                            )
                            .offset(x: geometry[anchor].minX, y: geometry[anchor].minY)
                    }
                }
            }

    }
}

struct PreferencePage_Previews: PreviewProvider {
    static var previews: some View {
        PreferencePage()
    }
}

//
//
struct CustomPreferenceKey: PreferenceKey {

    static var defaultValue: String = "defaultValue"

    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }

}

//
// ancor
struct BoundsPreferenceKey: PreferenceKey {

    static var defaultValue: Anchor<CGRect>?

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {

    }
}
