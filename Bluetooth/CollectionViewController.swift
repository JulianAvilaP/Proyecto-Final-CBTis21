//
//  CollectionViewController.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 10/27/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "El nimo es puto"
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(Celda.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Celda
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.boton.tag = indexPath.item
        cell.boton.addTarget(self, action: #selector(hacerAccion(_:)), for: .touchUpInside)
        
    
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
    // MARK: UICollectionViewDelegate

    @objc func hacerAccion(_ sender: UIButton) {
        print(sender.tag)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
        boton.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
        boton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30).isActive = true
        
    }
    
    
    
}
