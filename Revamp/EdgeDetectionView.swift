//
//  EdgeDetectionView.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class EdgeDetectionView: UIView {

    var type: Int = 0
    var border: Int = 2
    
    // MARK: - Lazy properties (calculated only if needed)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.baselineAdjustment = .alignCenters
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Edge Detection"
        return nameLbl
    }()
    
    lazy var directionLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.baselineAdjustment = .alignCenters
        nameLbl.textColor = .systemYellow
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "NW"
        return nameLbl
    }()
    
    lazy var nwBtn: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setTitle("NW", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nBtn: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setTitle("N", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var neBtn: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setTitle("NE", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var wBtn: UIButton = {
        let button = UIButton()
        button.tag = 3
        button.setTitle("W", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var eBtn: UIButton = {
        let button = UIButton()
        button.tag = 4
        button.setTitle("E", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var swBtn: UIButton = {
        let button = UIButton()
        button.tag = 5
        button.setTitle("SW", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var sBtn: UIButton = {
        let button = UIButton()
        button.tag = 6
        button.setTitle("S", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var seBtn: UIButton = {
        let button = UIButton()
        button.tag = 7
        button.setTitle("SE", for: .normal)
        button.addTarget(self, action: #selector(typeChanged(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var borderSggment: UISegmentedControl = {
        let types = ["Isolated", "Reflect", "Replicate"]
        let segment = UISegmentedControl(items: types)
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(borderChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    // MARK: - View setup stuff
    private func setupView() {
        backgroundColor = .systemBackground
        
        stackView1.addArrangedSubview(nwBtn)
        stackView1.addArrangedSubview(nBtn)
        stackView1.addArrangedSubview(neBtn)

        stackView2.addArrangedSubview(wBtn)
        stackView2.addArrangedSubview(directionLbl)
        stackView2.addArrangedSubview(eBtn)
        
        stackView3.addArrangedSubview(swBtn)
        stackView3.addArrangedSubview(sBtn)
        stackView3.addArrangedSubview(seBtn)
        
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(stackView3)
        stackView.addArrangedSubview(borderSggment)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Action functions
    @objc func typeChanged(_ sender: UIButton!) {
        type = sender.tag
        directionLbl.text = sender.titleLabel?.text!
        print("Type: ", type)
    }
    
    @objc func borderChanged(_ sender: UISegmentedControl!) {
        if sender.selectedSegmentIndex == 0 {
            border = 16
        } else if sender.selectedSegmentIndex == 1 {
            border = 2
        } else {
            border = 1
        }
        print("Border: ", sender.selectedSegmentIndex)
    }

}
