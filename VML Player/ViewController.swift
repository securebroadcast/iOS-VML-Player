//
//  ViewController.swift
//  VML Player
//
//  Created by Jordan Carroll on 26/05/2021.
//

import UIKit
import VMLPlayerController

class ViewController: UIViewController {
    
    var playerData = NSMutableDictionary()
    var playerViewController: VMLPlayerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func openPlayer(_ sender: Any) {
        playerData.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
        playerData.setValue("Kris", forKey: "name")
        playerData.setValue("Game VS Bryansburn", forKey: "session") // "Game VS Newry City"
//        dataObject.setValue("", forKey: "profile_photo") // HTTP URL
        playerData.setValue("8.14", forKey: "max_speed")
        playerData.setValue("Saturday 29th May", forKey: "date")
        playerData.setValue("1.98", forKey: "variation")
        playerData.setValue("negitive", forKey: "trend")
        
        let playerControls = PlayerControls(autoplay: false, autoloop: false, showPlayerControls: true)
        
        playerViewController = VMLPlayerViewController(withData: playerData, delegate: self, playerControls: playerControls)
        self.present(playerViewController, animated: true, completion: nil)
    }
    
    @IBAction func pushPlayer(_ sender: Any) {
        playerData.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
        playerData.setValue("Kris", forKey: "name")
        playerData.setValue("Game VS Bryansburn", forKey: "session") // "Game VS Newry City"
//        dataObject.setValue("", forKey: "profile_photo") // HTTP URL
        playerData.setValue("8.14", forKey: "max_speed")
        playerData.setValue("Saturday 29th May", forKey: "date")
        playerData.setValue("1.98", forKey: "variation")
        playerData.setValue("negitive", forKey: "trend")
        
        
        let playerControls = PlayerControls(autoplay: true, autoloop: true, showPlayerControls: false)
        playerViewController = VMLPlayerViewController(withData: playerData, delegate: self, playerControls: playerControls)
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    @IBAction func showEmbeddedView(_ sender: Any) {
        let embeddedViewControll = EmbeddedPlayerViewController(nibName: "EmbeddedPlayerViewController", bundle: nil)
        self.navigationController?.pushViewController(embeddedViewControll, animated: true)
    }
}

extension ViewController: VMLPlayerDelegate {
    
    func playerDidPostEvent(event: PlayerEvent) {
        
        print(event.event)
        
        if (event.event == EventType.element_clicked.rawValue) {
            print(event.meta_data)
        }
        
    }
}

// TODO:

// Turn VMLPlayerController into a framework
// Create a new app and prove that we can init the View
// Create delegate to pass data from framework to VC and back

