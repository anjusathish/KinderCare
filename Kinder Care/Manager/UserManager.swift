//
//  UserManager.swift
//  Kinder Care
//
//  Created by CIPL0681 on 06/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

class UserManager: NSObject {
    
    private var _currentUser: UserDetails?
    private var _schoolList:[SchoolListData]?
    private var _childNameList:[ChildName]?
    
    
    var currentUser : UserDetails? {
        get {
            return _currentUser
        }
        set {
            _currentUser = newValue
            
            if let _ = _currentUser {
                saveUser()
            }
        }
    }
    var schoolList : [SchoolListData]? {
        get {
            return _schoolList
        }
        set {
            _schoolList = newValue
            
            if let _ = _schoolList {
                saveSchoolList()
            }
        }
    }
    var childNameList : [ChildName]? {
        get {
            return _childNameList
        }
        set {
            _childNameList = newValue
            
            if let _ = _childNameList{
                saveChildNameList()
            }
        }
        
    }
    class var shared: UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
    
    private struct SerializationKeys {
        static let activeUser = "activeUser"
        static let activeSchoolList = "activeSchoolList"
        static let activeChildName = "activeChildName"
        
        
    }
    private override init () {
        
        super.init()
        
        // Load last logged user data if exists
        if isLoggedInUser() {
            getUser()
            getSchoolList()
            getChildNameList()
            
        }
    }
    func isLoggedInUser() -> Bool {
        
        guard let _ = UserDefaults.standard.object(forKey: SerializationKeys.activeUser)
            else {
                return false
        }
        return true
    }
    
    func saveSchoolList() {
        
        if let user = _schoolList {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.activeSchoolList)
            }
        }
    }
    
    func getSchoolList() {
        
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: SerializationKeys.activeSchoolList) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([SchoolListData].self, from: savedPerson) {
                schoolList = loadedPerson
               
            }
        }
    }
    
    func saveChildNameList() {
           
           if let user = _childNameList {
               let encoder = JSONEncoder()
               if let encoded = try? encoder.encode(user) {
                   let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.activeChildName)
               }
           }
       }
       
       func getChildNameList() {
           
           let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: SerializationKeys.activeChildName) as? Data {
               let decoder = JSONDecoder()
               if let loadedPerson = try? decoder.decode([ChildName].self, from: savedPerson) {
                   childNameList = loadedPerson
                  
               }
           }
       }
    
    func saveUser() {
        
        if let user = _currentUser {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.activeUser)
            }
        }
    }
    
    func getUser() {
        
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: SerializationKeys.activeUser) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserDetails.self, from: savedPerson) {
                currentUser = loadedPerson
            }
        }
    }
    func deleteActiveUser() {
        // remove active user from storage
        UserDefaults.removeObjectForKey(SerializationKeys.activeUser)
        // free user object memory
        currentUser = nil
        
    }
}

extension UserDefaults {
    
    // MARK: - User Defaults
    
    class func removeObjectForKey(_ defaultName: String) {
        UserDefaults.standard.removeObject(forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
}
