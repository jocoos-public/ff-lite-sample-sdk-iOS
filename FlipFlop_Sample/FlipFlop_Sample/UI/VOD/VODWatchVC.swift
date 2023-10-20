//
//  VODWatchVC.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit

class VODWatchViewController: BaseViewController {
    
    static func getVC(accessToken: String, videoRoom: VideoRoom) -> VODWatchViewController {
        let vc = VODWatchViewController()
        vc.videoRoom = videoRoom
        vc.accessToken = accessToken
        return vc
    }
    
    private var playView: VODPlayView!
    private var overView: VODOverView!
    
    private var accessToken: String!
    private var videoRoom: VideoRoom!
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
        
        loadPlayer()
    }
    
    func closeAction() {
        playView.closeAction()
        navigationController?.popViewController(animated: true)
    }
    
    func startStopAction() {
        isPlaying = !isPlaying
        playView.stopAction(isStop: isPlaying)
    }
    
    private func loadPlayer() {
        guard let channelId = videoRoom.channel?.id,
              let liveStartedAt = videoRoom.liveStartedAt,
              let vodURL = videoRoom.vodUrl else { return }
        
        //let startDateValue = UInt64(startDate.convertDate().timeIntervalSince1970 * 1000)
        
        playView = VODPlayView(frame: view.bounds,
                               accessToken: accessToken,
                               channelId: channelId,
                               liveStartedAt: liveStartedAt,
                               targetUrl: vodURL)
        view.addSubview(playView)
        
        overView = VODOverView(frame: CGRect(x: 0,
                                             y: topPadding,
                                             width: view.frame.width,
                                             height: view.frame.height - topPadding - bottomPadding),
                               data: videoRoom)
        view.addSubview(overView)
    }
}
