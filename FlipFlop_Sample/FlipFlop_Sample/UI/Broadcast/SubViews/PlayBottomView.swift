//
//  PlayBottomView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

class PlayBottomView: UIView {
    
    var chatList: [FFLMessage] = []
    
    private var chatTArea: UITableView!
    private var likeBtn: UIButton!
    private var cameraSwitchBtn: UIButton!
    private var moreBtn: UIButton!
    private var soundSwitchBtn: UIButton!
    private var heightDic: [String: CGFloat] = [:]
    
    init(frame: CGRect, type: UserType) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        chatTArea = UITableView(frame: CGRect(x: 15,
                                              y: 0,
                                              width: frame.width - 80,
                                              height: frame.height - 50),
                                style: .plain)
        chatTArea.backgroundColor = .clear
        chatTArea.delegate = self
        chatTArea.dataSource = self
        chatTArea.separatorStyle = .none
        chatTArea.showsVerticalScrollIndicator = false
        chatTArea.showsHorizontalScrollIndicator = false
        addSubview(chatTArea)
        
        if type == .streamer {
            soundSwitchBtn = UIButton(type: .custom)
            soundSwitchBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            soundSwitchBtn.frame = CGRect(x: frame.width - 55,
                                          y: frame.height - 40,
                                          width: 40,
                                          height: 40)
            soundSwitchBtn.setImage(UIImage(named: "01AssetIcon2424IcoNotice"), for: .normal)
            soundSwitchBtn.addTarget(self, action: #selector(soundSwitchAction), for: .touchUpInside)
            soundSwitchBtn.layer.cornerRadius = 20
            soundSwitchBtn.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            soundSwitchBtn.layer.shadowRadius = 1
            soundSwitchBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
            addSubview(soundSwitchBtn)
            
            moreBtn = UIButton(type: .custom)
            moreBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            moreBtn.frame = CGRect(x: frame.width - 55,
                                   y: soundSwitchBtn.frame.origin.y - 50,
                                   width: 40,
                                   height: 40)
            moreBtn.setImage(UIImage(named: "01AssetIcon2222IcoEtcoption"), for: .normal)
            moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
            moreBtn.layer.cornerRadius = 20
            moreBtn.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            moreBtn.layer.shadowRadius = 1
            moreBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
            addSubview(moreBtn)
            
            
            cameraSwitchBtn = UIButton(type: .custom)
            cameraSwitchBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            cameraSwitchBtn.frame = CGRect(x: frame.width - 55,
                                   y: moreBtn.frame.origin.y - 50,
                                   width: 40,
                                   height: 40)
            cameraSwitchBtn.setImage(UIImage(named: "01AssetIcon2222IcoCameraoption"), for: .normal)
            cameraSwitchBtn.addTarget(self, action: #selector(cameraSwitchAction), for: .touchUpInside)
            cameraSwitchBtn.layer.cornerRadius = 20
            cameraSwitchBtn.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            cameraSwitchBtn.layer.shadowRadius = 1
            cameraSwitchBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
            addSubview(cameraSwitchBtn)
            
            // watch video button
            likeBtn = UIButton(type: .custom)
            likeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            likeBtn.frame = CGRect(x: frame.width - 55,
                                   y: cameraSwitchBtn.frame.origin.y - 50,
                                   width: 40,
                                   height: 40)
            likeBtn.setImage(UIImage(named: "pip"), for: .normal)
            likeBtn.addTarget(self, action: #selector(pipAction), for: .touchUpInside)
            likeBtn.layer.cornerRadius = 20
            likeBtn.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            likeBtn.layer.shadowRadius = 1
            likeBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
            addSubview(likeBtn)
        } else {
            likeBtn = UIButton(type: .custom)
            likeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            likeBtn.frame = CGRect(x: frame.width - 55,
                                   y: frame.height - 40,
                                   width: 40,
                                   height: 40)
            likeBtn.setImage(UIImage(named: "01AssetIcon2424IcoLike"), for: .normal)
            likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
            likeBtn.layer.cornerRadius = 20
            likeBtn.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            likeBtn.layer.shadowRadius = 1
            likeBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
            addSubview(likeBtn)
        }
        
        let inputView = ChatInputField(frame: CGRect(x: 15,
                                                     y: chatTArea.getGapPos(gap: 10).y,
                                                     width: chatTArea.frame.width,
                                                     height: 35))
        addSubview(inputView)
        
        chatTArea.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let fullSize = frame.height - 50
        
        if chatTArea.contentSize.height < fullSize {
            chatTArea.frame.size.height = chatTArea.contentSize.height
            chatTArea.frame.origin.y = frame.size.height - 50 - chatTArea.frame.height
        } else {
            chatTArea.frame.size.height = fullSize
        }
    }
    
    func appendMessage(message: FFLMessage) {
        chatList.append(message)
        chatTArea.reloadData()
        chatTArea.scrollToRow(at: IndexPath(row: chatList.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc private func soundSwitchAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.soundSwitchAction()
        }
    }
    
    @objc private func moreAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.showImageEffect()
        }
    }
    
    @objc private func cameraSwitchAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.showEffect()
        }
    }
    
    @objc private func pipAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.showLiveList()
        }
    }
    
    @objc private func likeAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.likeAction()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayBottomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightDic[chatList[indexPath.row].messageId] {
            return height
        } else {
            let cell = ChatCell(style: .default, reuseIdentifier: nil, message: chatList[indexPath.row], fullWidth: chatTArea.frame.width)
            heightDic[chatList[indexPath.row].messageId] = cell.cellHeight
            return cell.cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatCell(style: .default, reuseIdentifier: nil, message: chatList[indexPath.row], fullWidth: chatTArea.frame.width)
        cell.selectionStyle = .none
        return cell
    }
}
