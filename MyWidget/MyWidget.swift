import WidgetKit
import SwiftUI

struct Person : Identifiable,Codable{
    
    let id : UUID
    let name: String
    let age: Int
    
    init(n : String, a: Int){
        id = UUID()
        name = n
        age = a
    }
}



struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),name: "InitName", age: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),name: "InitName", age: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // fetch data
        /* Reading the encoded data from your shared App Group container storage */
       let encodedData  = UserDefaults(suiteName: "group.me.CustomLockScreenWidget")!.object(forKey: "person") as? Data
        
        var p = Person(n: "NAME", a: 0)
        
        /* Decoding it using JSONDecoder*/
       if let personEncoded = encodedData {
            
         
        let personDecoded = try? JSONDecoder().decode(Person.self, from: personEncoded)
            
        if let person = personDecoded{
                // You successfully retrieved your car object!
            
                p = person
            
            }
        }
        
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            
            
            let entry = SimpleEntry(date: entryDate,
                                    name: p.name,
                                    age: p.age)
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var name : String
    var age : Int
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    

    @ViewBuilder
    var body: some View {
	
        switch family {
        case .systemSmall:
            ViewForSystemSmall(entry: entry)
        case .systemMedium:
            ViewForSystemMedium(entry: entry)
        case .systemLarge:
            ViewForSystemLarge(entry: entry)
        case .systemExtraLarge:
            ViewForSystemLarge(entry: entry)
    
        //case .accessoryRectangular:
            //ViewForSystemSmall(entry: entry)
       
        @unknown default:
            fatalError()
        }
    }
}

struct ViewForSystemSmall: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Person").foregroundColor(.white)
            Text(entry.name).foregroundColor(.white)
        }.padding()
    }
}

struct ViewForSystemMedium: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Person").foregroundColor(.white)
            Text(entry.name).foregroundColor(.white)
            Text(String(entry.age)).foregroundColor(.white)
        }.padding()
    }
}

struct ViewForSystemLarge: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Person").foregroundColor(.white)
            Text(entry.name).foregroundColor(.white)
            Text(String(entry.age)).foregroundColor(.white)
        }.padding()
    }
}

@main
struct MyWidget: Widget {

//    private let supportedFamilies:[WidgetFamily] = {
//            if #available(iOSApplicationExtension 15.0, *) {
//                return [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
//            } else {
//                return [.systemSmall, .systemMedium, .systemLarge]
//            }
//        }()
    
    
    let kind: String = "Static_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
            
            
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
}
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(),name: "InitName", age: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
