//
//  BroadcastListVC.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit

class BroadcastListViewController: BaseViewController {
    private var list: [VideoRoom] = []
    private var contentTArea: UITableView!
    
    private var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let naviArea = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 49 + topPadding))
        naviArea.backgroundColor = .orangeYellow
        view.addSubview(naviArea)
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.backgroundColor = .clear
        logoBtn.frame = CGRect(x: 20,
                               y: (23 / 2) + topPadding,
                               width: 115,
                               height: 26)
        logoBtn.setImage(UIImage(named: "topLogo"), for: .normal)
        logoBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        naviArea.addSubview(logoBtn)
        
        contentTArea = UITableView(frame: CGRect(x: 0,
                                                 y: naviArea.getGapPos(gap: 0).y,
                                                 width: view.frame.width,
                                                 height: view.frame.height - naviArea.getGapPos(gap: 0).y - bottomPadding), style: .plain)
        contentTArea.backgroundColor = .clear
        contentTArea.delegate = self
        contentTArea.dataSource = self
        contentTArea.separatorStyle = .none
        view.addSubview(contentTArea)
        
        getAccessToken()
        getList()
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
                }
            }
        }
    }
    
    private func getList() {
        // notice: do not use this code in your app.
        //         get video list from your own server.
        //         refer to the documentation
        RequestManager.req(url: .getVideoRooms,
                           type: VideoRooms.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    var items: [VideoRoom] = []
                    items.append(contentsOf: res.content)
                    
                    weakSelf.list = items
                    
                    DispatchQueue.main.async {
                        weakSelf.contentTArea.reloadData()
                    }
                }
            }
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension BroadcastListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BroadcastCell(style: .default, reuseIdentifier: nil, data: list[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let accessToken = self.accessToken else {
            return
        }
        
        let selectContents = list[indexPath.row]
        
        if selectContents.liveUrl != nil {
            let nextVC = BroadcastWatchViewController.getVC(accessToken: accessToken, videoRoom: selectContents)
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = VODWatchViewController.getVC(accessToken: accessToken, videoRoom: selectContents)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
