//
//  LivePlayView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/05.
//

import Foundation
import UIKit
import FlipFlopLiteSDK
import YUCIHighPassSkinSmoothing

protocol LivePlayViewDelegate {
    func stopComplete()
    func startComplete()
    func receiveMessage(message: FFMessage)
}

class HighpassSkinSmooth: VideoEffect {
    
    let filter = YUCIHighPassSkinSmoothing()
    
    override func execute(_ image: CIImage) -> CIImage {
        filter.inputImage = image
        guard let ciContext = ciContext else {
            return image
        }
        return CIImage(cgImage: ciContext.createCGImage(filter.outputImage!, from: image.extent)!)
    }
}
class HighpassSkinSmoothColor: VideoEffect {
    let filter: YUCIHighPassSkinSmoothing
    var color: UIColor {
        didSet {
            isColorChanged = true
        }
    }
    var isColorChanged = false
    var colorImage: CIImage?
    let overlayFilter: CIFilter = CIFilter(name: "CIOverlayBlendMode")!
    
    init(filter: YUCIHighPassSkinSmoothing, color: UIColor) {
        self.filter = filter
        self.color = color
        super.init()
    }
    override func execute(_ image: CIImage) -> CIImage {
        filter.inputImage = image

        if colorImage == nil || isColorChanged {
            isColorChanged = false
            let ext = image.extent
            colorImage = CIImage(image: color.imageWithColor(width: ext.width/UIScreen.main.nativeScale, height: ext.height/UIScreen.main.nativeScale))!
        }

        overlayFilter.setValue(colorImage, forKey: kCIInputImageKey)
        overlayFilter.setValue(filter.outputImage!, forKey: kCIInputBackgroundImageKey)
        guard let ciContext = ciContext else {
            return image
        }
        return CIImage(cgImage: ciContext.createCGImage(overlayFilter.outputImage!, from: image.extent)!)
    }
}

enum VideoFilter {
    case btn(alpha: CGFloat)
    case none
    case clean
    case pink(alpha: CGFloat)
    case baby_pink(alpha: CGFloat)
    case violet(alpha: CGFloat)
    case bright(alpha: CGFloat)
    
    mutating func setAlpha(alpha: CGFloat) {
        switch self {
        case .btn:
            self = .btn(alpha: alpha)
        case .none:
            self = .none
        case .clean:
            self = .clean
        case .pink:
            self = .pink(alpha: alpha)
        case .violet:
            self = .violet(alpha: alpha)
        case .baby_pink:
            self = .baby_pink(alpha: alpha)
        case .bright:
            self = .bright(alpha: alpha)
        }
    }
    
    var alpha: CGFloat {
        switch self {
        case .btn(let alpha):
            return alpha
        case .none:
            return 0
        case .clean:
            return 0
        case .pink(let alpha):
            return alpha
        case .violet(let alpha):
            return alpha
        case .baby_pink(let alpha):
            return alpha
        case .bright(let alpha):
            return alpha
        }
    }
}

class LivePlayView: UIView {
    
    var player: FFLStreamer?
    
