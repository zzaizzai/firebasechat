//
//  FirebaseManager.swift
//  firebasechat
//
//  Created by 小暮準才 on 2022/05/09.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    //singleton
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
