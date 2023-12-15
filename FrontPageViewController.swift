//
//  FrontPageViewController.swift
//  TesterRoadTripPlanner
//
//  Created by Justin Guilarte on 5/17/23.
//

import UIKit
import AVKit
import AVFoundation

class FrontPageViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    private func setupVideo(){
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "maldivesVideo(1)", ofType: "mp4")!))
        let asset = AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "maldivesVideo(1)", ofType: "mp4")!))
        let layer = AVPlayerLayer(player: player)
        let playerItem = AVPlayerItem(asset: asset)
        
        
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        player.volume = 0
        
        
        player.play()
    }
    
    
    
}
