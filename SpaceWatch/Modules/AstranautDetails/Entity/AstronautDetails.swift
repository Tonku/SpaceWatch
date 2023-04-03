//
//  AstronautDetails.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation

struct AstronautDetails: Decodable {
    let name: String
    let nationality: String
    let profileImage: String
    let bio: String
    let dateOfBirth: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case nationality
        case profileImage = "profile_image"
        case bio
        case dateOfBirth = "date_of_birth"
    }
}
