//
//  ViewController.swift
//  Revamp
//
//  Created by Andrew on 3/26/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK: - Variables
    var imageScrollView: ImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(OpenCVWrapper.openCVVersion())
    }
    
    @IBAction func openBtnTapped(_ sender: UIButton) {
        if imageScrollView != nil {
            imageScrollView.removeFromSuperview()
        }
        setupImageScrollView()
        let image = UIImage(named: "IMG_7033")
        self.imageScrollView.set(image: image!)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        self.imageScrollView.set(image: OpenCVWrapper.makeGray(imageScrollView.baseImage.image!))
//        print(imageScrollView.baseImage.image?.histogram()?.red)
//        self.imageScrollView.set(image: (imageScrollView.baseImage.image?.MaxFilter(width: 500, height: 500))!)
    }
    
    func setupImageScrollView() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        view.sendSubviewToBack(imageScrollView)
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}

