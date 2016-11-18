//
//  ContactsBottomNavBarView.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Bottom Nav Bar Protocol

protocol BottomNavBarDelegate: class {
    func addContactButtonPressed()
    func sendToButtonPressed()
}

// MARK: - Bottom Nav Bar

class BottomNavBarView: UIView {
    var leftIconView = BottomNavBarLeftView()
    var middleIconView = BottomNavBarMiddleView()
    var rightIconView = BottomNavBarRightView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// MARK: - Nav Bar Individual Views

class BottomNavBarLeftView: UIView {
    var addContactBtn = UIButton()
    weak var delegate: BottomNavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // Add button
        addContactBtn.setTitle("+", for: .normal)
        addContactBtn.setTitleColor(UIColor.black, for: .normal)
        addContactBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 32)
        addContactBtn.frame = CGRect()
        addContactBtn.isEnabled = true
        addContactBtn.addTarget(self, action: #selector(addContactButtonTapped(_:)), for: .touchUpInside)
        addSubview(addContactBtn)
        addContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        
        // Change background
        self.backgroundColor = UIColor.green
    }
    
    func addContactButtonTapped(_ sender: UIButton) {
        
        print("\n\nadd contact button pressed\n\n")
        delegate?.addContactButtonPressed()
        
    }
    
}

class BottomNavBarMiddleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.orange
    }
    
}

class BottomNavBarRightView: UIView {
    var sendToContactBtn = UIButton()
    weak var delegate: BottomNavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // Add button
        
        sendToContactBtn.setTitle("Send", for: .normal)
        sendToContactBtn.setTitleColor(UIColor.black, for: .normal)
        sendToContactBtn.titleLabel?.font = UIFont(name: "Helvecta", size: 32)
        sendToContactBtn.frame = CGRect()
        sendToContactBtn.isEnabled = true
        sendToContactBtn.addTarget(self, action: #selector(sendToContactButtonTapped(_:)), for: .touchUpInside)
        addSubview(sendToContactBtn)
        sendToContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            
        }
        
        self.backgroundColor = UIColor.red
    }
    
    func sendToContactButtonTapped(_ sender: UIButton) {
        
        print("\n\nsend to contact button pressed\n\n")
        delegate?.sendToButtonPressed()
        
    }
    
}


// MARK: - Extensions

extension BottomNavBarView {
    
    func setupView() {
        // Create stack view
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(leftIconView)
        stackView.addArrangedSubview(middleIconView)
        stackView.addArrangedSubview(rightIconView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Create background
        self.backgroundColor = UIColor.black
    }
    
}
