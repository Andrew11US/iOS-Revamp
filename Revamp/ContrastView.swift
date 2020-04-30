//
//  ContrastView.swift
//  Revamp
//
//  Created by Andrew on 4/30/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class ContrastView: UIView, UITextFieldDelegate {
    
    var fromMin: Int = 50
    var fromMax: Int = 150
    var toMin: Int = 0
    var toMax: Int = 255
    
    // MARK: - Lazy properties (calculated only if needed)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Histogram Stretching"
        return nameLbl
    }()
    
    lazy var spacing1Lbl: UILabel = {
        let spacingLbl = UILabel()
        spacingLbl.textAlignment = .center
        spacingLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        spacingLbl.text = " - "
        return spacingLbl
    }()
    
    lazy var spacing2Lbl: UILabel = {
        let spacingLbl = UILabel()
        spacingLbl.textAlignment = .center
        spacingLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        spacingLbl.text = " - "
        return spacingLbl
    }()
    
    lazy var fromMinTF: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "50"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numbersAndPunctuation
        field.addTarget(self, action: #selector(validateFromMinField(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var fromMaxTF: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "150"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numbersAndPunctuation
        field.addTarget(self, action: #selector(validateFromMaxField(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var toMinTF: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "0"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numbersAndPunctuation
        field.addTarget(self, action: #selector(validateToMinField(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var toMaxTF: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "255"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numbersAndPunctuation
        field.addTarget(self, action: #selector(validateToMaxField(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
        hideKeyboardWhenTappedAround()
        fromMinTF.delegate = self
        fromMaxTF.delegate = self
        toMinTF.delegate = self
        toMaxTF.delegate = self
        stackView1.addArrangedSubview(fromMinTF)
        stackView1.addArrangedSubview(spacing1Lbl)
        stackView1.addArrangedSubview(fromMaxTF)
        stackView2.addArrangedSubview(toMinTF)
        stackView2.addArrangedSubview(spacing2Lbl)
        stackView2.addArrangedSubview(toMaxTF)
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Action functions
    @objc func validateFromMinField(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            fromMin = value
        } else {
            fromMin = 50
        }
        sender.text = String(fromMin)
        print("Min: ", Int(fromMin))
    }
    
    @objc func validateFromMaxField(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            fromMax = value
        } else {
            fromMax = 150
        }
        sender.text = String(fromMax)
        print("Min: ", Int(fromMax))
    }
    
    @objc func validateToMinField(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            toMin = value
        } else {
            toMin = 0
        }
        sender.text = String(toMin)
        print("Min: ", Int(toMin))
    }
    
    @objc func validateToMaxField(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            toMax = value
        } else {
            toMax = 255
        }
        sender.text = String(toMax)
        print("Min: ", Int(toMax))
    }
    
    // MARK: - Keyboard handling
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
}
