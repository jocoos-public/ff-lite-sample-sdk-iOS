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
    func receiveMessage(message: FFLMessage)
}

class WatchPlayView: UIView {
    
    private var player: FFLLivePlayer?
    
    var delegate: WatchPlayViewDelegate?
    
    init(frame: CGRect, accessToken: String, videoRoomId: UInt64, channelId: UInt64, targetUrl: String) {
        super.init(frame: frame)
        
        player = FlipFlopLite.getLivePlayer(accessToken: accessToken, videoRoomId: videoRoomId, channelId: channelId)
        player?.delegate = self
        player?.prepare(view: self, uri: targetUrl)
        player?.enter()
    }
    
    func sendMessage(text: String) {
        player?.liveChat()?.sendMessage(message: text)
    }
    
    func closeAction() {
        player?.stop()
        player?.exit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchPlayView: FFLLivePlayerDelegate {
    func fflLivePlayer(_ livePlayer: FlipFlopLiteSDK.FFLLivePlayer, didUpdate playerState: FlipFlopLiteSDK.PlayerState) {
        print("LivePlayer: didUpdatePlayer - \(playerState)")
        
        DispatchQueue.main.async {
            switch playerState {
            case .prepared:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.player?.start()
                }
            case .started:
                break
            case .paused:
                break
            case .stopped:
                break
            case .completed:
                break
            case .closed:
                break
            default:
                break
            }
        }
    }
    
    func fflLivePlayer(_ livePlayer: FlipFlopLiteSDK.FFLLivePlayer, didUpdate broadcastState: FlipFlopLiteSDK.BroadcastState) {
        print("LivePlayer: didUpdateBroadcast - \(broadcastState)")
        
        DispatchQueue.main.async {
            switch broadcastState {
            case .active:
                // streaming is progressing
                break
            case .inactive:
                // streaming has been stopped
                break
            default:
                break
            }
        }
    }
    
    func fflLivePlayer(_ livePlayer: FlipFlopLiteSDK.FFLLivePlayer, didReceive message: FlipFlopLiteSDK.FFLMessage) {
        print("LivePlayer: didReceive - \(message.message)")
        DispatchQueue.main.async {
            self.delegate?.receiveMessage(message: message)
        }
    }
    
    func fflLivePlayer(_ livePlayer: FlipFlopLiteSDK.FFLLivePlayer, didFail error: FlipFlopLiteSDK.FFError) {
        print("LivePlayer: didFail - \(error.code) / \(error.message)")
    }
}
