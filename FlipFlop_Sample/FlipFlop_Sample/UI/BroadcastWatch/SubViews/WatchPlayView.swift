//
//  WatchPlayView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

protocol WatchPlayViewDelegate {
    func receiveMessage(message: FFMessage)
}

class WatchPlayView: UIView {
    
    private var player: FFLLivePlayer?
    
    var delegate: WatchPlayViewDelegate?
    
    init(frame: CGRect, appID: String, userID: String, userName: String, token: String, key: String, targetUrl: String) {
        super.init(frame: frame)
        
        player = FlipFlopLite.getLivePlayer(appId: appID,
                                            user: FFLite.User(userId: userID, username: userName),
                                            gossipToken: token,
                                            channelKey: key)
        player?.delegate = self
        player?.enter()
        player?.prepare(view: self, uri: targetUrl)
    }
    
    func sendMessage(text: String) {
        player?.liveChat()?.sendMessage(text: text, data: "MEMBER")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchPlayView: FFLLivePlayerDelegate {
    func onFailedToPlay() {
        
    }
    
    func onPrepared() {
        player?.start()
    }
    
    func onStarted() {
        
    }
    
    func onPaused() {
        
    }
    
    func onStopped() {
        
    }
    
    func onCompleted() {
        
    }
    
    func onProgressUpdated(sec: Float64) {
        
    }
    
    func onError(error: FlipFlopLiteSDK.FFError) {
        
    }
    
    func onChatMessageReceived(message: FlipFlopLiteSDK.FFMessage) {
        print("message = ", message.description)
        
        if message.type == "COMMAND" {
            if let customType = message.customType {
                switch customType {
                case "MANAGER_OUT":
                    //채팅 관리자 퇴장
                    break
                case "FORCE_END":
                    //강제 종료
                    break
                case "FORCE_CANCEL":
                    //강제 취소
                    break
                case "MANAGER":
                    //채팅 매니저 설정
                    break
                case "NO_MANAGER":
                    //채팅 매니저 설정 해제
                    break
                case "EXILE":
                    //추방
                    break
                case "NO_VIEWER_CHAT":
                    //시청자 채팅 정지
                    break
                case "VIEWER_CHAT":
                    //시청자 채팅 정지 해제
                    break
                case "STREAM_KEY_STATUS_CHANGED":
                    //스트림키 상태 변경
                    break
                case "PIN":
                    //핀 메세지 설정
                    break
                case "NO_PIN":
                    //핀 메세지 해제
                    break
                case "UPDATE_BROADCAST":
                    //라이브 정보 변경
                    break
                case "NO_CHAT":
                    //채팅창 전체 정지
                    break
                case "CHAT":
                    //채팅창 전체 정지 해제
                    break
                case "UPDATE_STATUS":
                    //라이브 상태 변경
                    break
                case "VISIBLE_MESSAGE":
                    //메세지 활성화
                    break
                case "INVISIBLE_MESSAGE":
                    //메세지 비 활성화
                    break
                case "HEART_COUNT":
                    //좋아요 수 변경
                    break
                case "URL_CHANGED":
                    //방송 URL 변경
                    break
                default:
                    break
                }
            }
        } else if message.type == "JOIN" {
            delegate?.receiveMessage(message: message)
        } else if message.type == "LEAVE" {
        } else if message.type == "ADMIN" {
            
        } else {
            delegate?.receiveMessage(message: message)
        }
    }
    
    func onBackground() {
        
    }
    
    func onForeground() {
        
    }
}
