//
//  SDOtherPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/23.
//

import SwiftUI

struct SDKnowledgePage: View {
    @State private var isActive = false


    var body: some View {
        NavigationView {

            ScrollView {
                Group {
                    NavigationLink("SDPushPage", isActive: $isActive) {
                        PushPage(showSelf: $isActive)
                    }.padding()

                    NavigationLink("StatePage") {
                        StatePage()
                    }.padding(.bottom)

                    NavigationLink {
                        BindingPage()
                    } label: {
                        Text("BindingPage")
                            .foregroundColor(.purple)
                    }.padding(.bottom)

                    NavigationLink("ObservedObjectPage") {
                        ObservedObjectPage()
                    }.padding(.bottom)

                    NavigationLink("EnvironmentObjectPage") {
                        EnvironmentObjectPage()
                    }.padding(.bottom)

                    NavigationLink("EnvironmentPage") {
                        EnvironmentPage()
                    }.padding(.bottom)

                    NavigationLink("StateObjectPage") {
                        StateObjectPage()
                    }.padding(.bottom)

                    NavigationLink("AppStorePage") {
                        AppStorePage()
                    }.padding(.bottom)

                    NavigationLink("ViewBuilderPage") {
                        ViewBuilderPage()
                    }.padding(.bottom)


                    NavigationLink("TaskPage") {
                        TaskPage()
                    }.padding(.bottom)
                }

                Group {
                    NavigationLink("PreferencePage") {
                        PreferencePage()
                    }.padding(.bottom)

                    NavigationLink("GeometryReaderPage") {
                        GeometryReaderPage()
                    }.padding(.bottom)

                    NavigationLink("PropertyWrapperPage") {
                        PropertyWrapperPage()
                    }.padding(.bottom)
                }



            }
        }
    }
}

struct SDKnowledgePage_Previews: PreviewProvider {
    static var previews: some View {
        SDKnowledgePage()
    }
}
