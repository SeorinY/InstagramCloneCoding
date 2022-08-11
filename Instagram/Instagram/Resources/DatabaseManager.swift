//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import FirebaseDatabase

public class DatabaseManager{
    //기기에서 저장하고 사용하기 위해, 프로그램에 하나밖에 없음~
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //Mark: - Public
    
    /// Check if username and email is availavle
    ///  - Parameters
    ///     - email : String representing email
    ///     - username : String representing username
    public func canCreateNewUser(with email: String, username : String, completion : (Bool) -> Void){
        completion(true
        )
    }
    /// Insert new user data to database
    ///  - Parameters
    ///     - email : String representing email
    ///     - username : String representing username
    ///     - completion : Async callback for result if datavase entry succeded
    public func insertNewUser(with email : String, username : String, completion : @escaping (Bool) -> Void){
        database.child(email.safeDatabaseKey()).setValue(["username" : username]){ error, _ in
            if error == nil{
                //succeded
                completion(true)
                return
            }
            else{
                //failed
                completion(false)
                return
            }
        }
    }
    
}