    var delegate: LivePlayViewDelegate?
    private var isMirror: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
    }
    
    func setupPlayer(appID: String, userID: String, userName: String, streamKey: String, chatToken: String, channelKey: String) {
        player = FlipFlopLite.getStreamer(appId: appID,
                                          user: FFLite.User(userId: userID, username: userName),
                                          streamKey: streamKey,
                                          gossipToken: chatToken,
                                          channelKey: channelKey)
        
        player?.delegate = self
        player?.enter()
        
        let config = FFStreamerConfig()
        config.videoBitrate = 2000 * 1000
        config.keyFrameInterval = 2
        config.cameraPos = .back
        player?.prepare(preview: self, config: config)
    }
    
    func reset() {
        player = nil
    }
    
    func stopAction() {
        if let player = player {
            player.stop()
        }
    }
    
    func startAction() {
        player?.start()
    }
    
    func switchCamera() {
        player?.liveManager()?.switchCamera()
    }
    
    func switchSound() {
        
    }
    
    func zoomAction(scale: CGFloat) {
        if scale < 1.0 {
            player?.liveManager()?.zoom(factor: 1)
        } else if scale > 2.0 {
            player?.liveManager()?.zoom(factor: 2)
        } else {
            player?.liveManager()?.zoom(factor: scale)
        }
    }
    
    func switchReverse() {
        isMirror = !isMirror
        player?.liveManager()?.videoMirror(mirror: isMirror)
    }
    
    func showImage(image: UIImage?, type: TransitionType) {
        if let img = image {
            player?.liveManager()?.showImage(overlayImage: img, transitionParams: TransitionParams(transitionType: type, duration: 0.5))
        } else {
            player?.liveManager()?.hideImage()
        }
    }
    
    func changeBitrate(bitRate: Int) {
        if bitRate == 0 {
            player?.liveManager()?.enableAdaptiveBitrate()
        } else {
            player?.liveManager()?.disableAdaptiveBitrate()
            player?.liveManager()?.setVideoBitrateOnFly(bitrate: bitRate * 1024)
        }
    }
    
    
    func setFilter(filter: FilterCase) {
        switch filter {
            case .clean:
                let clean = HighpassSkinSmooth()
                player?.liveManager()?.setFilter(filter: .custom(effect: clean))
            case .pink(let alpha):
            var pink = HighpassSkinSmoothColor(filter: YUCIHighPassSkinSmoothing(), color: UIColor(red: 255.0 / 255.0, green: 67.0 / 255.0, blue: 116.0 / 255.0, alpha: alpha))
                player?.liveManager()?.setFilter(filter: .custom(effect: pink))
            case .babyPink(let alpha):
                var babyPink = HighpassSkinSmoothColor(filter: YUCIHighPassSkinSmoothing(), color: UIColor(red: 252.0 / 255.0, green: 172.0 / 255.0, blue: 166.0 / 255.0, alpha: alpha))
                player?.liveManager()?.setFilter(filter: .custom(effect: babyPink))
            case .violet(let alpha):
                var violet = HighpassSkinSmoothColor(filter: YUCIHighPassSkinSmoothing(), color: UIColor(red: 202.0 / 255.0, green: 187.0 / 255.0, blue: 249.0 / 255.0, alpha: alpha))
                player?.liveManager()?.setFilter(filter: .custom(effect: violet))
            case .bright(let alpha):
                var bright = HighpassSkinSmoothColor(filter: YUCIHighPassSkinSmoothing(), color: UIColor(red: 235 / 255.0, green: 151.0 / 255.0, blue: 149.0 / 255.0, alpha: alpha))
                player?.liveManager()?.setFilter(filter: .custom(effect: bright))
            }
    }
    
    func sendMessage(text: String, type: UserType) {
        player?.liveChat()?.sendMessage(text: text, data: type == .streamer ? "OWNER" : "MEMBER")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LivePlayView: FFLStreamerDelegate {
    func onPrepared() {
        print("onPrepared")
    }
    
    func onStarted() {
        print("onStarted")
        self.delegate?.startComplete()
    }
    
    func onStopped() {
        print("onStoopped")
        self.delegate?.stopComplete()
    }
    
    func onError(error: FlipFlopLiteSDK.FFError) {
        print("onError = ", error.localizedDescription)
    }
    
    func onChatMessageReceived(message: FlipFlopLiteSDK.FFMessage) {
        print("message = ", message.description)
        
        if message.type == "COMMAND" {
            if let customType = message.customType {
                switch customType {
                case "MANAGER_OUT":
                    //채팅 관리자 퇴장
                    break
                case "FORCE_END":
                    //강제 종료
                    break
                case "FORCE_CANCEL":
                    //강제 취소
                    break
                case "MANAGER":
                    //채팅 매니저 설정
                    break
                case "NO_MANAGER":
                    //채팅 매니저 설정 해제
                    break
                case "EXILE":
                    //추방
                    break
                case "NO_VIEWER_CHAT":
                    //시청자 채팅 정지
                    break
                case "VIEWER_CHAT":
                    //시청자 채팅 정지 해제
                    break
                case "STREAM_KEY_STATUS_CHANGED":
                    //스트림키 상태 변경
                    break
                case "PIN":
                    //핀 메세지 설정
                    break
                case "NO_PIN":
                    //핀 메세지 해제
                    break
                case "UPDATE_BROADCAST":
                    //라이브 정보 변경
                    break
                case "NO_CHAT":
                    //채팅창 전체 정지
                    break
                case "CHAT":
                    //채팅창 전체 정지 해제
                    break
                case "UPDATE_STATUS":
                    //라이브 상태 변경
                    break
                case "VISIBLE_MESSAGE":
                    //메세지 활성화
                    break
                case "INVISIBLE_MESSAGE":
                    //메세지 비 활성화
                    break
                case "HEART_COUNT":
                    //좋아요 수 변경
                    break
                case "URL_CHANGED":
                    //방송 URL 변경
                    break
                default:
                    break
                }
            }
        } else if message.type == "JOIN" {
            delegate?.receiveMessage(message: message)
        } else if message.type == "LEAVE" {
        } else if message.type == "ADMIN" {
            
        } else {
            delegate?.receiveMessage(message: message)
        }
    }
    
    func onInSufficientBW() {
        
    }
    
    func onSufficientBW() {
        
    }
    
    func onVideoBitrateChanged(newBitrate: Int) {
        
    }
}

