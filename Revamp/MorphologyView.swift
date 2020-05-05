//
//  MorphologyView.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class MorphologyView: UIView {

    var operation: Int = 0
    var element: Int = 0
    var iterations : Int = 1
    var border: Int = 2
    
    // MARK: - Lazy properties (calculated only when first time is used)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.baselineAdjustment = .alignCenters
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Morphology Operations"
        return nameLbl
    }()
    
    lazy var iterationsLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.baselineAdjustment = .alignCenters
        nameLbl.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        nameLbl.text = "Iterations: 1"
        return nameLbl
    }()
    
    lazy var operationSggment: UISegmentedControl = {
        let types = ["Erode", "Dilate", "Open", "Close"]
        let segment = UISegmentedControl(items: types)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(operationChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var elementSggment: UISegmentedControl = {
        let types = ["Rectangle", "Cross", "Ellipse"]
        let segment = UISegmentedControl(items: types)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(elementChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var iterationsSlider: UISlider = {
        let levelSlider = UISlider()
        levelSlider.minimumValue = 1
        levelSlider.maximumValue = 100
        levelSlider.value = 1
        levelSlider.addTarget(self, action: #selector(iterationsChanged(_:)), for: .valueChanged)
        return levelSlider
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
        stackView.addArrangedSubview(operationSggment)
        stackView.addArrangedSubview(elementSggment)
        stackView.addArrangedSubview(iterationsLbl)
        stackView.addArrangedSubview(iterationsSlider)
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
    @objc func operationChanged(_ sender: UISegmentedControl!) {
        operation = sender.selectedSegmentIndex
        print("Operation: ", sender.selectedSegmentIndex)
    }
    
    @objc func elementChanged(_ sender: UISegmentedControl!) {
        element = sender.selectedSegmentIndex
        print("Element: ", sender.selectedSegmentIndex)
    }
    
    @objc func iterationsChanged(_ sender: UISlider!) {
        iterations = Int(sender.value)
        iterationsLbl.text = "Iterations: " + "\(iterations)"
        print("Iterations: ", iterations)
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
