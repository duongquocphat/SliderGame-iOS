//
//  Response.swift
//  SliderGame
//
//  Created by Shakutara on 10/22/19.
//  Copyright © 2019 Shakutara. All rights reserved.
//

import Foundation

struct PlayerResponse: Decodable {
    let player_name: String
    let player_point: Int
}
