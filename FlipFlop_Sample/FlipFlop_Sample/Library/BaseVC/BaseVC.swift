//
//  BaseVC.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let statusbarManager = scene.statusBarManager {
            topPadding = scene.windows.first?.safeAreaInsets.top ?? statusbarManager.statusBarFrame.height
            bottomPadding = scene.windows.first?.safeAreaInsets.bottom ?? 0
        }
        
    }
}
