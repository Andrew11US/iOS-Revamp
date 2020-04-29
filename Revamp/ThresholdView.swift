//
//  ThresholdView.swift
//  Revamp
//
//  Created by Andrew on 4/28/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

public class ThresholdView: UIView {
    
    var threshold: Double = 127
    
    // MARK: - Lazy properties (calculated only if needed)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
//        nameLbl.backgroundColor = .yellow
//        nameLbl.textColor = .black
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Threshold: 127"
        return nameLbl
    }()
    
    lazy var levelSlider: UISlider = {
        let levelSlider = UISlider()
        levelSlider.minimumValue = 0
        levelSlider.maximumValue = 255
        levelSlider.value = 127
        levelSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        return levelSlider
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
        addSubview(levelSlider)
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(levelSlider)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Action functions
    @objc func sliderChanged(_ sender: UISlider!) {
        threshold = Double(sender.value)
        nameLbl.text = "Threshold: " + "\(Int(threshold))"
        print("Threshold: ", Int(threshold))
    }
}
