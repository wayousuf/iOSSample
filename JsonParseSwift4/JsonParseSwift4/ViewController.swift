//
//  ViewController.swift
//  JsonParseSwift4
//
//  Created by Waqas Yousuf on 5/1/18.
//  Copyright © 2018 Waqas Yousuf. All rights reserved.
//

import UIKit

//struct WebsiteDescription: Decodable {
//    let name: String
//    let description: String
//    let courses: [Course]
//}

struct Course : Decodable {
    let id: Int
    let name: String
    let link: String
    //let imageUrl: String
    
    let numberOfLessons: Int
    let imageUrl: String
    
    
    //Swift 4.0
//    private enum CodingKeys: String, CodingKey {
//       case imageUrl = "image_url"
//       case numberOfLessons = "number_of_lessons"
//       case id, name, link
//    }
    
//    init(json: [String: Any]) {
//        id = json["id"] as? Int ?? -1
//        name = json["name"] as? String ?? ""
//        link = json["link"] as? String ?? ""
//        imageUrl = json["imageUrl"] as? String ?? ""
//    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let jsonUrlString = "https://api.letsbuildthatapp.com/jsondecodable/course"
        
        guard let url = URL(string: jsonUrlString) else
            { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
//            let dataAsString = String(data: data, encoding: .utf8)
//
//            print(dataAsString)
            
            do {
                
                
//                let websiteDescription = try
//                    JSONDecoder().decode(WebsiteDescription.self, from: data)
//                print(websiteDescription.name, websiteDescription.description)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try
                    decoder.decode(Course.self, from: data)
                print(courses)
                
                
                //Swift 2/3/ObjC
//                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
//                let course = Course(json: json)
//
//                print(course.name)
            } catch let jsonErr {
                print(jsonErr)
            }
            
            
        }.resume()
        
//        let myCourse = Course(id: 1, name: "my course", link: "some link", iamgeUrl: "some image url")
//
//        print(myCourse)
    }
    
    
    
}

