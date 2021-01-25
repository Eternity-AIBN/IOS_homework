//
//  ViewController.swift
//  FinalProj
//
//  Created by AIBN on 2021/1/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTestField: UITextField!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field's user input through delegate callbacks.
        nameTestField.delegate = self
    }

    //MARK: UITestFileDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reminderLabel.text = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        //Hide the keyboard
        nameTestField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, ont taken
        imagePickerController.sourceType = .photoLibrary
        
        //Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        reminderLabel.text = "Dafault Text"
    }
    
    
}

