//
//  VODWatchVC.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit

class VODWatchViewController: BaseViewController {
    
    static func getVC(contentsID: Int) -> VODWatchViewController {
        let vc = VODWatchViewController()
        vc.contentsID = contentsID
        return vc
    }
    
    private var playView: VODPlayView!
    private var overView: VODOverView!
    
    private var vodContents: BroadcastListContent?
    private var contentsID: Int!
    private var startDate: String?
    private var vodURL: String?
    private var channelKey: String?
    private var chatToken: String?
    private var appID: String?
    private var userID: String?
    private var userName: String?
    var isPlaying: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        getDetailInfo()
        getChatToken()
    }
    
    func closeAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func startStopAction() {
        isPlaying = !isPlaying
        playView.stopAction(isStop: isPlaying)
    }
    
    private func getDetailInfo() {
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
                    weakSelf.vodContents = res
                    weakSelf.vodURL = res.vodURL
                    weakSelf.startDate = res.createdAt
                    weakSelf.channelKey = res.chat?.channelKey
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
            let appID = appID, let startDate = startDate, let channelKey = channelKey, let vodURL = vodURL else { return }
        
        let startDateValue = UInt64(startDate.convertDate().timeIntervalSince1970 * 1000)
        
        playView = VODPlayView(frame: view.bounds,
                               appID: appID,
                               key: channelKey,
                               token: chatToken,
                               createAt: startDateValue,
                               targetUrl: vodURL)
        view.addSubview(playView)
        
        overView = VODOverView(frame: CGRect(x: 0,
                                             y: topPadding,
                                             width: view.frame.width,
                                             height: view.frame.height - topPadding - bottomPadding),
                               data: vodContents!)
        view.addSubview(overView)
    }
}
