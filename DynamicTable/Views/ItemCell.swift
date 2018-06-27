//
//  ItemCell.swift
//  DynamicTable
//
//  Created by user on 27/6/18.
//  Copyright © 2018 SM. All rights reserved.
//

import UIKit
import SDWebImage

class ItemCell: UITableViewCell {
  
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  var itemModel: Item?
  {
    didSet {
      
      guard let unwrappedItem = itemModel else { return }
      
      if let urlString = unwrappedItem.imageHref {
      //  itemImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder"))
        itemImageView.sd_setImage(with: URL(string: urlString), placeholderImage:UIImage(named: "placeholder") , options: SDWebImageOptions.delayPlaceholder) { (image, error, cacheType, url) in
         if error != nil
         {
           self.itemImageView.image = UIImage(named: "placeholder")
         }else
         {
            if let image = image
            {
              self.itemImageView.image = image
            }
          }
        }
        
      }
      //now update the cell UI with this item model
      if let titleText = unwrappedItem.title, titleText != "" {
        titleLabel.text = titleText
      }else {
        titleLabel.text = "Empty Text"
      }
      
      if let descriptionText = unwrappedItem.description, descriptionText != "" {
        descriptionTextView.text = descriptionText
      }else {
        descriptionTextView.text = "Empty Text"
      }
      
    }
  }

}


