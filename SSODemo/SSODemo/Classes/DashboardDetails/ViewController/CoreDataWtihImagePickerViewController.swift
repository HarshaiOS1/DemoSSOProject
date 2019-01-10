//
//  CoreDataWtihImagePickerViewController.swift
//  SSODemo
//
//  Created by wfh on 09/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import UIKit
import Photos

class CoreDataWtihImagePickerViewController: UIViewController {
    
    @IBOutlet weak var addedImagesCollectionView: UICollectionView!
    @IBOutlet weak var coreDataFetchedImagesCollecitonView: UICollectionView!
    
    let photoPicker = UIImagePickerController()
    var viewModel: CoreDataWithImagePickerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CoreDataWithImagePickerViewModel()
        
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        
        addedImagesCollectionView.delegate = self
        addedImagesCollectionView.dataSource = self
        coreDataFetchedImagesCollecitonView.delegate = self
        coreDataFetchedImagesCollecitonView.dataSource = self
        registerNibs()
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func fetchPhotoButtonAction(_ sender: Any) {
        if let imagesAvailable = viewModel?.fetchImagesFromDB(), imagesAvailable {
            coreDataFetchedImagesCollecitonView.reloadData()
        }
    }
    
    func registerNibs() {
        addedImagesCollectionView.register(UINib(nibName: Constants.CollectionViewCells.imagesCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: (Constants.CollectionViewCells.imagesCollectionViewCell))
        coreDataFetchedImagesCollecitonView.register(UINib(nibName: Constants.CollectionViewCells.imagesCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: (Constants.CollectionViewCells.imagesCollectionViewCell))
    }
    
    deinit {
        NSLog("CoreDataWtihImagePickerViewController: Denit")
    }
}

//MARK: Image Picker and Navigation Controller Delegate
extension CoreDataWtihImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else  {
            fatalError("unsupported image format: \(info)")
        }
        if let isImageSaved = viewModel?.saveImagesToDB(image: selectedImage), isImageSaved {
            addedImagesCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: Collection View Delegate And DataSource
extension CoreDataWtihImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addedImagesCollectionView {
            return viewModel?.model.addedImageArray?.count ?? 0
        } else if collectionView == coreDataFetchedImagesCollecitonView {
            return viewModel?.model.fetchedImageArray?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var array: [AnyObject?]?
        var cellImage: Data?
        guard let cell: ImagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCells.imagesCollectionViewCell, for: indexPath) as? ImagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch collectionView {
        case addedImagesCollectionView:
            if let addedArray = viewModel?.model.addedImageArray {
                array = addedArray as [AnyObject?]
                if array?.count != 0 {
                    cellImage = array?[indexPath.row] as? Data
                }
            }
        case coreDataFetchedImagesCollecitonView:
            if let addedArray = viewModel?.model.fetchedImageArray {
                array = addedArray
                if array?.count != 0 {
                    if let imageData = array?[indexPath.row]?.value(forKey: "image") as? Data {
                        cellImage = imageData
                    }
                }
            }
        default:
            return UICollectionViewCell()
        }
        if let imageData = cellImage {
            cell.imageView.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: addedImagesCollectionView.frame.width / 3.0 , height: addedImagesCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
}
