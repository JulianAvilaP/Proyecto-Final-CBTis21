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

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBPeripheralManagerDelegate {

    var peripheralManager : CBPeripheralManager?
    
    let datosDeAnuncio : [String : Any] = [
        CBAdvertisementDataLocalNameKey : "Acelerometro iOS",
        CBAdvertisementDataServiceUUIDsKey : [CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F")]
    ]
     var seAgregoCaracteristica = false
    
    var caracteristica = CBMutableCharacteristic(type: CBUUID.init(string: "BBD46F87-116D-4770-ADC6-3F8243878F57"), properties: .notify, value: nil, permissions: .readable)
    
   let nombres = ["Hola","Me","Llamo","Julian"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Elegir producto"
        collectionView.backgroundColor = .gray
        collectionView.showsHorizontalScrollIndicator = false
         self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(Celda.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return nombres.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Celda
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.boton.tag = indexPath.item
        cell.boton.setTitle(nombres[indexPath.item], for: .normal)
        cell.boton.addTarget(self, action: #selector(imprimirBotonPulsado(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 250 / 2, bottom: -50, right: 250 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 250, height: 200)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            //switchAnunciar.isEnabled = true
            peripheralManager?.startAdvertising(datosDeAnuncio)
            //collectionView.backgroundColor = .green
            if seAgregoCaracteristica == false {
                let servicio = CBMutableService(type: CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F"), primary: true)
                servicio.characteristics = [caracteristica]
                peripheralManager?.add(servicio)
                seAgregoCaracteristica = true
            }
        case .poweredOff:
            collectionView.backgroundColor = .gray
            //switchAnunciar.isEnabled = false
            peripheralManager?.removeAllServices()
            peripheralManager?.stopAdvertising()
        default:
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        collectionView.backgroundColor = .green
        //labelEstado.textColor = .green
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        collectionView.backgroundColor = .gray
       // labelEstado.text = "Desconectado"
       // labelEstado.textColor = .gray
    }
    
    @objc func imprimirBotonPulsado(_ sender: UIButton) {
        print(sender.tag)
        peripheralManager?.updateValue("\(sender.tag)".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        
    }
   

}

class Celda: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.text = "Prueba"
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    lazy var boton: UIButton = {
        let boton = UIButton()
        boton.setTitle("Click me", for: .normal)
        boton.titleLabel?.textColor = .black
        boton.backgroundColor = .red
        boton.translatesAutoresizingMaskIntoConstraints = false
        return boton
    }()
    
    
    
    // Hacemos la inicializacion de la celda utilizando un frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Llamamos a la funcion setupUI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no se implemento coder")
    }

    func setupUI(){
        self.backgroundColor = .red
        self.addSubview(boton)
        boton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        boton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        boton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        boton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    
    
}
