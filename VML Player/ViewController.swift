//
//  ViewController.swift
//  VML Player
//
//  Created by Jordan Carroll on 26/05/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func openPlayer(_ sender: Any) {
        
        let playerViewController = VMLPlayerViewController(nibName: "VMLPlayerViewController", bundle: nil) 

        let dataObject: NSMutableDictionary = NSMutableDictionary()
        dataObject.setValue("ba57cdd0-c254-11eb-9e81-d7b1112c314d", forKey: "vml_id")
        dataObject.setValue("Kris", forKey: "name")
        dataObject.setValue("Game VS Bryansburn", forKey: "session") // "Game VS Newry City"
//        dataObject.setValue("", forKey: "profile_photo")
        dataObject.setValue("8.14", forKey: "max_speed")
        dataObject.setValue("Saturday 29th May", forKey: "date")
        dataObject.setValue("0.98", forKey: "variation")
        playerViewController.playerData = dataObject
        
        self.present(playerViewController, animated: true, completion: nil)
    }
}

// TODO:

// Turn VMLPlayerController into a framework
// Create a new app and prove that we can init the View
// Create delegate to pass data from framework to VC and back

