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

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBPeripheralManagerDelegate, SeCancelaElPaso {
    
     func cancelarPaso() {
        print("Cancelando paso")
        peripheralManager?.updateValue("\(0)".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
    }
    
    let imagenes = [#imageLiteral(resourceName: "tornillos.jpg")]
    
    // MARK: Vistas
    
//    lazy var botonAgregarItem: UIButton = {
//        let boton = UIButton()
//        boton.buttonType = .
//
//    }()
    
    lazy var botonCancelar: UIButton = {
        let boton = UIButton()
        boton.setTitle("Cancelar", for: .normal)
        boton.tintColor = .green
        boton.titleLabel?.textColor = .black
        boton.tag = 40
        boton.addTarget(self, action: #selector(imprimirBotonPulsado(_:)), for: .touchUpInside)
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
    
   let nombres = ["Tornillos","Tuercas","Rondanas","Brocas"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Elegir producto"
        collectionView.backgroundColor = .gray
        collectionView.showsHorizontalScrollIndicator = false
         self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: switchAnunciar), animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(añadirItem)), animated: false)
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
        return imagenes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Celda
        let reconocerTap = UITapGestureRecognizer(target: self, action: #selector(imprimirBotonPulsado(_:)))
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 150 / 2, bottom: 5, right: 150 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 150, height: collectionView.frame.height - 70           )
    }
    
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
        //labelEstado.textColor = .green
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        collectionView.backgroundColor = .gray
       // labelEstado.text = "Desconectado"
       // labelEstado.textColor = .gray
    }
    
    // MARK: Metodos
    
    @objc func añadirItem() {
        print("Añadiendo item...")
        let vistaModal = ModalViewController()
        vistaModal.modalPresentationStyle = .overCurrentContext
        present(vistaModal, animated: false, completion: nil)
    }
    
    @objc func imprimirBotonPulsado(_ sender: AnyObject?) {
        
        print(sender!.view.tag)
        peripheralManager?.updateValue("\(sender!.view.tag+1)".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        
    }
    
    @objc func activarAnuncio(_ sender: UISwitch) {
        if sender.isOn {
            peripheralManager?.startAdvertising(datosDeAnuncio)
            //print("Prendido...")
        } else {
            peripheralManager?.stopAdvertising()
            //print("Apagado...")
        }
    }
    
   

}

 protocol SeCancelaElPaso {
    func cancelarPaso()
}

class Celda: UICollectionViewCell {
    
    var cancelarPasoDelegate: SeCancelaElPaso!
    
    
    let imagen: UIImageView = {
        let imagen = UIImageView()
        imagen.isUserInteractionEnabled = true
        imagen.backgroundColor = .green
        imagen.contentMode = .scaleAspectFill
        imagen.translatesAutoresizingMaskIntoConstraints = false
        return imagen
    }()
    
    lazy var botonCancelar: UIButton = {
        let boton = UIButton()
        boton.setTitle("Cancelar", for: .normal)
        boton.setTitleColor(.black, for: .normal)
        boton.backgroundColor = .orange
        boton.addTarget(self, action: #selector(llamarFuncionDelProtocolo), for: .touchUpInside)
        boton.translatesAutoresizingMaskIntoConstraints = false
       return boton
    }()
    
//    lazy var boton: UIButton = {
//        let boton = UIButton()
//        boton.setTitle("Click me", for: .normal)
//        boton.titleLabel?.textColor = .black
//        boton.backgroundColor = .red
//        boton.translatesAutoresizingMaskIntoConstraints = false
//        return boton
//    }()
    
    @objc func llamarFuncionDelProtocolo() {
        cancelarPasoDelegate.cancelarPaso()
    }
    
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
        
        //self.addSubview(boton)
        self.addSubview(imagen)
        self.addSubview(botonCancelar)
//        boton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        boton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        boton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        boton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        imagen.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imagen.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imagen.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imagen.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        botonCancelar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        botonCancelar.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        botonCancelar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        botonCancelar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    
}
