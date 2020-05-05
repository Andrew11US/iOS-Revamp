//
//  PrewittView.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class PrewittView: UIView {

    var type: Int = 0
    var border: Int = 2
    
    // MARK: - Lazy properties (calculated only when first time is used)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.baselineAdjustment = .alignCenters
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Prewitt Operator"
        return nameLbl
    }()
    
    lazy var typeSggment: UISegmentedControl = {
        let types = ["Horizontal", "Vertical"]
        let segment = UISegmentedControl(items: types)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(typeChanged(_:)), for: .valueChanged)
        return segment
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
    
    // MARK: - View setup
    private func setupView() {
        backgroundColor = .systemBackground
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(typeSggment)
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
    @objc func typeChanged(_ sender: UISegmentedControl!) {
        if sender.selectedSegmentIndex == 0 {
            type = 0
        } else {
            type = 1
        }
        print("Type: ", sender.selectedSegmentIndex)
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
