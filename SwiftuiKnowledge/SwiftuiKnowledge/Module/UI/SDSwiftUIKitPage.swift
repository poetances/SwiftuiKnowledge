//
//  SDSwiftUIKit.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/23.
//

import SwiftUI

struct SDSwiftUIKitPage: View {

    var body: some View {
        NavigationView {
            VStack {

                NavigationLink("TextTutorial") {
                    TextTutorial()
                }.padding(.bottom)

                NavigationLink("ButtonTutorial") {
                    ButtonTutorial()
                }.padding(.bottom)

                NavigationLink("TextFieldTutorial") {
                    TextFieldTutorial()
                }.padding(.bottom)

                NavigationLink("ImageTutorial") {
                    ImageTutorial()
                }.padding(.bottom)

                NavigationLink("ScrollViewTutorial") {
                    ScrollViewTutorial()
                }.padding(.bottom)

                NavigationLink("GroupTutorial") {
                    GroupTutorial()
                }.padding(.bottom)

                NavigationLink("FormTutorial") {
                    FormTutorial()
                }.padding(.bottom)

                NavigationLink("ListTutorial") {
                    ListTutorial()
                }.padding(.bottom)

                NavigationLink("ModifierTutorial") {
                    ModifierTutorial()
                }.padding(.bottom)
            }
            .background(.clear)
            .navigationTitle("SDSwiftUIKitPage")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("action1") {
                        print("action1 click")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("action2") {
                        print("action2 click")
                    }
                }
            }
        }
    }
}

struct SDSwiftUIKitPage_Previews: PreviewProvider {
    static var previews: some View {
        SDSwiftUIKitPage()
    }
}
