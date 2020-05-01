//
//  CannyView.swift
//  Revamp
//
//  Created by Andrew on 5/1/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class CannyView: UIView, UITextFieldDelegate {

    var lowerBound: Int = 50
    var upperBound: Int = 150
    
    // MARK: - Lazy properties (calculated only if needed)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Canny Edge Detection"
        return nameLbl
    }()
    
    lazy var spacing1Lbl: UILabel = {
        let spacingLbl = UILabel()
        spacingLbl.textAlignment = .center
        spacingLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        spacingLbl.text = " - "
        return spacingLbl
    }()
    
    lazy var lowerTF: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "50"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validateLowerField(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var upperTF: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "150"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validateUpperField(_:)), for: .editingDidEnd)
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
        lowerTF.delegate = self
        upperTF.delegate = self
        setDoneToolBar(field: lowerTF)
        setDoneToolBar(field: upperTF)
        stackView1.addArrangedSubview(lowerTF)
        stackView1.addArrangedSubview(spacing1Lbl)
        stackView1.addArrangedSubview(upperTF)
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(stackView1)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Action functions
    @objc func validateLowerField(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            lowerBound = value
        } else {
            lowerBound = 50
        }
        sender.text = String(lowerBound)
        print("Lower: ", Int(lowerBound))
    }
    
    @objc func validateUpperField(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            upperBound = value
        } else {
            upperBound = 150
        }
        sender.text = String(upperBound)
        print("Upper: ", Int(upperBound))
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
    
    func setDoneToolBar(field: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar()

        doneToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        ]
        doneToolbar.sizeToFit()
        field.inputAccessoryView = doneToolbar
    }

}
