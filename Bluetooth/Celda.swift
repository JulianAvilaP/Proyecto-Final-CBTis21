//
//  Celda.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 1/29/19.
//  Copyright © 2019 Julian Avila Polanco. All rights reserved.
//

import UIKit

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

