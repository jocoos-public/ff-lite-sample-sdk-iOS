//
//  Models.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit

//MARK: User 등록 response
struct LoginUserResModel: Codable {
    let username, email, createdAt, updatedAt: String
    let id: String
}

//MARK: 에러 response
struct ErrorModel: Codable {
    let statusCode: Int
    let message: String
}

//MARK: 토큰 response
struct TokenResModel: Codable {
    let accessToken: String
    let fflTokens: FFLTokensModel
    
    enum CodingKeys: String, CodingKey {
    case accessToken
        case fflTokens = "fflTokens"
    }
}

struct FFLTokensModel: Codable {
    let accessToken, refreshToken, streamingToken: String
    let member: MemberModel
}

struct MemberModel: Codable {
    let state: String
    let createdAt: String?
    let createdBy: String?
    let lastModifiedAt: String?
    let lastModifiedBy: String?
    let id: Int
    let appID: Int?
    let customType: String?
    let appUserID, appUserName: String
    let appUserProfileImgURL: String?

    enum CodingKeys: String, CodingKey {
        case state, createdAt, createdBy, lastModifiedAt, lastModifiedBy, id
        case appID = "appId"
        case customType
        case appUserID = "appUserId"
        case appUserName
        case appUserProfileImgURL = "appUserProfileImgUrl"
    }
}

struct BroadCastListResModel: Codable {
    let content: [BroadcastListContent]
    let pageable: Pageable
    let last: Bool
    let totalPages, totalElements, size, number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

struct BroadcastListContent: Codable {
    let id: Int
    let state: State
    let videoRoomState: VideoRoomState?
    let vodState: VODState?
    let vodURL: String?
    let type: TypeEnum?
    let format: Format?
    let accessLevel: AccessLevel?
    let app: App
    let member: MemberModel?
    let creatorType: AccessLevel?
    let creatorID: Int?
    let title: String?
    let description: String?
    let scheduledAt: String?
    let cancelledAt, liveStartedAt, liveEndedAt, vodArchivedAt: String?
    let streamKey: StreamKeyModel?
    let videoPost: VideoPost?
    let liveURL: String?
    let chat: ChatModel?
    let stats: Stats?
    let customData: String?
    let createdAt, lastModifiedAt: String?
    let createdBy: String?
    let lastModifiedBy: LastModifyModel?

    enum CodingKeys: String, CodingKey {
        case id, state, videoRoomState, vodState
        case vodURL = "vodUrl"
        case type, format, accessLevel, app, member, creatorType
        case creatorID = "creatorId"
        case title, description, scheduledAt, cancelledAt, liveStartedAt, liveEndedAt, vodArchivedAt, streamKey, videoPost
        case liveURL = "liveUrl"
        case chat, stats, customData, createdAt, lastModifiedAt, createdBy, lastModifiedBy
    }
}

// MARK: - LastModifyModel
struct LastModifyModel: Codable {
    let id: Int
    let state, username, email: String
}

struct BroadcastContent: Codable {
    let id: Int
    let state: State
    let videoRoomState: VideoRoomState?
    let vodState: VODState?
    let vodURL: String?
    let type: TypeEnum?
    let format: Format?
    let accessLevel: AccessLevel?
    let app: App?
    let member: MemberModel?
    let creatorType: AccessLevel?
    let creatorID: Int?
    let title: String?
    let description: String?
    let scheduledAt: String?
    let cancelledAt, liveStartedAt, liveEndedAt, vodArchivedAt: String?
    let streamKey: String?
    let videoPost: VideoPost?
    let liveURL: String?
    let chat: ChatModel?
    let stats: Stats?
    let customData: String?
    let createdAt, lastModifiedAt: String?
    let createdBy, lastModifiedBy: String?

    enum CodingKeys: String, CodingKey {
        case id, state, videoRoomState, vodState
        case vodURL = "vodUrl"
        case type, format, accessLevel, app, member, creatorType
        case creatorID = "creatorId"
        case title, description, scheduledAt, cancelledAt, liveStartedAt, liveEndedAt, vodArchivedAt, streamKey, videoPost
        case liveURL = "liveUrl"
        case chat, stats, customData, createdAt, lastModifiedAt, createdBy, lastModifiedBy
    }
    
