//
//  ContentView.swift
//  WidgetExample
//

import SwiftUI
import WidgetKit
import UIKit

// Define high and low resolution image strings
let lowResImageString = "lowResImage"
let highResImageString = "highResImage"

struct ContentView: View {
    // State to hold the current image name
    @AppStorage("currentImageName", store: UserDefaults(suiteName: "group.kiki.widgetExample")) var imageName: String = lowResImageString
    
    // State to store the image memory size
    @State private var imageSizeText: String = "Image memory size: Calculating..."
    
    // State to manage whether to use high or low resolution
    @State private var isHighResolution: Bool = false
    
    // App Group identifier
    let appGroupID = "group.kiki.widgetExample"
    
    var body: some View {
        VStack {
            Text(imageName)
            
            if let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 200)
                    .onAppear {
                        // Calculate the image memory size and update the Text
                        let imageSize = calculateImageMemorySize(image: image)
                        imageSizeText = String(format: "Image memory size: %.2f MB", imageSize)
                        
                        // Save image size to UserDefaults
                        if let userDefaults = UserDefaults(suiteName: appGroupID) {
                            userDefaults.set(imageSize, forKey: "currentImageSize")
                        }
                    }
            }
            
            // Display the image memory size
            Text(imageSizeText)
                .padding()
            
            // Switch Image Button
            Button(action: {
                // Generate a random number between 1 and 4
                let randomIndex = Int.random(in: 1...4)
                // Update the image name using the random number and current resolution
                let baseImageString = isHighResolution ? highResImageString : lowResImageString
                imageName = String(format: baseImageString + "%03d", randomIndex)
                
                // Save the current image name to UserDefaults in the App Group
                if let userDefaults = UserDefaults(suiteName: appGroupID) {
                    userDefaults.set(imageName, forKey: "currentImageName")
                }
                WidgetCenter.shared.reloadAllTimelines()
                
                if let newImage = UIImage(named: imageName) {
                    let imageSize = calculateImageMemorySize(image: newImage)
                    imageSizeText = String(format: "Image memory size: %.2f MB", imageSize)
                    
                    // Save image size to UserDefaults
                    if let userDefaults = UserDefaults(suiteName: appGroupID) {
                        userDefaults.set(imageSize, forKey: "currentImageSize")
                    }
                }
            }) {
                Text("Switch Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Toggle between high and low resolution images
                isHighResolution.toggle()
                
                // Change image name based on the resolution and always use "001" as the default suffix
                imageName = (isHighResolution ? highResImageString : lowResImageString) + "001"
                
                // Save the current image name to UserDefaults in the App Group
                if let userDefaults = UserDefaults(suiteName: appGroupID) {
                    userDefaults.set(imageName, forKey: "currentImageName")
                }
                
                WidgetCenter.shared.reloadAllTimelines()
                
                // Update the image size after toggling the resolution
                if let newImage = UIImage(named: imageName) {
                    let imageSize = calculateImageMemorySize(image: newImage)
                    
                    // Update the size text with the recalculated size
                    imageSizeText = String(format: "Image memory size: %.2f MB", imageSize)
                    
                    // Save the new image size to UserDefaults
                    if let userDefaults = UserDefaults(suiteName: appGroupID) {
                        userDefaults.set(imageSize, forKey: "currentImageSize")
                    }
                }
            }) {
                Text(isHighResolution ? "Switch to Low Resolution" : "Switch to High Resolution")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .padding()
    }
    
    // Calculate the memory size of the image and convert it to MB
    func calculateImageMemorySize(image: UIImage) -> Double {
        guard let cgImage = image.cgImage else {
            return 0
        }
        
        // Get the image width and height
        let width = cgImage.width
        let height = cgImage.height
        
        // Each pixel typically takes up 4 bytes (RGBA)
        let bytesPerPixel = 4
        
        // Calculate the total memory size in bytes
        let memorySizeInBytes = width * height * bytesPerPixel
        
        // Convert bytes to MB (1 MB = 1,048,576 bytes)
        let memorySizeInMB = Double(memorySizeInBytes) / 1_048_576
        return memorySizeInMB
    }
}

#Preview {
    ContentView()
}
