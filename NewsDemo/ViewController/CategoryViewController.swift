//
//  CategoryViewController.swift
//  NewsDemo
//
//  Created by Arkar on 13/11/2023.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol CategoryViewControllerDelegate: AnyObject {
   func categoryViewControllerDidSave(categories: [String])
}

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = []
    var selectedCategoryList: [String] = []
    weak var delegate: CategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        NetworkManager.shared.postRegisterDevice { success in
            if (success){
                self.fetchCategories()
            }
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveSelectedCategories()
    }
    
    private func saveSelectedCategories() {
            if selectedCategoryList.count >= 3 {
                UserDefaults.standard.set(selectedCategoryList, forKey: "selected_category_ids")
                UserDefaults.standard.synchronize()
                //delegate?.categoryViewControllerDidSave(categories: selectedCategoryList)
                dismiss(animated: true, completion: nil)
            } else {
                // Show an alert or handle the case where less than 3 categories are selected
                print("Please select at least 3 categories.")
            }
        }
    
    func fetchCategories() {
        let userToken = UserDefaults.standard.string(forKey: "user_token") ?? ""
        print("user token:",userToken)
        NetworkManager.shared.getCategories(userToken: userToken) { [weak self] categories in
            DispatchQueue.main.async {
                self?.categories = categories
                self?.collectionView.reloadData()
            }
        }
    }
    
    //UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell

        
        let category = categories[indexPath.row]
          cell.configure(with: category)
       
        return cell
    }

    // UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleSelection(at: indexPath)
    }
    
    private func toggleSelection(at indexPath: IndexPath) {
        
        let category = categories[indexPath.row]
        let cell = collectionView!.cellForItem(at: indexPath) as! CategoryViewCell
        
        if ( selectedCategoryList.contains(category.id)){
            let idList = selectedCategoryList.filter { $0 != category.id }
            selectedCategoryList = idList
            //hide the selector
            cell.tickImageView.isHidden = true
        }
        else{
            selectedCategoryList.append(category.id)
            //show the selector
            cell.tickImageView.isHidden = false
        }
        print("selected id list:",selectedCategoryList)
//            categories[indexPath.row].isSelected.toggle()
//            collectionView.reloadItems(at: [indexPath])
    }
    
    
    //  UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return CGSize(width: 110, height: 180 )
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
   


