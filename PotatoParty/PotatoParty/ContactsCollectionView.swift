//
//  ContactsCollectionView.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ContactsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell"
    let layout = UICollectionView   FlowLayout()
    let defaultContact = Contact(fullName: "AddContact", email: "", phone: "")
    let shared = User.shared
    
    var firstTimeLoaded: Bool = true
    
    // Inititalizers
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        
        print("Contacts")
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Cell data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if firstTimeLoaded {
            
            User.shared.contacts.insert(defaultContact, at: 0)
            firstTimeLoaded = false

        }
        
        
        
        return User.shared.contacts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactsCollectionViewCell
        
        if indexPath.item == 0 {
            
            cell.addContactIconImageView.image = UIImage(named: "addContactIcon")
            
            cell.layer.borderWidth = 0.0
            
            return cell
            
        }
        
        print(collectionView.subviews.count)
        
        cell.contact = User.shared.contacts[indexPath.row]
        
        cell.index = indexPath.row
        
        if cell.contact.is_sent == true {
            cell.alpha = 0.5
        }
        
        return cell
    }
    
    // Setup view
    func setupView() {
        delegate = self
        dataSource = self
        
        // Collection View properties
        backgroundColor = Colors.cardlyBlue
        
        
        // Create reuse cell
        register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Cells layout
        let cellWidth = self.frame.width * 0.45
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        
    }
    
    //default cell
    func setupDefaultCellView() {
        let cellWidth = self.frame.width * 0.45
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
    
    
    
    
}

