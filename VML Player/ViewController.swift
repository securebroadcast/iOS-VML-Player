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
        let playerViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        playerViewController.name = nameTextField.text ?? ""
        self.present(playerViewController, animated: true, completion: nil)
    }
}

