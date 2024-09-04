//
//  NextButton.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 04.09.2024.
//

import UIKit
import SnapKit

class NextButton: UIButton {
    
    private let title = UILabel()
    private let price = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(title)
        addSubview(price)
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .white
        title.textAlignment = .center
        
        price.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        price.textColor = .yellow
        price.textAlignment = .right
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(price.snp.left).offset(-8)
        }
        
        price.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
        }
        
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
    }
    
    func setTitle(_ title: String?) {
        self.title.text = title
    }
    
    func setPrice(_ price: String?) {
        self.price.text = price
    }
}
