//
//  PlayOverView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

class PlayOverView: UIView {
    
    private var watcherCount: Int = 0
    private var likeCount: Int = 0
    private var watchCntLabel: UILabel!
    private var likeCntLabel: UILabel!
    private var streamingBottomView: PlayBottomView!
    
    init(frame: CGRect, title: String, appUsername: String, type: UserType) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHelper(notif:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHelper(notif:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let titleLabel = UILabel(frame: CGRect(x: 15,
                                               y: 0,
                                               width: frame.width - 30,
                                               height: 27))
        titleLabel.backgroundColor = .clear
        titleLabel.attributedText = NSAttributedString(string: title ?? "",
                                                       attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                                                        .baselineOffset: (18 - UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight) / 4
                                                       ])
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.backgroundColor = .clear
        closeBtn.frame = CGRect(x: frame.width - 42,
                                y: 4,
                                width: 32,
                                height: 32)
        closeBtn.setImage(UIImage(named: "01AssetIcon2222IcoClose"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        addSubview(closeBtn)
        
        let infoView = UIView(frame: CGRect(x: 15,
                                            y: titleLabel.getGapPos(gap: 0).y,
                                            width: frame.width - 30,
                                            height: 18))
        infoView.backgroundColor = .clear
        addSubview(infoView)
        
        let userNMLabel = UILabel(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 200,
                                                height: 18))
        userNMLabel.backgroundColor = .clear
        userNMLabel.attributedText = NSAttributedString(string: appUsername ?? "",
                                                        attributes: [
                                                            .foregroundColor: UIColor.white,
                                                            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
                                                        ])
        userNMLabel.sizeToFit()
        infoView.addSubview(userNMLabel)
        
        let watcherView = UIImageView(frame: CGRect(x: userNMLabel.getGapPos(gap: 13).x,
                                                    y: (infoView.frame.height - 15) / 2,
                                                    width: 15,
                                                    height: 15))
        watcherView.backgroundColor = .clear
        watcherView.image = UIImage(named: "01AssetIcon1515IcoViewB")
        
        infoView.addSubview(watcherView)
        
        watchCntLabel = UILabel(frame: CGRect(x: watcherView.getGapPos(gap: 5).x,
                                              y: 0,
                                              width: 100,
                                              height: 18))
        watchCntLabel.backgroundColor = .clear
        watchCntLabel.attributedText = NSAttributedString(string: countToStr(originCnt: watcherCount),
                                                          attributes: [
                                                            .foregroundColor: UIColor.white,
                                                            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
                                                          ])
        watchCntLabel.sizeToFit()
        watchCntLabel.frame.origin.y = (infoView.frame.height - watchCntLabel.frame.height) / 2
        infoView.addSubview(watchCntLabel)
        
        let dotView = UIImageView(frame: CGRect(x: watchCntLabel.getGapPos(gap: 0).x,
                                                y: (infoView.frame.height - 15) / 2,
                                                width: 15,
                                                height: 15))
        dotView.backgroundColor = .clear
        dotView.image = UIImage(named: "01AssetIcon1515IcoBullet")
        infoView.addSubview(dotView)
        
        let likeImgView = UIImageView(frame: CGRect(x: dotView.getGapPos(gap: 0).x,
                                                    y: (infoView.frame.height - 15) / 2,
                                                    width: 15,
                                                    height: 15))
        likeImgView.backgroundColor = .clear
        likeImgView.image = UIImage(named: "01AssetIcon1515IcoLike")
        infoView.addSubview(likeImgView)
        
        likeCntLabel = UILabel(frame: CGRect(x: likeImgView.getGapPos(gap: 5).x,
                                             y: 0,
                                             width: 100,
                                             height: 18))
        likeCntLabel.backgroundColor = .clear
        likeCntLabel.attributedText = NSAttributedString(string: countToStr(originCnt: likeCount),
                                                         attributes: [
                                                            .foregroundColor: UIColor.white,
                                                            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
                                                         ])
        likeCntLabel.sizeToFit()
        likeCntLabel.frame.origin.y = (infoView.frame.height - likeCntLabel.frame.height) / 2
        infoView.addSubview(likeCntLabel)
        
        let tagLabel = UILabel(frame: CGRect(x: 15,
                                             y: infoView.getGapPos(gap: 10).y,
                                             width: 61,
                                             height: 25))
        tagLabel.backgroundColor = .orangeYellow
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        tagLabel.attributedText = NSAttributedString(string: "LIVE",
                                                     attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 11, weight: .black),
                                                        .paragraphStyle: style
                                                     ])
        tagLabel.layer.cornerRadius = 12.5
        tagLabel.layer.masksToBounds = true
        addSubview(tagLabel)
        
        streamingBottomView = PlayBottomView(frame: CGRect(x: 0,
                                                           y: frame.height / 2,
                                                           width: frame.width,
                                                           height: frame.height / 2),
                                             type: type)
        addSubview(streamingBottomView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(pinch: )))
        addGestureRecognizer(pinch)
    }
    
    @objc private func doPinch(pinch: UIPinchGestureRecognizer) {
        if pinch.state == UIPinchGestureRecognizer.State.changed {
            if let vc = findViewController() as? BroadcastViewController {
                vc.changeZoomScale(scale: pinch.scale)
            }
        }
    }
    
    @objc private func closeKeyboard() {
        endEditing(true)
    }
    
    func appendMessage(message: FFLMessage) {
        streamingBottomView.appendMessage(message: message)
    }
    
    @objc func keyboardHelper(notif: Notification) {
        var keyboardHeight: CGFloat = 0
        if let keyboardFrame: NSValue = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        if notif.name == UIResponder.keyboardWillShowNotification {
            streamingBottomView.frame.origin.y = streamingBottomView.frame.origin.y - keyboardHeight
        } else {
            streamingBottomView.frame.origin.y = self.frame.size.height / 2
        }
    }
    
    private func countToStr(originCnt: Int) -> String {
        if originCnt < 10 {
            return "00\(originCnt)"
        } else if originCnt < 100 {
            return "0\(originCnt)"
        } else {
            return "\(originCnt)"
        }
    }
    
    @objc private func closeAction() {
        if let vc = findViewController() {
            if let broadcastVC = vc as? BroadcastViewController {
                broadcastVC.closeAction()
            } else if let watchVC = vc as? BroadcastWatchViewController {
                watchVC.closeAction()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