    init(listContent: BroadcastListContent) {
        id = listContent.id
        state = listContent.state
        videoRoomState = listContent.videoRoomState
        vodState = listContent.vodState
        vodURL = listContent.vodURL
        type = listContent.type
        format = listContent.format
        accessLevel = listContent.accessLevel
        app = listContent.app
        member = listContent.member
        creatorType = listContent.creatorType
        creatorID = listContent.creatorID
        title = listContent.title
        description = listContent.description
        scheduledAt = listContent.scheduledAt
        liveStartedAt = listContent.liveStartedAt
        liveEndedAt = listContent.liveEndedAt
        vodArchivedAt = listContent.vodArchivedAt
        streamKey = nil
        videoPost = listContent.videoPost
        liveURL = listContent.liveURL
        chat = listContent.chat
        stats = listContent.stats
        customData = listContent.customData
        createdAt = listContent.createdAt
        lastModifiedAt = listContent.lastModifiedAt
        createdBy = listContent.createdBy
        lastModifiedBy = nil
        cancelledAt = listContent.cancelledAt
    }
}

struct StreamKeyModel: Codable {
    let id: Int
    let state, streamKeyState: String
}

enum AccessLevel: String, Codable {
    case accessLevelPUBLIC = "PUBLIC"
    case app = "APP"
}

// MARK: - App
struct App: Codable {
    let id: Int
    let state: State
    let name: String
}

enum State: String, Codable {
    case active = "ACTIVE"
}

// MARK: - Chat
struct ChatModel: Codable {
    let videoKey, channelKey: String
    let createdAt, closedAt: String?
    let created, closed: Bool
}

enum Format: String, Codable {
    case cmaf = "CMAF"
}

struct Stats: Codable {
    let totalMemberWhitelistCount: Int
}

enum TypeEnum: String, Codable {
    case broadcastRtmp = "BROADCAST_RTMP"
}

// MARK: - VideoPost
struct VideoPost: Codable {
    let id: Int
    let state: State
    let videoPostState, type, title: String
}

enum VideoRoomState: String, Codable {
    case cancelled = "CANCELLED"
    case ended = "ENDED"
    case scheduled = "SCHEDULED"
    case liveInactive = "LIVE_INACTIVE"
    case live = "LIVE"
}

enum VODState: String, Codable {
    case archived = "ARCHIVED"
    case notArchived = "NOT_ARCHIVED"
    case archiving = "ARCHIVING"
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}

// MARK: - ChatTokenResModel
struct ChatTokenResModel: Codable {
    let chatServerWebSocketURL, chatToken, appID, userID: String
    let userName: String
    let avatarProfileURL: String?

    enum CodingKeys: String, CodingKey {
        case chatServerWebSocketURL = "chatServerWebSocketUrl"
        case chatToken
        case appID = "appId"
        case userID = "userId"
        case userName
        case avatarProfileURL = "avatarProfileUrl"
    }
}

struct GetStreamKeyResModel: Codable {
    let content: [BroadcastContent]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - GetVideoRoomDetailResModel
struct GetVideoRoomDetailResModel: Codable {
    let content: [BroadcastContent]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - PostVideoRoomResModel
struct PostVideoRoomResModel: Codable {
    let id: Int
    let state, videoRoomState, vodState: String
    let vodURL: String?
    let type, format, accessLevel: String
    let app: App
    let member: MemberModel
    let creatorType: String
    let creatorID: Int
    let title, description: String
    let scheduledAt: String
    let cancelledAt, liveStartedAt, liveEndedAt, vodArchivedAt: String?
    let streamKey, videoPost, liveURL: String?
    let chat: ChatModel
    let stats: Stats
    let customData: String?
    let createdAt, lastModifiedAt: String
    let createdBy, lastModifiedBy: String?

    enum CodingKeys: String, CodingKey {
        case id, state, videoRoomState, vodState
        case vodURL = "vodUrl"
        case type, format, accessLevel, app, member, creatorType
        case creatorID = "creatorId"
        case title, description, scheduledAt, cancelledAt, liveStartedAt, liveEndedAt, vodArchivedAt, streamKey, videoPost
        case liveURL = "liveUrl"
        case chat, stats, customData, createdAt, lastModifiedAt, createdBy, lastModifiedBy
    }
}

// MARK: - VideoRoomDetailModel
struct VideoRoomDetailModel: Codable {
    let chatServerWebSocketURL, chatToken, appID, userID: String
    let userName: String
    let avatarProfileURL: String?

    enum CodingKeys: String, CodingKey {
        case chatServerWebSocketURL = "chatServerWebSocketUrl"
        case chatToken
        case appID = "appId"
        case userID = "userId"
        case userName
        case avatarProfileURL = "avatarProfileUrl"
    }
}
