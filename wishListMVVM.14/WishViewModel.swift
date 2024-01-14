//
//  WishViewModel.swift
//  wishListMVVM.14
//
//  Created by Madina Olzhabek on 14.01.2024.
//

import Foundation
import UIKit
 
struct State{
    enum EditingStyle{
        case addWish(String)
        case deleteWish(IndexPath)
        case toggleWish(IndexPath)
        case loadWishes([WishList])
        case none
    }
    var wishlistarray: [WishList]
    var editingStyle: EditingStyle{
        didSet{
            switch editingStyle {
            case let .addWish(newWishName):
                let newWish = WishList()
                newWish.name = newWishName
                wishlistarray.append(newWish)
                break
            case let .deleteWish(indexPath):
                wishlistarray.remove(at: indexPath.row)
                break
            case let .toggleWish(indexPath):
                wishlistarray[indexPath.row].isComplete.toggle()
                break
            case let .loadWishes(array):
                wishlistarray = array
                break
            case .none:
                break
            }
        }
    }
    init(array: [WishList]){
        wishlistarray = array
        editingStyle = .none
    }
    
    func text(at indexPath: IndexPath) -> String{
        return wishlistarray[indexPath.row].name
    }
    func isComplete(at indexPath: IndexPath) -> Bool{
        return wishlistarray[indexPath.row].isComplete
    }
    
}
class WishViewModel{
    var state = State(array: []){
        didSet{
            callback(state)
        }
    }
    
    let callback: (State) -> ()
    init(callback: @escaping (State) -> ()){
        self.callback = callback
    }
    
    func addNewWish(wishName: String){
        state.editingStyle = .addWish(wishName)
        saveWishes()
    }
    func deleteWish(at indexPath: IndexPath){
        state.editingStyle = .deleteWish(indexPath)
        saveWishes()
    }
    func toggleWish(at indexPath: IndexPath){
        state.editingStyle = .toggleWish(indexPath)
        saveWishes()
    }
    func accessoryType(at indexPath: IndexPath) -> UITableViewCell.AccessoryType{
        if state.isComplete(at: indexPath){
            return .checkmark
        }
        return .none
    }
    
    func saveWishes(){
        let defaults = UserDefaults.standard
        do{
            let encodeData = try JSONEncoder().encode(state.wishlistarray)
            defaults.set(encodeData,forKey: "WishItemArray")
        }catch{
            print("Unable to Encode Array (\(error))")
        }
    }
    func loadWish(){
        let defaults = UserDefaults.standard
        do{
            if let data = defaults.data(forKey: "WishItemArray"){
                let array = try JSONDecoder().decode([WishList].self, from: data)
                state.editingStyle = .loadWishes(array)
            }
        }catch{
            print("Unable to Decode Array (\(error))")
        }
    }
}
