//
//  LoginViewController.swift
//  Lunasin
//
//  Created by George Joseph Kristian on 02/08/19.
//  Copyright © 2019 Techrity. All rights reserved.
//

import UIKit
import CloudKit
//delegate untuk kasi aksi
class LogInViewController: UIViewController, UITextFieldDelegate{
    
    let database = CKContainer.default().privateCloudDatabase
    
    // retrieve accounts dalam bentuk array CKRecord
    var accounts = [CKRecord]()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLoginButton()
        retrieveDataFromCloudKit()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //return at keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    //viewTapped
    @objc func viewTapped(){
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == ""  {
            let alertController = UIAlertController(title: "Perhatian", message:
                "Email & Password tidak boleh kosong nih", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            retrieveDataFromCloudKit()
            print(accounts.count)
            
            for i in 0..<accounts.count{
                let email = accounts[i].value(forKey: "email") as! String
                let password = accounts[i].value(forKey: "password") as! String
                
                if emailTextField.text! == email && passwordTextField.text! == password {
                    print("Sign In success")
                    
                    performSegue(withIdentifier: "mainSegue", sender: self)
                    
                    break
                }
                else {
                    print("Sign In failed")
                }
            }
        }
    }
    
    func retrieveDataFromCloudKit(){
        let query = CKQuery(recordType: "Account", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, error) in
            
            guard let records = record else {return}
            
            self.accounts = records
        }
        
    }
    
    func customizeLoginButton (){
        signInButton.layer.cornerRadius = 11
        
    }
    
}
