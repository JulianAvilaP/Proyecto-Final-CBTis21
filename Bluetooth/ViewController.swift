//
//  ViewController.swift
//  CoreBluetooth
//
//  Created by Julian Avila Polanco on 9/27/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit
import CoreMotion
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
   
    
    let motionManager = CMMotionManager()
    var timer = Timer()
    var peripheralManager : CBPeripheralManager?
    
    let datosDeAnuncio : [String : Any] = [
        CBAdvertisementDataLocalNameKey : "Acelerometro iOS",
        CBAdvertisementDataServiceUUIDsKey : [CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F")]
    ]
    var seAgregoCaracteristica = false
    
    var caracteristica = CBMutableCharacteristic(type: CBUUID.init(string: "BBD46F87-116D-4770-ADC6-3F8243878F57"), properties: .notify, value: nil, permissions: .readable)
    
    lazy var switchAnunciar: UISwitch = {
        let miSwitch = UISwitch()
        miSwitch.isEnabled = false
        miSwitch.onTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        miSwitch.addTarget(self, action: #selector(activarAnuncio(_:)), for: .valueChanged)
        miSwitch.translatesAutoresizingMaskIntoConstraints = false
        return miSwitch
    }()
    
    lazy var switchDatos: UISwitch = {
        let miSwitch = UISwitch()
        miSwitch.isEnabled = false
        miSwitch.onTintColor = .yellow
        miSwitch.addTarget(self, action: #selector(mandarDato(_:)), for: .valueChanged)
        miSwitch.translatesAutoresizingMaskIntoConstraints = false
        return miSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(switchAnunciar)
        view.addSubview(switchDatos)
        acomodarVistas()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        view.backgroundColor = .red
        motionManager.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(timeInterval: 1/10, target: self, selector: #selector(imprimirDatosAcelerometro), userInfo: nil, repeats: true)
    }
    
    @objc func imprimirDatosAcelerometro() {
        if let datosAcelerometro = motionManager.accelerometerData {
            //peripheralManager?.updateValue("\(Float(datosAcelerometro.acceleration.z))".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
            
        }
    }
    
    @objc func activarAnuncio(_ sender: UISwitch) {
        if sender.isOn {
            peripheralManager?.startAdvertising(datosDeAnuncio)
        } else {
            peripheralManager?.stopAdvertising()
        }
    }
    
    @objc func mandarDato(_ sender: UISwitch) {
        if sender.isOn {
            peripheralManager?.updateValue("1".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        } else {
            peripheralManager?.updateValue("0".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        }
    }
    
    func acomodarVistas() {
        switchAnunciar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchAnunciar.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    
        switchDatos.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchDatos.topAnchor.constraint(equalTo: switchAnunciar.topAnchor, constant: 40).isActive = true
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            switchDatos.isEnabled = true
            switchAnunciar.isEnabled = true
            if seAgregoCaracteristica == false {
                let servicio = CBMutableService(type: CBUUID.init(string: "43AB60E3-5BD1-481D-BCE0-3D35543E734F"), primary: true)
                servicio.characteristics = [caracteristica]
                peripheralManager?.add(servicio)
                seAgregoCaracteristica = true
            }
        case .poweredOff:
            switchDatos.isOn = false
            switchDatos.isEnabled = false
            switchAnunciar.isEnabled = false
            peripheralManager?.removeAllServices()
            peripheralManager?.stopAdvertising()
        default:
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        view.backgroundColor = .green
        switchDatos.isEnabled = true
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        view.backgroundColor = .red
        switchDatos.isOn = false
        switchDatos.isEnabled = false
    }

}


