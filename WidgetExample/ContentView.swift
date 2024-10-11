//
//  ContentView.swift
//  WidgetExample
//
//  Created by 王昱淇 on 2024/10/11.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    // State to hold the current image name
    @AppStorage("currentImageName", store: UserDefaults(suiteName: "group.kiki.widgetExample")) var imageName: String = "baron001"

    // App Group identifier
    let appGroupID = "group.kiki.widgetExample"
    
    var body: some View {
        VStack {
            Text(imageName)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 200)
                .imageScale(.large)
                .foregroundStyle(.tint)
                        
            Button(action: {
                // Generate a random number between 1 and 20
                let randomIndex = Int.random(in: 1...20)
                // Update the image name using the random number
                imageName = String(format: "baron%03d", randomIndex)
                
                // Save the current image name to UserDefaults in the App Group
                if let userDefaults = UserDefaults(suiteName: appGroupID) {
                    userDefaults.set(imageName, forKey: "currentImageName")
                }
                WidgetCenter.shared.reloadAllTimelines()
            }) {
                Text("Show Random Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
