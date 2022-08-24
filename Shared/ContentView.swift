//
//  ContentView.swift
//  Shared
//
//  Created by clever zone on 22/8/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    var data : [Person] = Person.sampleData
    
    func onClickItem(p : Person){
        
        print(p.name)
        
        /* Since it's Codable, we can convert it to JSON using JSONEncoder */
        let personData = try! JSONEncoder().encode(p)
        
        /* ...and store it in your shared UserDefaults container */
        UserDefaults(suiteName: "group.me.CustomLockScreenWidget")!.set(personData, forKey: "person")
        
        WidgetCenter.shared.reloadAllTimelines()
        
    }
    
    var body: some View {
        List{
            Section(header: Text("Persons")) {
                
                ForEach(data) { d in
                    Button(action: { onClickItem(p: d) } ){
                        
                        Label( "Name : \(d.name), Age: \(d.age)", systemImage: "person")
                    }
                                }
                
                        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
