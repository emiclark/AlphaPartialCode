//
//  PickUploadSourceViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 8/15/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import AVFoundation

//import CoreGraphics

class PickUploadSourceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    var picker = UIImagePickerController()
    var selectedImage = UIImage()
    var uploadArtworkDelegate: UploadArtworkDelegate?
    var hideView = false

    //MARK: - View Load Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        uploadArtworkDelegate = self
        
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.lightGray.cgColor

    }

    override func viewWillAppear(_ animated: Bool) {
        if self.hideView == true {
            self.view.isHidden = true
            self.hideView = false
            self.dismiss(animated: false, completion: nil)
        } else {
            self.view.isHidden = false
        }

    }
    
    //MARK: - Buttons Tapped Methods
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        // camera button tapped, take a photo
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func photolibraryButtonTapped(_ sender: UIButton) {
        // photolibrary button tapped, select image from photo library
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        // cancel button tapped
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Misc Methods

    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        
        alertVC.addAction(okAction)
        
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // MARK: - Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // selectedImage is the image of artwork to upload.
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // resize image so that: height&width <= 2000
        let resizeImageToSize = CGSize(width: Alphaa.MAX_IMAGE_WIDTH, height: Alphaa.MAX_IMAGE_HEIGHT)
        
        // using UIImage extension in file named UIImage+Resize.swift
        let resizedImage = selectedImage.resizedImageWithContentMode(.scaleAspectFit, bounds: resizeImageToSize, interpolationQuality: CGInterpolationQuality.default)
        
        // assign resized image to selectedImage
        selectedImage = resizedImage
        
        let artworkInfoToUploadVC = ArtworkAndInfoToUploadViewController(nibName: "ArtworkAndInfoToUploadViewController", bundle: nil)
        artworkInfoToUploadVC.selectedImage = selectedImage
        artworkInfoToUploadVC.modalTransitionStyle = .coverVertical
        artworkInfoToUploadVC.modalPresentationStyle = .overCurrentContext
        
        artworkInfoToUploadVC.uploadArtworkDelegate = self as UploadArtworkDelegate
        picker.dismiss(animated: false, completion:nil)
        
        // hide view controller for visual appeal
        self.hideView = true
        self.present(artworkInfoToUploadVC, animated: true, completion: nil)
        self.dismiss(animated: false, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancel taking a photo or selecting an image from the photo library
        self.hideView = true
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PickUploadSourceViewController: UploadArtworkDelegate {
    
    func cancelPickSourceVCFromUploadArtworkVC() {
        // pop VC to collection view
        self.dismiss(animated: false) {
            print("PickUploadSourceViewController: dismissVC")
        }
    }
    
}
