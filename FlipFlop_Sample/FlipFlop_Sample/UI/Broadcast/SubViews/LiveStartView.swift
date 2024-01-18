//
//  LiveStartView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/05.
//

import Foundation
import UIKit

class LiveStartView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.backgroundColor = .clear
        closeBtn.frame = CGRect(x: frame.width - 47,
                                y: 12,
                                width: 32,
                                height: 32)
        closeBtn.setImage(UIImage(named: "01AssetIcon2222IcoClose"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        addSubview(closeBtn)
        
        let startBtn = UIButton(type: .custom)
        startBtn.frame = CGRect(x: (frame.width - 120) / 2,
                                y: frame.height - 50,
                                width: 120,
                                height: 50)
        startBtn.backgroundColor = .orangeYellow
        startBtn.setAttributedTitle(NSAttributedString(string: "Start",
                                                       attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 15, weight: .medium)
                                                       ]), for: .normal)
        startBtn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        startBtn.layer.cornerRadius = 25
        startBtn.layer.masksToBounds = true
        addSubview(startBtn)
        
        let switchBtn = UIButton(type: .custom)
        switchBtn.backgroundColor = .clear
        switchBtn.frame = CGRect(x: startBtn.getGapPos(gap: 20).x,
                                 y: 0,
                                 width: 28,
                                 height: 28)
        switchBtn.setImage(UIImage(named: "02Button2828CameraOption"), for: .normal)
        switchBtn.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
        addSubview(switchBtn)
        
        let moreBtn = UIButton(type: .custom)
        moreBtn.backgroundColor = .clear
        moreBtn.frame = CGRect(x: switchBtn.getGapPos(gap: 20).x,
                               y: 0,
                               width: 28,
                               height: 28)
        moreBtn.setImage(UIImage(named: "02Button2828EtcOption"), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        addSubview(moreBtn)
        
        let pipBtn = UIButton(type: .custom)
        pipBtn.backgroundColor = .clear
        pipBtn.frame = CGRect(x: 20,
                              y: frame.height - 40,
                              width: 28,
                              height: 28)
        pipBtn.setImage(UIImage(named: "pip"), for: .normal)
        pipBtn.addTarget(self, action: #selector(pipAction), for: .touchUpInside)
        addSubview(pipBtn)
        
        switchBtn.center.y = startBtn.center.y
        moreBtn.center.y = startBtn.center.y
    }
    
    @objc private func startAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.startAction()
        }
    }
    
    @objc private func closeAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.closeAction()
        }
    }
    
    @objc private func switchAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.showEffect()
        }
    }
    
    @objc private func moreAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.showImageEffect()
        }
    }
    
    @objc private func pipAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.showLiveList()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
