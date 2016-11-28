//
//  User.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    static let shared = User()
    
    let uid: String
    let groups: [String] = ["All", "Family", "Friends", "Coworkers", "Other"]
    var selectedContacts = [Contact]()
    // TODO: - What am I doing with this? (Dave)
    var contacts: [Contact] = []

    private init() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.uid = uid
        } else {
            fatalError("Couldn't unwrap user ID in User.swift singleton")
        }
    }
}
