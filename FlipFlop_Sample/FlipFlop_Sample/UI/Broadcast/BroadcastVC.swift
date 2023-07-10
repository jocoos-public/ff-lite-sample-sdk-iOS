//
//  MakeBroadcastVC.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit
import FlipFlopLiteSDK
import NVActivityIndicatorView

enum BroadcastState {
case beforeStart, started, end
}

enum UserType {
case streamer, viewer, VOD
}

class BroadcastViewController: BaseViewController {
    
    private var startView: LiveStartView!
    private var playView: LivePlayView!
    private var overView: PlayOverView!
    private var effectView: EffectSetView!
    private var imgEffectView: ImageEffectView!
    
    private var streamKey: String?
    private var chatToken: String?
    private var appID: String?
    private var userID: String?
    private var userName: String?
    private var videoRoomID: Int?
    private var channelKey: String?
    private var broadcastContent: BroadcastContent?
    
    private var state: BroadcastState = .beforeStart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        playView = LivePlayView(frame: view.bounds)
        playView.delegate = self
        view.addSubview(playView)
        
        startView = LiveStartView(frame: CGRect(x: 0,
                                                y: topPadding,
                                                width: view.frame.width,
                                                height: view.frame.height - topPadding - bottomPadding))
        view.addSubview(startView)
        
        effectView = EffectSetView(frame: view.bounds)
        effectView.isHidden = true
        view.addSubview(effectView)
        
        imgEffectView = ImageEffectView(frame: view.bounds)
        imgEffectView.isHidden = true
        view.addSubview(imgEffectView)
        
        getStreamKey()
        getChatToken()
        createVideoRoom()
    }
    
    private func getStreamKey() {
        guard let userData = DataStorage.fflToken?.member else {return}
        
        RequestManager.req(url: .getStreamKey,
                           params: {
            return [
                "memberId": userData.id
            ]
        },
                           type: GetStreamKeyResModel.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    if let contents = res.content.first {
                        weakSelf.broadcastContent = contents
                        weakSelf.streamKey = contents.streamKey
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
                    weakSelf.loadPlayer()
                }
            }
        }
    }
    
    private func createVideoRoom() {
        RequestManager.req(url: .postVideoRooms,
                           params: {
            return [
                "title": Date().convertISOTime(),
                "type": "BROADCAST_RTMP",
                "description": "Sample App test",
                "accessLevel": "PUBLIC",
                "scheduledAt": Date().convertISOTime()
            ]
        },
                           type: PostVideoRoomResModel.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    weakSelf.videoRoomID = res.id
                    weakSelf.channelKey = res.chat.channelKey
                    weakSelf.loadPlayer()
                }
            }
        }
    }
    
    private func loadPlayer() {
        guard let streamKey = streamKey,
        let chatToken = chatToken,
            let appID = appID,
            let userID = userID,
            let userName = userName,
            let channelKey = channelKey else { return }
        
        DispatchQueue.main.async {
            self.playView.setupPlayer(appID: appID, userID: userID, userName: userName, streamKey: streamKey, chatToken: chatToken, channelKey: channelKey)
        }
    }
    
    func showEffect() {
        view.bringSubviewToFront(effectView)
        effectView.showAction()
    }
    
    func showImageEffect() {
        view.bringSubviewToFront(imgEffectView)
        imgEffectView.showAction()
    }
    
    func showImage(image: UIImage?, type: TransitionType) {
        playView.showImage(image: image, type: type)
    }
    
    func changeZoomScale(scale: CGFloat) {
        playView.zoomAction(scale: scale)
    }
    
    func changeReverse() {
        playView.switchReverse()
    }
    
    func startAction() {
        playView.startAction()
    }
    
    func setFilter(selectFilter: FilterCase) {
        playView.setFilter(filter: selectFilter)
    }
    
    func closeAction() {
        if state == .beforeStart {
            playView.reset()
            navigationController?.popViewController(animated: true)
        } else {
            playView.stopAction()
        }
    }
    
    func switchAction() {
        playView.switchCamera()
    }
    
    func likeAction() {
        
    }
    
    func soundSwitchAction() {
        playView.switchSound()
    }
    
    func chatSendAction(text: String) {
        playView.sendMessage(text: text, type: .streamer)
    }
    
    func changeBitrate(bitRate: Int) {
        playView.changeBitrate(bitRate: bitRate)
    }
}

extension BroadcastViewController: LivePlayViewDelegate {
    func stopComplete() {
        guard let roomID = videoRoomID else {return}
        
        state = .end
        
        let indicator = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width - 100) / 2,
                                                              y: (view.frame.height - 100) / 2,
                                                              width: 100,
                                                              height: 100),
                                                type: .ballSpinFadeLoader,
                                                color: .orangeYellow)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 5.0) {
            RequestManager.req(url: .postBroadcastEnd,
                               params: {
                return [
                    "contentsID": roomID
                ]
            },
                               type: ErrorModel.self) { [weak self] isComplete, response, error in
                guard let weakSelf = self else {return}
                
                DispatchQueue.main.async {
                    weakSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func startComplete() {
        guard let roomID = videoRoomID, let contents = broadcastContent else {return}
        
        state = .started
        
        startView.removeFromSuperview()
        
        overView = PlayOverView(frame: CGRect(x: 0,
                                              y: topPadding,
                                              width: view.frame.width,
                                              height: view.frame.height - topPadding - bottomPadding),
                                data: contents, type: .streamer)
        view.addSubview(overView)
        
        let indicator = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width - 100) / 2,
                                                              y: (view.frame.height - 100) / 2,
                                                              width: 100,
                                                              height: 100),
                                                type: .ballSpinFadeLoader,
                                                color: .orangeYellow)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 20.0) {
            RequestManager.req(url: .postBroadcastStart,
                               params: {
                return [
                    "contentsID": roomID
                ]
            },
                               type: ErrorModel.self) { [weak self] isComplete, response, error in
                guard let weakSelf = self else {return}
                
                indicator.removeFromSuperview()
                if isComplete {
                    
                }
            }
        }
    }
    
    func receiveMessage(message: FFMessage) {
        if overView != nil {
            overView.appendMessage(message: message)
        }
    }
}
