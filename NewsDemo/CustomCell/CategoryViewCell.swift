//
//  CategoryViewCell.swift
//  NewsDemo
//
//  Created by Arkar on 13/11/2023.
//

import UIKit
import AlamofireImage

class CategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var tickImageView : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
       
    }

    
    
    func configure(with category: Category) {
        print("Setting label text: \(category.categoryName)")
        lblLabel.text = category.categoryName
        
        
        imgView.image = nil
        tickImageView.isHidden = true  // Hide initially
        
        imgView.af.setImage(withURL: URL(string: category.image)!, placeholderImage: UIImage(named: "placeholder"), completion:  { response in
            switch response.result {
            case .success(_):
                self.imgView.contentMode = .scaleAspectFill
                self.imgView.layer.cornerRadius = 100
                self.imgView.layer.masksToBounds = false
                
                self.setNeedsLayout()
                self.layoutIfNeeded()
                
           //     print("Image loaded successfully from: \(response.request?.url?.absoluteString ?? "")")
                
                
//                self.tickImageView.isHidden = !category.isSelected
//               print("Configuring cell for category: \(category.categoryName), isSelected: \(category.isSelected), tickImageView.isHidden: \(self.tickImageView.isHidden)")
//               
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        })
    }


}
