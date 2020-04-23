//
//  ViewController.swift
//  Revamp
//
//  Created by Andrew on 3/26/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var imageScrollView: ImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(OpenCVWrapper.openCVVersion())
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        view.sendSubviewToBack(imageScrollView)
        setupImageScrollView()
        
//        let imagePath = Bundle.main.path(forResource: "autumn", ofType: "jpg")!
        let image = UIImage(named: "IMG_7033")
        
        self.imageScrollView.set(image: image!)
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}

