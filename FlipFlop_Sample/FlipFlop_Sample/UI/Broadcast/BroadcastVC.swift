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
    private var watchPlayView: WatchPlayView?
    private var liveListView: LiveListView!
    
    private var accessToken: String?
    private var streamKey: String?
    private var chatToken: String?
    private var appID: String?
    private var userID: String?
    private var userName: String?
    private var videoRoomID: Int?
    private var channelKey: String?
    
    private var state: BroadcastState = .beforeStart
    
    private var indicator: NVActivityIndicatorView? = nil
    
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
        
        liveListView = LiveListView(frame: view.bounds)
        liveListView.isHidden = true
        view.addSubview(liveListView)
        
        getAccessToken()
    }
    
    private func getAccessToken() {
        guard let userData = DataStorage.loginUser else {return}
        
        // notice: do not use this code in your app.
        //         get access token from your own server.
        //         refer to the documentation
        RequestManager.req(url: .postToken,
                           params: {
            return [
                "appUserId": userData.id, "appUserName": userData.username
            ]
        },
                           type: Token.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    weakSelf.accessToken = res.accessToken
                    weakSelf.loadPlayer()
                }
            }
        }
    }
    
    private func loadPlayer() {
        guard let accessToken = accessToken else { return }
        
        DispatchQueue.main.async {
            self.playView.setupPlayer(accessToken: accessToken)
        }
    }
    
    func showLiveList() {
        view.bringSubviewToFront(liveListView)
        liveListView.showAction()
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
    
    func watchVideo(liveUrl: String) {
        if let watchPlayView = self.watchPlayView {
            watchPlayView.removeFromSuperview()
        }
        
        self.watchPlayView = WatchPlayView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 240,
                                                         height: 320),
                                           accessToken: self.accessToken!,
                                           videoRoomId: 0,
                                           channelId: 0,
                                           targetUrl: liveUrl)
        self.view.addSubview(self.watchPlayView!)
    }
    
    func closeAction() {
        if state == .beforeStart {
            playView.reset()
            navigationController?.popViewController(animated: true)
        } else {
            playView.stopAction()
        }
        
        watchPlayView?.closeAction()
        
        closeComplete()
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
    func closeComplete() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func stopComplete() {
        state = .end
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width - 100) / 2,
                                                              y: (view.frame.height - 100) / 2,
                                                              width: 100,
                                                              height: 100),
                                                type: .ballSpinFadeLoader,
                                                color: .orangeYellow)
        if let indicator {
            self.view.addSubview(indicator)
            indicator.startAnimating()
        }
    }
    
    func startComplete() {
        state = .started
        
        startView.removeFromSuperview()
        
        overView = PlayOverView(frame: CGRect(x: 0,
                                              y: topPadding,
                                              width: view.frame.width,
                                              height: view.frame.height - topPadding - bottomPadding),
                                title: "LIVE", appUsername: "", type: .streamer)
        view.addSubview(overView)
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width - 100) / 2,
                                                              y: (view.frame.height - 100) / 2,
                                                              width: 100,
                                                              height: 100),
                                                type: .ballSpinFadeLoader,
                                                color: .orangeYellow)
//        if let indicator {
//            self.view.addSubview(indicator)
//            indicator.startAnimating()
//        }
    }
    
    func activeComplete() {
        DispatchQueue.main.async {
            self.indicator?.removeFromSuperview()
            self.indicator = nil
        }
    }
    
    func receiveMessage(message: FFLMessage) {
        if overView != nil {
            overView.appendMessage(message: message)
        }
    }
}
