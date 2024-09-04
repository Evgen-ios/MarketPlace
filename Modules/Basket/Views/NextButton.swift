//
//  NextButton.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 04.09.2024.
//

import UIKit
import SnapKit

class NextButton: UIView {
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Далее"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: .buttonYellow), for: .normal)
        button.setBackgroundImage(UIImage(color: .buttonYellow.withAlphaComponent(0.7)), for: .highlighted)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var contaner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        
        [price, title].forEach {
            self.button.addSubview($0)
        }
        
        contaner.addSubview(button)
        self.addSubview(contaner)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        contaner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(64)
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            
            $0.right.equalTo(price.snp.left).offset(-8)
        }
        
        price.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    func setTitle(_ title: String?) {
        self.title.text = title
    }
    
    func setPrice(_ price: String?) {
        self.price.text = price
    }
}
