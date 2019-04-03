//
//  Travel.swift
//  TravelApp
//
//  Created by German Hernandez on 03/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import Foundation

struct Travel {
    
    var id: String
    var title: String
    var description: String
    var picture: String
    var owner: String
    
    init(id: String = "", title: String = "", description: String = "", picture: String = "", owner: String = "") {
        self.id = id
        self.title = title
        self.description = description
        self.picture = picture
        self.owner = owner
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        title = data["title"] as? String ?? ""
        description = data["description"] as? String ?? ""
        picture = data["picture"] as? String ?? ""
        owner = data["owner"] as? String ?? ""
    }
    
    static func modelToData(travel: Travel) -> [String: Any] {
        let data : [String: Any] = [
            "id": travel.id,
            "title": travel.title,
            "description": travel.description,
            "picture": travel.picture,
            "owner": travel.owner
        ]
        
        return data
    }
    
}
