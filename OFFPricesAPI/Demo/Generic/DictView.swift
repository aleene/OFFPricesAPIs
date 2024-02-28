//
//  FSNMDictView.swift
//  OFFFolksonomy
//
//  Created by Arnaud Leene on 22/10/2022.
//

import SwiftUI

struct DictView: View {

    // These variables will only be set from outside
    // They are decoupled from datatypes
    // The stored properties/initializers model is used
    public var dict: [String: String]
    
    internal var body: some View {
        Section() {
            ForEach(dict.sorted(by: >), id:\.key) {
                DictElementView(dict: [$0.key:$0.value])
            }
        }
    }
}

struct DictView_Previews: PreviewProvider {
    
    static var previews: some View {
        DictView(dict: ["test":"test"])
    }
}
