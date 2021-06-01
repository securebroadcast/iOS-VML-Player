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
        playerData.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
        playerData.setValue("Kris", forKey: "name")
        playerData.setValue("Game VS Bryansburn", forKey: "session") // "Game VS Newry City"
//        dataObject.setValue("", forKey: "profile_photo") // HTTP URL
        playerData.setValue("8.14", forKey: "max_speed")
        playerData.setValue("Saturday 29th May", forKey: "date")
        playerData.setValue("0.98", forKey: "variation")
        playerViewController = VMLPlayerViewController(withData: playerData, delegate: self)
    }
    
    @IBAction func openPlayer(_ sender: Any) {
        self.present(playerViewController, animated: true, completion: nil)
    }
    
    @IBAction func pushPlayer(_ sender: Any) {
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
}

extension ViewController: VMLPlayerDelegate {
    
    func playerDidPostEvent(event: PlayerEvent) {
        
    }
}

// TODO:

// Turn VMLPlayerController into a framework
// Create a new app and prove that we can init the View
// Create delegate to pass data from framework to VC and back

