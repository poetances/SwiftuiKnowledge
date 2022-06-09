//
//  ListTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/24.
//

import SwiftUI

class ListTutorialViewModel: ObservableObject {

    @Published var cellModels = [ListCellModel]()

    init() {
        (0 ..< 20).forEach { index in
            let cellModel = ListCellModel(index: 10)
            cellModels.append(cellModel)
        }
    }
}

class ListCellModel: ObservableObject, Identifiable {
    let id = UUID()

    var index = 0
    @Published var isFavorite = false

    init(index: Int) {
        self.index = index
    }
}


struct ListTutorial: View {

    @ObservedObject var vm = ListTutorialViewModel()

    @State var isFavorite = false

    var body: some View {
        // List1()
        // List2()
        // List3()
        // List4()

        List(vm.cellModels) { cm in
            ListCellTutorial(cellModel: cm)
        }
    }
}


struct ListCellTutorial: View {

    @StateObject var cellModel: ListCellModel
    var body: some View {
        HStack {
            Text("\(cellModel.index)")
            Spacer()
            Image(systemName: cellModel.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(cellModel.isFavorite ? .red : .gray)
                .frame(width: 20, height: 30)

        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("on Tap gesture")
            cellModel.isFavorite = !cellModel.isFavorite
        }
    }
}

struct ListTutorial_Previews: PreviewProvider {
    static var previews: some View {
        ListTutorial()
    }
}

struct List1: View {

    var body: some View {
        List {
            Text("hello")
            Text("world")
        }
    }
}

struct List2: View {

    var body: some View {

        List (0..<100) { i in
            Text("Id:\(i)")
        }
    }
}


struct List3: View {

    @State var selection:Int? = nil
    var body: some View {

        let citys = ["北京", "上海", "深圳"]
        return  List (0..<citys.count,selection: $selection ){ i in
            Text(citys[i]).tag(i)
        }
    }
}

struct List4: View {

    var body: some View {
        List{

            ForEach(0..<10,id:\.self){ index in

                Text("row::\(index)")

            }
        }
    }
}
