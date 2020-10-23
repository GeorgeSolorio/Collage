//
//  PhotoWriter.swift
//  Collage
//
//  Created by George Solorio on 10/21/20.
//

import Foundation
import UIKit
import Photos

import Combine

class PhotoWriter {
   enum Error: Swift.Error {
      case couldNotSavePhoto
      case generic(Swift.Error)
   }
   
   static func save(_ image: UIImage) -> Future<String, PhotoWriter.Error> {
      return Future { resolve in
         
         do {
            try PHPhotoLibrary.shared().performChangesAndWait {
               let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
               
               guard let saveAssetID = request.placeholderForCreatedAsset?.localIdentifier else {
                  return resolve(.failure(.couldNotSavePhoto))
               }
               resolve(.success(saveAssetID))
            }
         } catch {
            resolve(.failure(.generic(error)))
         }
      }
   }
}
