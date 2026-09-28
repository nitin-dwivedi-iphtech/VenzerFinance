//
//  AuthViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import Combine
import CoreData

class AuthViewModel:ObservableObject {
    
    var context:NSManagedObjectContext?
    
    init(context:NSManagedObjectContext ){
        self.context = context
    }
    
    @discardableResult
    func loginUser(email:String, password:String) -> Bool {
        if let context {
            let request = User.fetchRequest()
            request.predicate = NSPredicate(format: "email==%@ AND password==%@", argumentArray: [email,password])
            guard let data = try? context.fetch(request) else { return false }
            if !data.isEmpty{
                AppState.shared.updateUser(user: data.first!, isLoggedIn: true)
                UserDefaults.standard.set(data.first!.id, forKey: Constants.appStateUserKey.rawValue)
                return true
            }
        }
        return false
    }
    
    @discardableResult
    func createUser(email:String, password:String, name:String, country:String) -> Bool{
        if let context {
            let user = User(context: context)
            user.id = UUID().uuidString
            user.email = email
            user.password = password
            user.name = name
            user.country = country
            context.saveData()
            UserDefaults.standard.set(user.id, forKey: Constants.appStateUserKey.rawValue)
            AppState.shared.updateUser(user: user, isLoggedIn: true)
            return true
        }
        return false
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: Constants.appStateUserKey.rawValue)
        AppState.shared.updateUser(user: nil, isLoggedIn: false)
    }
}
