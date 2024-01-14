//
//  ViewController.swift
//  wishListMVVM.14
//
//  Created by Madina Olzhabek on 14.01.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    var viewModel: WishViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = WishViewModel{ [unowned self] (state) in
            switch state.editingStyle{
                
            case .addWish(_):
                textfield.text = ""
                break
            case .deleteWish(_):
                break
            case .toggleWish(_):
                break
            case .loadWishes(_):
                break
            case .none:
                break
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadWish() 
    }


    @IBAction func addWishButton(_ sender: Any) {
        viewModel.addNewWish(wishName: textfield.text!)
    }
}

