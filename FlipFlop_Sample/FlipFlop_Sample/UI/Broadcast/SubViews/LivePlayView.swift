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
    func activeComplete()
    func closeComplete()
    func receiveMessage(message: FFLMessage)
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
    
    func setupPlayer(accessToken: String) {
        player = FlipFlopLite.getStreamer(accessToken: accessToken)
        
        player?.delegate = self
        
        let config = FFStreamerConfig()
        config.videoBitrate = 2000 * 1000
        config.cameraPos = .back
        config.echoCancellation = true
        player?.prepare(preview: self, config: config)
    }
    
    func reset() {
        player = nil
    }
    
    func stopAction() {
        if let player = player {
            player.stop()
            player.exit()
        }
    }
    
    func startAction() {
        guard let userData = DataStorage.loginUser else {return}
        
        player?.setVideoRoomInfo(title: "iOS-Sample-\(userData.username)")
        player?.enter()
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
        player?.liveChat()?.sendMessage(message: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LivePlayView: FFLStreamerDelegate {
    // StreamerState is updated
    func fflStreamer(_ streamer: FFLStreamer, didUpdate streamerState: StreamerState) {
        switch streamerState {
        case .prepared:
            print("streamer is prepared")
        case .started:
            print("streamer is started")
            delegate?.startComplete()
        case .stopped:
            print("streamer is stopped")
            delegate?.stopComplete()
        case .closed:
            print("streamer is closed")
            delegate?.closeComplete()
        default:
            print("unknown streamState")
        }
    }
    
    // BroadcastState is updated
    func fflStreamer(_ streamer: FFLStreamer, didUpdate broadcastState: FlipFlopLiteSDK.BroadcastState) {
        switch broadcastState {
        case .active:
            print("broadcasting is active")
            delegate?.activeComplete()
        case .inactive:
            print("broadcasting is inactive")
        default:
            print("unknown BroadcastState: \(broadcastState)")
        }
    }
    
    // room for live streaming already exists
    func fflStreamer(_ streamer: FFLStreamer, didExist videoRoom: FFLVideoRoom) {
        
    }
    
    // alarm is published
    func fflStreamer(_ streamer: FFLStreamer, didPublish alarmState: AlarmState) {
        
    }
    
    // video bitrate is changed
    func fflStreamer(_ streamer: FFLStreamer, didChangeVideoBitrate bitrate: Int) {
        
    }
    
    // camera zoom is changed
    func fflStreamer(_ streamer: FFLStreamer, didChangeZoom zoomFactor: CGFloat) {
        
    }
    
    // chat message is received
    func fflStreamer(_ streamer: FFLStreamer, didReceive message: FFLMessage) {
        DispatchQueue.main.async {
            self.delegate?.receiveMessage(message: message)
        }
    }
    
    // Some error happened
    func fflStreamer(_ streamer: FFLStreamer, didFail error: FFError) {
        print("onError = ", error.localizedDescription)
    }
}

