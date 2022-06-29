//
//  AlamofireTutorial.swift
//  SwiftuiKnowledge
//
//  Created by ZhuChaoJun on 2022/6/16.
//

import SwiftUI
import Alamofire

struct SBase<Base> {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol SBaseCompatible: AnyObject {
    associatedtype Compatible

    var sc: SBase<Compatible> { get }
    static var sc: SBase<Compatible>.Type { get }
}

extension SBaseCompatible {

    var sc: SBase<Self> {
        return SBase(self)
    }

    static var sc: SBase<Self>.Type {
        return SBase.self
    }
}



//
//
struct AlamofireTutorial: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)

    }

    func tst() {

    }
}

struct AlamofireTutorial_Previews: PreviewProvider {
    static var previews: some View {
        AlamofireTutorial()
    }
}


