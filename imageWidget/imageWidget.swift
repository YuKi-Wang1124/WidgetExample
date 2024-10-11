//
//  imageWidget.swift
//  imageWidget
//

import WidgetKit
import SwiftUI

// MARK: - TimelineProvider

struct Provider: TimelineProvider {
    let appGroupID = "group.kiki.widgetExample"
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageName: imageString + "001")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // Load the image name from App Group
        let imageName = loadImageNameFromAppGroup() ?? imageString + "001"
        let entry = SimpleEntry(date: Date(), imageName: imageName)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Get the current date
        let currentDate = Date()
        
        // Load the image name from App Group
        let imageName = loadImageNameFromAppGroup() ?? imageString + "001"
        
        // Generate a timeline showing the image every hour
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, imageName: imageName)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    // Load the image name from App Group UserDefaults
    func loadImageNameFromAppGroup() -> String? {
        let userDefaults = UserDefaults(suiteName: appGroupID)
        return userDefaults?.string(forKey: "currentImageName")
    }
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageName: String
}

// MARK: - imageWidgetEntryView

struct imageWidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    // Use @AppStorage to read the image name from App Group
    @AppStorage("currentImageName", store: UserDefaults(suiteName: "group.kiki.widgetExample")) var imageName: String = imageString + "001"
    @AppStorage("currentImageSize", store: UserDefaults(suiteName: "group.kiki.widgetExample")) var currentImageSize: Double = 0.0
    
    var body: some View {
        if widgetFamily == .systemSmall {
            // Small Widget showing image name and size
            VStack {
                Text("Image Name:")
                Text(imageName)
                Text("Image Size:")
                Text(String(format: "%.2f MB", currentImageSize))
            }
            .font(.system(size: 14))
        } else {
            // Large Widget showing the image
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 190)
        }
    }
}


// MARK: - imageWidget

struct imageWidget: Widget {
    let kind: String = "imageWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                imageWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                imageWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This widget shows an image or image name from App Group.")
    }
}

#Preview(as: .systemSmall) {
    imageWidget()
} timeline: {
    SimpleEntry(date: .now, imageName: imageString + "001")
}
