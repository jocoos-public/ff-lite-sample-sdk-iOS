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
    
    init(frame: CGRect, appID: String, key: String, token: String, createAt: UInt64, targetUrl: String) {
        super.init(frame: frame)
        
        player = FlipFlopLite.getVodPlayer(appId: appID, channelKey: key, gossipToken: token, createdLiveAt: createAt)
        player?.delegate = self
        player?.prepare(view: self, uri: targetUrl)   
    }
    
    func stopAction(isStop: Bool) {
        if isStop {
            player?.pause()
        } else {
            player?.resume()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VODPlayView: FFLVodPlayerDelegate {
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
        
    }
    
    func onBackground() {
        
    }
    
    func onForeground() {
        
    }
}
