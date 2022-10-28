//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by mac on 28/10/22.
//

import Foundation

struct YouTubeSearchResponse:Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
