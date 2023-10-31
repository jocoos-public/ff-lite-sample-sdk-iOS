//
//  BroadcastWatchVC.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

class BroadcastWatchViewController: BaseViewController {
    
    static func getVC(accessToken: String, videoRoom: VideoRoom) -> BroadcastWatchViewController {
        let vc = BroadcastWatchViewController()
        vc.videoRoom = videoRoom
        vc.accessToken = accessToken
        return vc
    }
    
    private var playView: WatchPlayView!
    private var overView: PlayOverView!
    
    private var accessToken: String!
    private var videoRoom: VideoRoom!
    
    private var channelKey: String?
    private var chatToken: String?
    private var appID: String?
    private var userID: String?
    private var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPlayer()
    }
    
    func sendMessage(text: String) {
        playView.sendMessage(text: text)
    }
    
    func closeAction() {
        playView.closeAction()
        navigationController?.popViewController(animated: true)
    }
    
    private func loadPlayer() {
        
        playView = WatchPlayView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: view.frame.width,
                                               height: view.frame.height),
                                 accessToken: accessToken,
                                 videoRoomId: videoRoom.id,
                                 channelId: videoRoom.channel?.id ?? 0,
                                 targetUrl: videoRoom.liveUrl ?? "")
        playView.delegate = self
        view.addSubview(playView)
        
        overView = PlayOverView(frame: CGRect(x: 0,
                                              y: topPadding,
                                              width: view.frame.width,
                                              height: view.frame.height - topPadding - bottomPadding),
                                title: "LIVE",
                                appUsername: "",
                                type: .viewer)
        view.addSubview(overView)
    }
}

extension BroadcastWatchViewController: WatchPlayViewDelegate {
    func receiveMessage(message: FFLMessage) {
        overView.appendMessage(message: message)
    }
}
