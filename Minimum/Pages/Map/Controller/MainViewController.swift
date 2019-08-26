//
//  MainViewController.swift
//  Minimum
//
//  Created by Jessica Jacob on 22/08/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mulaiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeElement()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func customizeElement(){
        mulaiButton.layer.cornerRadius = 11
    }

}
