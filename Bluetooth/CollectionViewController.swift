//
//  CollectionViewController.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 10/27/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit
import CoreBluetooth

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBPeripheralManagerDelegate, SeCancelaElPaso, CellCreation {
    
    
    // Mark: Modelo
    
    var imagenes = [#imageLiteral(resourceName: "tornillos.jpg")]
    
    // MARK: Vistas
    
    lazy var botonCancelar: UIButton = {
        let boton = UIButton()
        boton.setTitle("Cancelar", for: .normal)
        boton.tintColor = .green
        boton.titleLabel?.textColor = .black
        boton.tag = 40
        boton.addTarget(self, action: #selector(sentChosenProduct(_:)), for: .touchUpInside)
        return boton
    }()
    
    lazy var switchAnunciar: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.isEnabled = false
        toggle.addTarget(self, action: #selector(activarAnuncio(_:)), for: .valueChanged)
       return toggle
    }()
    
    // MARK: CoreBluetooth
    
    var peripheralManager : CBPeripheralManager?
    
    let datosDeAnuncio : [String : Any] = [
        CBAdvertisementDataLocalNameKey : "Acelerometro iOS",
        CBAdvertisementDataServiceUUIDsKey : [CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F")]
    ]
     var seAgregoCaracteristica = false
    
    var caracteristica = CBMutableCharacteristic(type: CBUUID.init(string: "BBD46F87-116D-4770-ADC6-3F8243878F57"), properties: .notify, value: nil, permissions: .readable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Elegir producto"
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        setupCollectionView()
        setupNavigationItem()

    }

    fileprivate func setupCollectionView() {
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .gray
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView!.register(Celda.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    fileprivate func setupNavigationItem() {
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: switchAnunciar), animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(añadirItem)), animated: false)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Celda
        let reconocerTap = UITapGestureRecognizer(target: self, action: #selector(sentChosenProduct(_:)))
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.imagen.addGestureRecognizer(reconocerTap)
        cell.imagen.tag = indexPath.item
        cell.imagen.image = imagenes[indexPath.item]
        //cell.boton.setTitle(nombres[indexPath.item], for: .normal)
        //cell.boton.addTarget(self, action: #selector(imprimirBotonPulsado(_:)), for: .touchUpInside)
        cell.cancelarPasoDelegate = self
        return cell
    }
    
    // Mark: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 70/2, left: 150 / 2, bottom: 70/2, right: 150 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 150
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 150, height: collectionView.frame.height - 70)
    }
    
    // Mark: CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            switchAnunciar.isEnabled = true
            if seAgregoCaracteristica == false {
                let servicio = CBMutableService(type: CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F"), primary: true)
                servicio.characteristics = [caracteristica]
                peripheralManager?.add(servicio)
                seAgregoCaracteristica = true
            }
        case .poweredOff:
            collectionView.backgroundColor = .gray
            switchAnunciar.isEnabled = false
            switchAnunciar.isOn = false
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
    
    // MARK: Methods
    
    @objc func añadirItem() {
        let vistaModal = ModalViewController()
        vistaModal.escogerImagenDelegate = self
        vistaModal.modalPresentationStyle = .overCurrentContext
        present(vistaModal, animated: false, completion: nil)
    }
    
    func get(Image imagen: UIImage) {
        imagenes.append(imagen)
        collectionView.reloadData()
    }
    
    @objc func sentChosenProduct(_ sender: AnyObject?) {
        
        print(sender!.view.tag + 1)
        peripheralManager?.updateValue("\(sender!.view.tag+1)".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        
    }
    
    func cancelarPaso() {
        print("Cancelando paso")
        peripheralManager?.updateValue("\(0)".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
    }
    
    @objc func activarAnuncio(_ sender: UISwitch) {
         sender.isOn ? peripheralManager?.startAdvertising(datosDeAnuncio) : peripheralManager?.stopAdvertising()
    }
    
}

