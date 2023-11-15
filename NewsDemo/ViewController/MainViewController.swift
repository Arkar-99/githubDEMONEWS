//
//  MainViewController.swift
//  NewsDemo
//
//  Created by Arkar on 13/11/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let selectedCategoryIDs = UserDefaults.standard.stringArray(forKey: "selected_category_ids") ?? []
        print("selected category:",selectedCategoryIDs)

           if selectedCategoryIDs.isEmpty {
               
               if let categoryViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController {
                   //categoryViewController.delegate = self
                   let navigationController = UINavigationController(rootViewController: categoryViewController)
                   navigationController.modalPresentationStyle = .fullScreen
                   present(navigationController, animated: true, completion: nil)
               }

       }
    }
}
