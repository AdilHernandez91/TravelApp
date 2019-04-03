//
//  NewTravelViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 03/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class NewTravelViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        
        tap.numberOfTapsRequired = 1
        
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func imgTapped() {
        
        showImageSheet()
        
    }
    
    func uploadImageThenDocument() {
        
        guard let image = imageView.image ,
            let title = titleTextField.text , title.isNotEmpty ,
            let description = descriptionTextField.text , description.isNotEmpty else {
            
                showDialog(title: "Validation error", message: "Please fill out all required fields.")
                return
        }
        
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/travelImages/\(title).jpg")
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "Unable to download url")
                    return
                }
                
                guard let url = url else { return }
                
                self.uploadDocument(title: title, description: description, url: url.absoluteString)
                
            })
            
        }
        
    }
    
    func uploadDocument(title: String, description: String, url: String) {

        guard let owner = Auth.auth().currentUser?.uid else { return }
        
        var travel = Travel.init(id: "", title: title, description: description, picture: url, owner: owner)
        let docRef = Firestore.firestore().collection("travels").document()
        
        travel.id = docRef.documentID
        
        let data = Travel.modelToData(travel: travel)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload document.")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error)
        showDialog(title: "Error", message: msg)
        activityIndicator.stopAnimating()
    }
    
    func deletePhoto() {
        
        imageView.image = UIImage(named: AppImages.ImagePlaceholder)
        
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        uploadImageThenDocument()
        
    }
    
}

extension NewTravelViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImageSheet() {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .destructive) { (action) in
            self.deletePhoto()
        }
        
        let galleryAction = UIAlertAction(title: "Photo from gallery", style: .default) { (action) in
            self.launchImgPicker()
        }
        
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
            self.imageFromCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(deleteAction)
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    func launchImgPicker() {
    
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imageFromCamera() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
