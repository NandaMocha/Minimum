//
//  OnboardViewController.swift
//  Minimum
//
//  Created by Edward Chandra on 26/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeElements()
    }
    
    @IBAction func unwindToOnboard(segue: UIStoryboardSegue){
        
    }
    
    func customizeElements (){
        signInButton.layer.cornerRadius = 11
        signUpButton.layer.cornerRadius = 11
    }

}
