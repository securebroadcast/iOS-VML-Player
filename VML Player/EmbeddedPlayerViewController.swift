//
//  EmbeddedPlayerViewController.swift
//  VMLPlayerDemo
//
//  Created by Kris Jones on 02/06/2021.
//

import UIKit
import VMLPlayerController

class EmbeddedPlayerViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    var playerViewController: VMLPlayerViewController!
    var playerData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerControls = PlayerControls(autoplay: false, autoloop: true, showPlayerControls: false)
                
        playerData.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
        playerData.setValue("Kris", forKey: "name")
        playerData.setValue("Game VS Bryansburn", forKey: "session")
        playerData.setValue("8.14", forKey: "max_speed")
        playerData.setValue("Saturday 29th May", forKey: "date")
        playerData.setValue("0.98", forKey: "variation")
        playerViewController = VMLPlayerViewController(withData: playerData, delegate: self, playerControls: playerControls)
        
        self.playerView.addSubview(playerViewController.view)
        let paddingConstant:CGFloat = 0
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerViewController.view.topAnchor.constraint(equalTo: self.playerView.topAnchor, constant: paddingConstant).isActive = true
        playerViewController.view.bottomAnchor.constraint(equalTo: self.playerView.bottomAnchor, constant: -paddingConstant).isActive = true
        playerViewController.view.leadingAnchor.constraint(equalTo: self.playerView.leadingAnchor, constant: paddingConstant).isActive = true
        playerViewController.view.trailingAnchor.constraint(equalTo: self.playerView.trailingAnchor, constant: -paddingConstant).isActive = true
        playerView.clipsToBounds = true
        playerView.layer.cornerRadius = 10

    }

    @IBAction func playTap(_ sender: Any) {
        playerViewController.play()
    }
    
    @IBAction func pauseTap(_ sender: Any) {
        playerViewController.pause()
    }
}

extension EmbeddedPlayerViewController: VMLPlayerDelegate {
    func playerDidPostEvent(event: PlayerEvent) {
        // Handle Event
    }
}
