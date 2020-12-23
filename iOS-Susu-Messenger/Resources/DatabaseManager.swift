//
//  DatabaseManager.swift
//  iOS-Susu-Messenger
//
//  Created by Punreach Rany on 2020/12/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func test(){
        database.child("foo").setValue(["something" : true])
    }
    
    
}

// MARK: - Account Management

extension DatabaseManager{
    
    public func userExists(with email: String, completion: @escaping((Bool)->Void) ){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        print("UserExists", safeEmail)
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Insert new user to database
    public func insertUser(with user: ChatAppUser){
        print("InsertUser", user.safeEmail)
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ])
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
//    let profilePictureUrl: String
    
    var safeEmail: String {
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
}
