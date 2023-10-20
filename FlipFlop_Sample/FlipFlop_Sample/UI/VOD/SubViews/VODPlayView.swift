//
//  VODPlayView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

class VODPlayView: UIView {
    
    var player: FFLVodPlayer?
    
    init(frame: CGRect, accessToken: String, channelId: UInt64, liveStartedAt: String, targetUrl: String) {
        super.init(frame: frame)
        
        player = FlipFlopLite.getVodPlayer(accessToken: accessToken, channelId: channelId, liveStartedAt: liveStartedAt)
        player?.delegate = self
        player?.prepare(view: self, uri: targetUrl)
        player?.start()
    }
    
    func stopAction(isStop: Bool) {
        if isStop {
            player?.pause()
        } else {
            player?.resume()
        }
    }
    
    func closeAction() {
        player?.stop()
        player?.exit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VODPlayView: FFLVodPlayerDelegate {
    func fflVodPlayer(_ vodPlayer: FFLVodPlayer, didUpdate playerState: PlayerState) {
        print("[VODPlayer] didUpdatePlayerState: \(playerState)")
        
        DispatchQueue.main.async {
            switch playerState {
            case .prepared:
                break
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
    
    func fflVodPlayer(_ vodPlayer: FFLVodPlayer, didUpdateProgress seconds: Float64) {
        print("[VODPlayer] didUpdateProgress: \(seconds)")
    }
    
    func fflVodPlayer(_ vodPlayer: FFLVodPlayer, didReceive message: FFLMessage) {
        print("[VODPlayer] didReceiveMessage: \(message.message)")
    }
    
    func fflVodPlayer(_ vodPlayer: FFLVodPlayer, didFail error: FFError) {
        print("[VODPlayer] didFail: \(error.code) / \(error.message)")
    }
}

//extension VODPlayView: FFLVodPlayerDelegate {
//    func onFailedToPlay() {
//
//    }
//
//    func onPrepared() {
//        player?.start()
//    }
//
//    func onStarted() {
//
//    }
//
//    func onPaused() {
//
//    }
//
//    func onStopped() {
//
//    }
//
//    func onCompleted() {
//
//    }
//
//    func onProgressUpdated(sec: Float64) {
//
//    }
//
//    func onError(error: FlipFlopLiteSDK.FFError) {
//
//    }
//
//    func onChatMessageReceived(message: FlipFlopLiteSDK.FFMessage) {
//
//    }
//
//    func onBackground() {
//
//    }
//
//    func onForeground() {
//
//    }
//}
