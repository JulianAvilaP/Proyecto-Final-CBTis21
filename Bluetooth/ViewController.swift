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
    var ultimoDatoEnviado: UInt8 = 0
    
    var caracteristica = CBMutableCharacteristic(type: CBUUID.init(string: "BBD46F87-116D-4770-ADC6-3F8243878F57"), properties: .notify, value: nil, permissions: .readable)
    
    lazy var switchAnunciar: UISwitch = {
        let miSwitch = UISwitch()
        miSwitch.isEnabled = false
        miSwitch.onTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        miSwitch.addTarget(self, action: #selector(activarAnuncio(_:)), for: .valueChanged)
        miSwitch.translatesAutoresizingMaskIntoConstraints = false
        return miSwitch
    }()
    
    lazy var switchEditarPocision: UISwitch = {
       let miSwitch = UISwitch()
        miSwitch.isEnabled = true
        miSwitch.isOn = true
        miSwitch.translatesAutoresizingMaskIntoConstraints = false
        return miSwitch
    }()
    
    let containerView: UIView = {
       let miVista = UIView()
        miVista.backgroundColor = .blue
        miVista.translatesAutoresizingMaskIntoConstraints = false
        return miVista
    }()
    
    lazy var botonMoverDerecha: UIButton = {
       let miBoton = UIButton()
        miBoton.tag = 1
        miBoton.setTitle("Derecha", for: .normal)
        miBoton.addTarget(self, action: #selector(moverMotor(_:)), for: .touchDown)
        miBoton.addTarget(self, action: #selector(pararMotor), for: .touchUpInside)
        miBoton.addTarget(self, action: #selector(pararMotor), for: .touchUpOutside)
        miBoton.translatesAutoresizingMaskIntoConstraints = false
        return miBoton
    }()
    
    lazy var botonMoverIzquierda: UIButton = {
        let miBoton = UIButton()
        miBoton.tag = 2
        miBoton.setTitle("Izquierda", for: .normal)
        miBoton.addTarget(self, action: #selector(moverMotor(_:)), for: .touchDown)
        miBoton.addTarget(self, action: #selector(pararMotor), for: .touchUpInside)
        miBoton.addTarget(self, action: #selector(pararMotor), for: .touchUpOutside)
        miBoton.translatesAutoresizingMaskIntoConstraints = false
        return miBoton
    }()
    
    let labelEstado: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Desconectado"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(switchAnunciar)
        view.addSubview(labelEstado)
        view.addSubview(containerView)
        view.addSubview(botonMoverDerecha)
        view.addSubview(botonMoverIzquierda)
        view.addSubview(switchEditarPocision)
        acomodarVistas()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        view.backgroundColor = .white
        motionManager.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(timeInterval: 1/10, target: self, selector: #selector(imprimirDatosAcelerometro), userInfo: nil, repeats: true)
    }
    
    @objc func moverMotor(_ sender: UIButton) {
        if sender.tag == 1 {
             peripheralManager?.updateValue("1".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        }
        if sender.tag == 2 {
             peripheralManager?.updateValue("2".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
        }
    }
    
    @objc func pararMotor() {
         peripheralManager?.updateValue("0".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
    }
    
    @objc func imprimirDatosAcelerometro() {
        if let datosAcelerometro = motionManager.accelerometerData {
            //peripheralManager?.updateValue("\(Float(datosAcelerometro.acceleration.z))".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
            if switchEditarPocision.isOn {
            if datosAcelerometro.acceleration.x > 0.45 {
                if ultimoDatoEnviado != 1 {
                 peripheralManager?.updateValue("1".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
                ultimoDatoEnviado = 1
                }
            } else if datosAcelerometro.acceleration.x < -0.45 {
                if ultimoDatoEnviado != 2 {
                 peripheralManager?.updateValue("2".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
                ultimoDatoEnviado = 2
                }
            } else {
                if ultimoDatoEnviado != 0 {
                 peripheralManager?.updateValue("0".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
                ultimoDatoEnviado = 0
                }
            }
            
            } else {
                if ultimoDatoEnviado != 0 {
                    peripheralManager?.updateValue("0".data(using: .utf8)!, for: caracteristica, onSubscribedCentrals: nil)
                    ultimoDatoEnviado = 0
                }
            }
        }
    }
    
    @objc func activarAnuncio(_ sender: UISwitch) {
        if sender.isOn {
            peripheralManager?.startAdvertising(datosDeAnuncio)
        } else {
            peripheralManager?.stopAdvertising()
        }
    }
    
    func acomodarVistas() {
        switchAnunciar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchAnunciar.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    
        labelEstado.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelEstado.topAnchor.constraint(equalTo: switchAnunciar.bottomAnchor, constant: 50).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        botonMoverIzquierda.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        botonMoverIzquierda.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/2).isActive = true
        botonMoverIzquierda.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        botonMoverIzquierda.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        botonMoverDerecha.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        botonMoverDerecha.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/2).isActive = true
        botonMoverDerecha.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        botonMoverDerecha.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        switchEditarPocision.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchEditarPocision.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 70).isActive = true
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
            switchAnunciar.isEnabled = false
            peripheralManager?.removeAllServices()
            peripheralManager?.stopAdvertising()
        default:
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        labelEstado.text = "Conectado"
        labelEstado.textColor = .green
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        labelEstado.text = "Desconectado"
        labelEstado.textColor = .gray
    }

}


