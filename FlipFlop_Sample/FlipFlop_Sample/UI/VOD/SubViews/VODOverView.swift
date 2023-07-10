//
//  VODOverView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit

class VODOverView: UIView {
    
    private var watcherCount: Int = 0
    private var likeCount: Int = 0
    private var watchCntLabel: UILabel!
    private var likeCntLabel: UILabel!
    private var playBtn: UIButton!
    
    init(frame: CGRect, data: BroadcastListContent) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let titleLabel = UILabel(frame: CGRect(x: 15,
                                               y: 0,
                                               width: frame.width - 30,
                                               height: 27))
        titleLabel.backgroundColor = .clear
        titleLabel.attributedText = NSAttributedString(string: data.title ?? "",
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
        userNMLabel.attributedText = NSAttributedString(string: data.member?.appUserName ?? "",
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
        tagLabel.backgroundColor = .greyBlack3
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        tagLabel.attributedText = NSAttributedString(string: "VOD",
                                                     attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 11, weight: .black),
                                                        .paragraphStyle: style
                                                     ])
        tagLabel.layer.cornerRadius = 12.5
        tagLabel.layer.masksToBounds = true
        addSubview(tagLabel)
        
        playBtn = UIButton(type: .custom)
        playBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        playBtn.frame = CGRect(x: 15,
                               y: frame.height - 60,
                               width: 40,
                               height: 40)
        playBtn.setImage(UIImage(named: "ico_pause"), for: .normal)
        playBtn.setImage(UIImage(named: "ico_play"), for: .selected)
        playBtn.addTarget(self, action: #selector(playSwitchAction), for: .touchUpInside)
        playBtn.layer.cornerRadius = 20
        playBtn.layer.masksToBounds = true
        addSubview(playBtn)
    }
    
    @objc private func playSwitchAction() {
        if let vc = findViewController() as? VODWatchViewController {
            vc.startStopAction()
            
            playBtn.isSelected = vc.isPlaying
        }
    }
    
    @objc private func closeAction() {
        if let vc = findViewController() as? VODWatchViewController {
            vc.closeAction()
        }
    }
    
    @objc private func startSwitchAction() {
        if let vc = findViewController() as? VODWatchViewController {
            vc.closeAction()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
