//
//  MaskView.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class MaskView: UIView, UITextFieldDelegate {
    
    var kernel: [Int] = [1,1,1, 1,1,1, 1,1,1]
    var divisor: Int = 9
    
    // MARK: - Lazy properties (calculated only if needed)
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        nameLbl.text = "Custom Mask 3x3"
        return nameLbl
    }()
    
    lazy var divLbl: UILabel = {
           let nameLbl = UILabel()
           nameLbl.textAlignment = .center
           nameLbl.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
           nameLbl.text = "Divisor: 9"
           return nameLbl
       }()
    
    lazy var mask0_0: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate0_0Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask0_1: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate0_1Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask0_2: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate0_2Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask1_0: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate1_0Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask1_1: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate1_1Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask1_2: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate1_2Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask2_0: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate2_0Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask2_1: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate2_1Field(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var mask2_2: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        field.text = "1"
        field.clearsOnBeginEditing = true
        field.returnKeyType = .done
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(validate2_2Field(_:)), for: .editingDidEnd)
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
        hideKeyboardWhenTappedAround()
        
        mask0_0.delegate = self
        mask0_1.delegate = self
        mask0_2.delegate = self
        mask1_0.delegate = self
        mask1_1.delegate = self
        mask1_2.delegate = self
        mask2_0.delegate = self
        mask2_1.delegate = self
        mask2_2.delegate = self
        
        setDoneToolBar(field: mask0_0)
        setDoneToolBar(field: mask0_1)
        setDoneToolBar(field: mask0_2)
        setDoneToolBar(field: mask1_0)
        setDoneToolBar(field: mask1_1)
        setDoneToolBar(field: mask1_2)
        setDoneToolBar(field: mask2_0)
        setDoneToolBar(field: mask2_1)
        setDoneToolBar(field: mask2_2)
        
        stackView1.addArrangedSubview(mask0_0)
        stackView1.addArrangedSubview(mask0_1)
        stackView1.addArrangedSubview(mask0_2)
        stackView2.addArrangedSubview(mask1_0)
        stackView2.addArrangedSubview(mask1_1)
        stackView2.addArrangedSubview(mask1_2)
        stackView3.addArrangedSubview(mask2_0)
        stackView3.addArrangedSubview(mask2_1)
        stackView3.addArrangedSubview(mask2_2)
        
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(stackView3)
        stackView.addArrangedSubview(divLbl)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Action functions
    @objc func validate0_0Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[0] = value
        } else {
            kernel[0] = 1
        }
        sender.text = String(kernel[0])
        calculateDivisor()
    }
    
    @objc func validate0_1Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[1] = value
        } else {
            kernel[1] = 1
        }
        sender.text = String(kernel[1])
        calculateDivisor()
    }
    
    @objc func validate0_2Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[2] = value
        } else {
            kernel[2] = 1
        }
        sender.text = String(kernel[2])
        calculateDivisor()
    }
    
    @objc func validate1_0Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[3] = value
        } else {
            kernel[3] = 1
        }
        sender.text = String(kernel[3])
        calculateDivisor()
    }
    
    @objc func validate1_1Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[4] = value
        } else {
            kernel[4] = 1
        }
        sender.text = String(kernel[4])
        calculateDivisor()
    }
    
    @objc func validate1_2Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[5] = value
        } else {
            kernel[5] = 1
        }
        sender.text = String(kernel[5])
        calculateDivisor()
    }
    
    @objc func validate2_0Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[6] = value
        } else {
            kernel[6] = 1
        }
        sender.text = String(kernel[6])
        calculateDivisor()
    }
    
    @objc func validate2_1Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[7] = value
        } else {
            kernel[7] = 1
        }
        sender.text = String(kernel[7])
        calculateDivisor()
    }
    
    @objc func validate2_2Field(_ sender: UITextField!) {
        if let txt = sender.text?.trimmingCharacters(in: .whitespaces), let value = Int(txt)  {
            kernel[8] = value
        } else {
            kernel[8] = 1
        }
        sender.text = String(kernel[8])
        calculateDivisor()
    }
    
    private func calculateDivisor() {
        var sum = 0
        for item in kernel {
            sum += item
        }
        divisor = max(sum, 1);
        divLbl.text = "Divisor: " + "\(divisor)"
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
