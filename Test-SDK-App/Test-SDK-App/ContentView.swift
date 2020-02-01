//
//  ContentView.swift
//  Test-SDK-App
//
//  Created by Raymond Andrie on 1/31/20.
//  Copyright © 2020 Cotter. All rights reserved.
//

import SwiftUI
import CotterSDK

let testStr = Test.string()

struct ContentView: View {
    var body: some View {
        Text(testStr)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
