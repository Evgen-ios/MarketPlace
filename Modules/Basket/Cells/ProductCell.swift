//
//  ProductCell.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 04.09.2024.
//

import UIKit
import Nuke

class ProductCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: ProductCellDelegate?
    private var item: CartItem?
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var infoContaner: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stepper: StepperView = {
        let stepper = StepperView()
        stepper.delegate = self
        return stepper
    }()
    
    private lazy var contaner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var customSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Inherited Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        price.text = .init()
        title.text = .init()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [title, price].forEach {
            infoContaner.addSubview($0)
        }
        
        [image, infoContaner, stepper, customSeparator].forEach {
            contaner.addSubview($0)
        }
        
        self.contentView.addSubview(contaner)
    }
    
    private func setupConstraints() {
        contaner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        infoContaner.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(image.snp.right).inset(-10)
            $0.right.equalTo(stepper.snp.left).inset(-8)
            $0.height.equalTo(54)
        }
        
        image.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.size.equalTo(82)
        }
        
        title.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        price.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        stepper.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(106)
            $0.height.equalTo(38)
        }
        
        customSeparator.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(infoContaner.snp.left)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(0.5)
        }
    }
}

extension ProductCell {
    
    func configureCell(item: CartItem) {
        self.item = item
        self.title.text = item.name
        self.price.text = String(item.price) + item.currency
        self.stepper.configure(value: item.count)
        
        Task {
            do {
                try await loadImage(url: item.imageUrl)
            } catch {
                image.image = UIImage(named: "placeholder")
                print("Failed to load image: \(error)")
            }
        }
    }
    
    func setRoundedCorners(for indexPath: IndexPath, numberOfRows: Int) {
        contaner.layer.cornerRadius = 0
        self.backgroundColor = .clear
        
        if indexPath.row == numberOfRows - 1 {
            contaner.layer.cornerRadius = 24
            contaner.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            contaner.clipsToBounds = true
            
            customSeparator.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                $0.left.equalTo(image.snp.left).inset(8)
                $0.right.equalToSuperview().inset(16)
                $0.height.equalTo(0.5)
            }
        }
    }
    
    private func loadImage(url: String ) async throws {
        guard let url = URL(string: url) else { return }
        let imageTask = ImagePipeline.shared.imageTask(with: url)
        image.image = try await imageTask.image
    }
}

extension ProductCell: StepperViewDelegate {
    func currentValue(value: Int) {
        self.item?.count = value
        guard let item else { return }
        delegate?.updatedCartItem(item: item)
    }
}
