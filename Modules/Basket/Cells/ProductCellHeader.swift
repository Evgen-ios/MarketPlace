//
//  ProductCellHeader.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 04.09.2024.
//

import UIKit
import SnapKit

final class ProductCellHeader: UIView {
    
    // MARK: - Properties
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Inherited Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        [subtitleLabel].forEach {
            self.addSubview($0)
        }
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        subtitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(-16)
        }
    }
}

extension ProductCellHeader {
    func configure(subtitle: String) {
        subtitleLabel.text = subtitle
    }
}
