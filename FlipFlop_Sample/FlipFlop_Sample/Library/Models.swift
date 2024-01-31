//
//  Models.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit

struct TokenRequest: Codable {
    let appUserId: String
    let appUserName: String
    let appUserProfileImgUrl: String?
}

struct Token: Codable {
    let accessToken: String
    let streamingToken: String
}

struct VideoRooms: Codable {
    let content: [VideoRoom]
}

struct VideoRoom: Codable {
    let id: UInt64
    let type: String
    let `protocol`: String
    let videoRoomState: String
    let vodState: String
    let liveUrl: String?
    let vodUrl: String?
    let title: String
    let liveStartedAt: String?
    let liveEndedAt: String?
    let channel: Channel?
    let rtmpPlayUrl: String?
    let httpFlvPlayUrl: String?
}

struct Channel: Codable {
    let id: UInt64
}

struct LoginUserResModel: Codable {
    let username, email, createdAt, updatedAt: String
    let id: String
}
