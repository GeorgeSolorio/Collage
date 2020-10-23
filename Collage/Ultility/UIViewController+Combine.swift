//
//  UIViewController+Combine.swift
//  Collage
//
//  Created by George Solorio on 10/21/20.
//

import UIKit
import Combine

extension UIViewController {
   
   func alert(title: String, text: String?) -> AnyPublisher<Void, Never> {
      let alertVC = UIAlertController(title: title,
                                    message: text,
                                    preferredStyle: .alert)
   
      return Future { resolve in
         
         alertVC.addAction(UIAlertAction(title: "Close",
                                         style: .default) { _ in
            resolve(.success(()))
         })
         self.present(alertVC, animated: true, completion: nil)
      }
      .handleEvents(receiveCancel: {
         self.dismiss(animated: true)
      })
      .eraseToAnyPublisher()
   }
}
