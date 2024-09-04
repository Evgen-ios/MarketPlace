//
//  StepperView.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 04.09.2024.
//

import UIKit
import SnapKit

protocol StepperViewDelegate: AnyObject {
    func currentValue(value: Int)
}

class StepperView: UIView {
    
    // MARK: - Properties
    weak var delegate: StepperViewDelegate?
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("–", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        button.addTarget(self, action: #selector(decreaseValue), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        button.addTarget(self, action: #selector(increaseValue), for: .touchUpInside)
        return button
    }()
    
    private var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.text = "1"
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        valueLabel.textColor = .black
        return valueLabel
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private var value: Int = 1 {
        didSet {
            valueLabel.text = "\(value)"
            delegate?.currentValue(value: value)
        }
    }
    
    // MARK: - Inherited Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    private func addSubviews() {
        
        [minusButton, valueLabel, plusButton].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}

extension StepperView {
    @objc private func decreaseValue() {
        if value > 1 {
            value -= 1
        }
    }
    
    @objc private func increaseValue() {
        
        if value < 99 {
            value += 1
        }
    }
    
    func configure(value: Int){
        self.value = value
    }
}
