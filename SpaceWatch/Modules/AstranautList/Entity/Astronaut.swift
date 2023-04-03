//
//  Astronaut.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation

struct Astronaut: Decodable {
    let id: Int
    let name: String
    let nationality: String
    let profileImageThumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nationality
        case profileImageThumbnail = "profile_image_thumbnail"
    }
}
    


struct AstronautsResponse: Decodable {
    let astronauts: [Astronaut]
    enum CodingKeys: String, CodingKey {
        case astronauts = "results"
    }
}



