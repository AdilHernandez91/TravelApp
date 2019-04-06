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
        imageView.addGestureRecognizer(tap)
        
        configureImage()
    }
    
    @objc func imgTapped() {
        let optionMenu = UIAlertController(title: nil, message: NSLocalizedString("Choose an option", comment: ""), preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete Photo", comment: ""), style: .destructive) { (action) in
            self.imageView.image = UIImage(named: AppImages.ImagePlaceholder)
        }
        
        let galleryAction = UIAlertAction(title: NSLocalizedString("Photo from gallery", comment: ""), style: .default) { (action) in
            self.launchImgPicker(camera: false)
        }
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Take a photo", comment: ""), style: .default) { (action) in
            self.launchImgPicker(camera: true)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(deleteAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func configureImage() {
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
    }
    
    func uploadDocument(title: String, description: String, url: String) {

        guard let owner = Auth.auth().currentUser?.uid else { return }
        
        var travel = Travel.init(id: "", title: title, description: description, picture: url, owner: owner)
        let docRef = Firestore.firestore().collection(Collections.Travels).document()
        
        travel.id = docRef.documentID
        
        let data = Travel.modelToData(travel: travel)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: NSLocalizedString("Unable to upload document", comment: ""))
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error)
        showDialog(title: NSLocalizedString("Error", comment: ""), message: msg)
        activityIndicator.stopAnimating()
    }
    
    func uploadImage(image: UIImage, title: String, description: String) {
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/travelImages/\(title).jpg")
        let metaData = StorageMetadata()
        
        metaData.contentType = ImageTypes.JPG
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: NSLocalizedString("Unable to upload image", comment: ""))
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: NSLocalizedString("Unable to download url", comment: ""))
                    return
                }
                
                guard let url = url else { return }
                
                self.uploadDocument(title: title, description: description, url: url.absoluteString)
                
            })
        }
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        guard let image = imageView.image ,
            let title = titleTextField.text , title.isNotEmpty ,
            let description = descriptionTextField.text , description.isNotEmpty else {
                
                showDialog(
                    title: NSLocalizedString("Validation error", comment: ""),
                    message: NSLocalizedString("Please fill out all required fields", comment: ""))
                return
        }
        
        uploadImage(image: image, title: title, description: description)
    }
}

extension NewTravelViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker(camera: Bool) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        if camera {
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        configureImage()
        
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
