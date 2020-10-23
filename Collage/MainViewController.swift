//
//  MainViewController.swift
//  Collage
//
//  Created by George Solorio on 10/21/20.
//

import UIKit
import Combine

class MainViewController: UIViewController {
   
   // MARK: - Outlets
   
   @IBOutlet weak var imagePreview: UIImageView! {
      didSet {
         imagePreview.layer.borderColor = UIColor.gray.cgColor
      }
   }
   @IBOutlet weak var buttonClear: UIButton!
   @IBOutlet weak var buttonSave: UIButton!
   @IBOutlet weak var itemAdd: UIBarButtonItem!
   
   // MARK: - Private properties
   private var subscription = Set<AnyCancellable>()
   private let images = CurrentValueSubject<[UIImage], Never>([])
   
   
   
   // MARK: - View controller
   
   override func viewDidLoad() {
      super.viewDidLoad()
      let collageSize = imagePreview.frame.size
      
      images
         .handleEvents(receiveOutput: { [weak self] photos in
            self?.updateUI(photos: photos)
         })
         .map { photos in
            UIImage.collage(images: photos, size: collageSize)
         }
         .assign(to: \.image, on: imagePreview)
         .store(in: &subscription)
   }
   
   private func updateUI(photos: [UIImage]) {
      buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
      buttonClear.isEnabled = photos.count > 0
      itemAdd.isEnabled = photos.count < 6
      title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
   }
   
   // MARK: - Actions
   
   @IBAction func actionClear() {
      images.send([])
   }
   
   @IBAction func actionSave() {
      guard let image = imagePreview.image else { return }
      
      PhotoWriter.save(image)
         .sink(receiveCompletion: { [unowned self] completion in
            
            if case .failure(let error) = completion {
               self.showMessage("Error", description: error.localizedDescription)
            }
            self.actionClear()
         }, receiveValue: { [unowned self] id in
            self.showMessage("Saved with id: \(id)")
         })
         .store(in: &subscription)
   }
   
   @IBAction func actionAdd() {
      let photos = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
      
      let newPhotos = photos.selectedPhotos
      
      newPhotos
         .map { [unowned self] newImage in
            return self.images.value + [newImage]
         }
         .assign(to: \.value, on: images)
         .store(in: &subscription)
      navigationController!.pushViewController(photos, animated: true)
   }
   
   private func showMessage(_ title: String, description: String? = nil) {
     
      alert(title: title, text: description)
         .sink(receiveValue: { _ in })
         .store(in: &subscription)
   }
}
