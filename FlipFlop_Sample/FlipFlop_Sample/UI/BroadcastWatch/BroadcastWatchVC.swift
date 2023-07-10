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
    
    static func getVC(videoRoomID: Int) -> BroadcastWatchViewController {
        let vc = BroadcastWatchViewController()
        vc.contentsID = videoRoomID
        return vc
    }
    
    private var playView: WatchPlayView!
    private var overView: PlayOverView!
    
    private var contentsID: Int!
    private var liveContents: BroadcastListContent?
    private var liveUrl: String?
    private var channelKey: String?
    private var chatToken: String?
    private var appID: String?
    private var userID: String?
    private var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getRoomInfo()
        getChatToken()
    }
    
    func sendMessage(text: String) {
        playView.sendMessage(text: text)
    }
    
    func closeAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getRoomInfo() {
        RequestManager.req(url: .getVideoRoomDetail,
                           params: {
            return [
                "contentsID": self.contentsID
            ]
        },
                           type: BroadcastListContent.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    weakSelf.liveContents = res
                    weakSelf.channelKey = res.chat?.channelKey
                    weakSelf.liveUrl = res.liveURL
                    
                    DispatchQueue.main.async {
                        weakSelf.loadPlayer()
                    }
                }
            }
        }
    }
    
    private func getChatToken() {
        RequestManager.req(url: .postChatToken,
                           type: ChatTokenResModel.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    weakSelf.chatToken = res.chatToken
                    weakSelf.appID = res.appID
                    weakSelf.userID = res.userID
                    weakSelf.userName = res.userName
                    DispatchQueue.main.async {
                        weakSelf.loadPlayer()
                    }
                }
            }
        }
    }
    
    private func loadPlayer() {
        guard let chatToken = chatToken,
            let appID = appID,
            let userID = userID,
            let userName = userName,
        let channelKey = channelKey,
                let targetUrl = liveUrl else { return }
        
        
        playView = WatchPlayView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: view.frame.width,
                                               height: view.frame.height),
                                 appID: appID,
                                 userID: userID,
                                 userName: userName,
                                 token: chatToken,
                                 key: channelKey,
                                 targetUrl: targetUrl)
        playView.delegate = self
        view.addSubview(playView)
        
        overView = PlayOverView(frame: CGRect(x: 0,
                                              y: topPadding,
                                              width: view.frame.width,
                                              height: view.frame.height - topPadding - bottomPadding),
                                         data: BroadcastContent(listContent: liveContents!),
                                         type: .viewer)
        view.addSubview(overView)
    }
}

extension BroadcastWatchViewController: WatchPlayViewDelegate {
    func receiveMessage(message: FFMessage) {
        overView.appendMessage(message: message)
    }
}
