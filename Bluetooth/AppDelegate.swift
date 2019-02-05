//
//  AppDelegate.swift
//  CoreBluetooth
//
//  Created by Julian Avila Polanco on 9/27/18.
//  Copyright © 2018 Julian Avila Polanco. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let layout = UICollectionViewFlowLayout()
        let vistaDeNavegacion = UINavigationController(rootViewController: CollectionViewController(collectionViewLayout: layout))
        layout.scrollDirection = .horizontal
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //window?.rootViewController = ViewController()
        window?.rootViewController = vistaDeNavegacion
        return true
    }

}

