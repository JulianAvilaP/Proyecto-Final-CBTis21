//
//  CollectionViewController.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 10/27/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit
import CoreBluetooth
import Photos

private let reuseIdentifier = "Cell"
private var yOffsetNavigationBar: CGFloat = 32

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBPeripheralManagerDelegate, CancelOperationProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {	
    
    
    // Mark: Modelo
    
    var imagenes = [#imageLiteral(resourceName: "tornillos.jpg")]
    
    // MARK: Vistas
    
    lazy var startAdvertisingSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.isEnabled = false
        toggle.addTarget(self, action: #selector(startAdvertising(_:)), for: .valueChanged)
        return toggle
    }()
    
    lazy var alertCheatController: UIAlertController = {
        let alertController = UIAlertController(title: "Source", message: "Choose source", preferredStyle: .actionSheet)
        let cheatControllerActions = [UIAlertAction(title: "Library", style: .default, handler: { (action) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.presentImagePickerController()
        }), UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in self.imagePicker.sourceType = .camera
            self.presentImagePickerController()
        }
            ), UIAlertAction(title: "Cancel", style: .cancel, handler: nil)]
        alertController.addAction(cheatControllerActions[0])
        alertController.addAction(cheatControllerActions[1])
        alertController.addAction(cheatControllerActions[2])
        return alertController
    }()
    
    let imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = false
        ip.sourceType = .photoLibrary
        return ip
    }()
    
    // MARK: CoreBluetooth
    
    var peripheralManager : CBPeripheralManager?
    
    let advertisingData : [String : Any] = [
        CBAdvertisementDataLocalNameKey : "Acelerometro iOS",
        CBAdvertisementDataServiceUUIDsKey : [CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F")]
    ]
    
     var didAddCharacteristic = false
    
    var characteristic = CBMutableCharacteristic(type: CBUUID.init(string: "BBD46F87-116D-4770-ADC6-3F8243878F57"), properties: .notify, value: nil, permissions: .readable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Seleccionar producto"
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        setupCollectionView()
        setupNavigationItem()
        setupImagePickerController()
        yOffsetNavigationBar = (navigationController?.navigationBar.frame.height)!
    }

    fileprivate func setupCollectionView() {
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .gray
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView!.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    fileprivate func setupNavigationItem() {
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: startAdvertisingSwitch), animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlertCheatController)), animated: false)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sentChosenProduct(_:)))
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.image.addGestureRecognizer(tapRecognizer)
        cell.image.tag = indexPath.item
        cell.image.image = imagenes[indexPath.item]
        cell.cancelOperationDelegate = self
        return cell
    }
    
    // Mark: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: (38 - yOffsetNavigationBar) / 2, left: 150 / 2, bottom: (38 - yOffsetNavigationBar) / 2, right: 150 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 150
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 150, height: view.frame.height - 38 - yOffsetNavigationBar)
    }
    
    // Mark: CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            startAdvertisingSwitch.isEnabled = true
            if didAddCharacteristic == false {
                let servicio = CBMutableService(type: CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F"), primary: true)
                servicio.characteristics = [characteristic]
                peripheralManager?.add(servicio)
                didAddCharacteristic = true
            }
        case .poweredOff:
            collectionView.backgroundColor = .gray
            startAdvertisingSwitch.isEnabled = false
            startAdvertisingSwitch.isOn = false
            peripheralManager?.removeAllServices()
            peripheralManager?.stopAdvertising()
        default:
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        collectionView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        collectionView.backgroundColor = .gray
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            get(Image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods
    
    func get(Image image: UIImage) {
        imagenes.append(image)
        collectionView.reloadData()
    }
    
    @objc func sentChosenProduct(_ sender: AnyObject?) {
        
        print(sender!.view.tag + 1)
        peripheralManager?.updateValue("\(sender!.view.tag+1)".data(using: .utf8)!, for: characteristic, onSubscribedCentrals: nil)
        
    }
    
    func cancelOperation() {
        print("Cancelando paso")
        peripheralManager?.updateValue("\(0)".data(using: .utf8)!, for: characteristic, onSubscribedCentrals: nil)
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
    }
    
    @objc func presentAlertCheatController() {
        if let popOverController = alertCheatController.popoverPresentationController {
            popOverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        self.present(alertCheatController, animated: true, completion: nil)
    }
    
    fileprivate func setupImagePickerController() {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overCurrentContext
    }
    
    @objc func startAdvertising(_ sender: UISwitch) {
         sender.isOn ? peripheralManager?.startAdvertising(advertisingData) : peripheralManager?.stopAdvertising()
    }
    
}

