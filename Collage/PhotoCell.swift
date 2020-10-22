//
//  PhotoCell.swift
//  Collage
//
//  Created by George Solorio on 10/21/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
   
   @IBOutlet var preview: UIImageView!
   var representedAssetIdentifier: String!
   
   override func prepareForReuse() {
      super.prepareForReuse()
      preview.image = nil
   }
   
   func flash() {
      preview.alpha = 0
      setNeedsDisplay()
      UIView.animate(withDuration: 0.5, animations: { [weak self] in
         self?.preview.alpha = 1
      })
   }
}
