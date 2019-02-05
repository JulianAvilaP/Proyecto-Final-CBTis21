//
//  Celda.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 1/29/19.
//  Copyright © 2019 Julian Avila Polanco. All rights reserved.
//

import UIKit

protocol CancelOperationProtocol {
    func cancelOperation()
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    var cancelOperationDelegate: CancelOperationProtocol!
    
    
    let image: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.backgroundColor = .green
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancelar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0.03393554688, alpha: 0.794921875)
        button.addTarget(self, action: #selector(callDelegateMethod), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func callDelegateMethod() {
        cancelOperationDelegate.cancelOperation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no se implemento coder")
    }
    
    func setupUI(){
        self.backgroundColor = .red
        
        self.addSubview(image)
        self.addSubview(cancelButton)
        
        image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

