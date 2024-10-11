////
////  File.swift
////  imageWidgetExtension
////
////
//
//import WidgetKit
//import SwiftUI
//
//class MemoryHog {
//    var data: [Int]
//    
//    init(size: Int) {
//        // Allocate a large array to simulate memory exhaustion
//        data = Array(repeating: 0, count: size)
//    }
//}
//
//struct MemoryCrashWidgetEntry: TimelineEntry {
//    let date: Date
//}
//
//struct MemoryCrashWidgetProvider: TimelineProvider {
//    func placeholder(in context: Context) -> MemoryCrashWidgetEntry {
//        MemoryCrashWidgetEntry(date: Date())
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (MemoryCrashWidgetEntry) -> Void) {
//        completion(MemoryCrashWidgetEntry(date: Date()))
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<MemoryCrashWidgetEntry>) -> Void) {
//        var entries: [MemoryCrashWidgetEntry] = []
//        let currentDate = Date()
//
//        // Generate multiple timeline entries, each for one minute
//        for minuteOffset in 0..<5 {
//            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
//            let entry = MemoryCrashWidgetEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        // Create the timeline
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct MemoryCrashWidgetEntryView: View {
//    var entry: MemoryCrashWidgetProvider.Entry
//    @State private var memoryObjects = [MemoryHog]() // Store the memory-consuming objects
//    @State private var logMessage = "Starting memory test..."
//
//    var body: some View {
//        VStack {
//            Text("Memory Crash Test")
//                .font(.headline)
//            
//            Text(logMessage)
//                .font(.footnote)
//                .padding()
//
//            // Timer to continuously allocate memory and print log
//            .onAppear {
//                startMemoryTest()
//            }
//        }
//    }
//
//    // Continuously allocate memory until the widget crashes
//    func startMemoryTest() {
//        // Use a timer to loop, allocate memory, and print logs
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            for _ in 0..<100 {
//                let hog = MemoryHog(size: 100_000) // Allocate 100,000 integers each time
//                memoryObjects.append(hog)
//            }
//            
//            // Update log with the number of allocated memory objects
//            logMessage = "Allocated memory objects: \(memoryObjects.count)"
//            print(logMessage)
//            
//            // If memory objects exceed 10,000, stop and expect a crash
//            if memoryObjects.count > 10_000 {
//                logMessage = "Crash imminent..."
//                print(logMessage)
//                timer.invalidate() // Stop the timer, waiting for the system to crash
//            }
//        }
//    }
//}
//
//@main
//struct MemoryCrashWidget: Widget {
//    let kind: String = "MemoryCrashWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: MemoryCrashWidgetProvider()) { entry in
//            if #available(iOS 17.0, *) {
//                MemoryCrashWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                MemoryCrashWidgetEntryView(entry: entry)
//            }
//        }
//        .configurationDisplayName("Memory Crash Widget")
//        .description("This widget demonstrates how to force a memory crash.")
//        .supportedFamilies([.systemSmall]) // 小尺寸的 Widget
//    }
//}
//
