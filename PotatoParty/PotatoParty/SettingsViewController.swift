//
//  SettingsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    var changeEmailButton = UIButton()
    var changePasswordButton = UIButton()
    var logoutButton = UIButton()
    var dismissButton: UIButton?
    var titleLabel: UILabel?
  //  var settingsBackgroundImage: UIImage = #imageLiteral(resourceName: "contactsAndSettingsVCBackgroundImage")
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutElements()
        
        let closeBtn = UIButton()
        self.view.addSubview(closeBtn)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(35)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
//        dismissButton = {
//            let button = UIButton(frame: .zero)
//            button.setImage(UIImage(named: "ic_menu"), for: .normal)
//            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
//            return button
//        }()

        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = ""
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
    }
    

    
    // MARK - Methods (mostly buttons)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            present(LoginViewController(), animated: true, completion: {
                self.navigationController?.viewControllers.removeAll()
            })
        } catch {
            print("Logout error = (error.localizedDescription)")
        }
    }
    
    func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    
    func changeEmailButtonTapped(_sender: UIButton) {
        // TO DO
        
    }
    
    
    func changePasswordButtonTapped(_sender: UIButton) {
        // TO DO
        
    }
    
    
}

// MARK - Settings Animation

extension SettingsViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}


