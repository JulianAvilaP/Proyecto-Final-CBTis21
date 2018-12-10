//
//  ModalViewController.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 12/9/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    lazy var botonDismiss: UIButton = {
        let boton = UIButton()
        boton.setTitle("Dismiss", for: .normal)
        boton.setTitleColor(.white, for: .normal)
        boton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        boton.translatesAutoresizingMaskIntoConstraints = false
        return boton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        self.view.addSubview(botonDismiss)
        acomodarVistas()
    }
    
    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    func acomodarVistas() {
        botonDismiss.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        botonDismiss.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
