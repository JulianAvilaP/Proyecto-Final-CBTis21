//
//  ModalViewController.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 12/9/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit
import Photos

class ModalViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pickImageDelegate: CellCreationProtocol!
    
    // Mark: Views
    
    lazy var addProductContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0.03393554688, alpha: 0.794921875)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var dismissModalViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var showPickerControllerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(presentImagePickerController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = false
        ip.sourceType = .photoLibrary
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePickerController()
        setupViews()
        setupDismissViewTapRecognizer()
    }
    
    fileprivate func setupImagePickerController() {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overCurrentContext
    }
    
    fileprivate func setupDismissViewTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
    
    @objc func presentImagePickerController() {
        
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .authorized:
            self.present(self.imagePicker, animated: true, completion: nil)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    print("Not authorized.")
                }
            })
        
        default:
            print("Something went wrong.")
        }
        
//        let photos = PHPhotoLibrary.authorizationStatus()
//        if photos == .notDetermined
        
        
        
    }
    
    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    // Mark: UIImagePickerControllerDelegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickImageDelegate.get(Image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupViews() {
        
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        
        self.view.addSubview(addProductContainerView)
        
        addProductContainerView.addSubview(dismissModalViewButton)
        addProductContainerView.addSubview(showPickerControllerButton)
        
        addProductContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addProductContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addProductContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        addProductContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -60).isActive = true
        
        dismissModalViewButton.centerXAnchor.constraint(equalTo: addProductContainerView.centerXAnchor).isActive = true
        dismissModalViewButton.centerYAnchor.constraint(equalTo: addProductContainerView.centerYAnchor).isActive = true
        
        showPickerControllerButton.centerXAnchor.constraint(equalTo: addProductContainerView.centerXAnchor).isActive = true
        showPickerControllerButton.topAnchor.constraint(equalTo: dismissModalViewButton.bottomAnchor, constant: 20).isActive = true
    }
}

protocol CellCreationProtocol {
    func get(Image imagen: UIImage)
}
