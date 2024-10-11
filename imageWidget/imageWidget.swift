//
//  imageWidget.swift
//  imageWidget
//
//  Created by 王昱淇 on 2024/10/11.
//

import WidgetKit
import SwiftUI
 
// MARK: - TimelineProvider

struct Provider: TimelineProvider {
    let appGroupID = "group.kiki.widgetExample"  

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageName: "baron001")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // 加載 App Group 中的圖片名稱
        let imageName = loadImageNameFromAppGroup() ?? "baron001"
        let entry = SimpleEntry(date: Date(), imageName: imageName)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // 獲取當前時間
        let currentDate = Date()

        // 從 App Group 加載圖片名稱
        let imageName = loadImageNameFromAppGroup() ?? "baron001"

        // 生成一個時間線，其中每小時顯示一次圖片
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, imageName: imageName)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    // 從 App Group UserDefaults 加載圖片名稱
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
    
    // 使用 @AppStorage 從 App Group 讀取圖片名稱
    @AppStorage("currentImageName", store: UserDefaults(suiteName: "group.kiki.widgetExample")) var imageName: String = "baron001"  
    
    var body: some View {
        VStack {
            // 顯示從 App Group 中讀取的圖片
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 360, height: 160)
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
        .description("This widget shows an image from App Group.")
    }
}

#Preview(as: .systemSmall) {
    imageWidget()
} timeline: {
    SimpleEntry(date: .now, imageName: "baron001")
}
