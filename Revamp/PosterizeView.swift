//
//  PosterizeView.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class PosterizeView: UIView {

    var grayLevels: Int = 8
    
    // MARK: - Lazy properties (calculated only if needed)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Gray Levels: 8"
        return nameLbl
    }()
    
    lazy var levelSlider: UISlider = {
        let levelSlider = UISlider()
        levelSlider.minimumValue = 2
        levelSlider.maximumValue = 64
        levelSlider.value = 8
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
        grayLevels = Int(sender.value)
        
        nameLbl.text = "Gray Levels: " + "\(grayLevels)"
        print("Gray levels: ", grayLevels)
    }

}
