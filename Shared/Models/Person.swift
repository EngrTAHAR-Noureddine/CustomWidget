import Foundation

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

extension Person {
    
    static let sampleData: [Person] = [
    
        Person(n: "Abdelkader", a: 34),
        Person(n: "Samir", a: 90),
        Person(n: "Rachid", a: 78),
        
    ]
    
}
