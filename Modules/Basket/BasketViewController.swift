//
//  BasketViewController.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 03.09.2024.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController {
    
    // MARK: - Properties
    private var items: [CartItem] = .init()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.canCancelContentTouches = false
        tableView.delaysContentTouches = true
        tableView.isExclusiveTouch = true
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.allowsSelectionDuringEditing = false
        tableView.rowHeight = 104
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: -28, left: .zero, bottom: .zero, right: .zero)
        return tableView
    }()
    
    private lazy var nextButton = NextButton()
    
    // MARK: - Inherited Methods
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await fetchData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
        setupBarButtonItems()
        setupTitle()
    }
    
    private func setupViews() {
        [tableView, nextButton].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextButton.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(96)
        }
    }
}

extension BasketViewController {
    
    // MARK: - Private Methods
    private func setupTitle() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .heavy)
        ]
        
        title = "Корзина"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupBarButtonItems() {
        let backBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward")?.withTintColor(.black, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(backItemTapped)
        )
        
        let trashItem = UIBarButtonItem(
            image: UIImage(systemName: "trash")?.withTintColor(.black, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(trashItemTapped)
        )
        
        backBarButtonItem.tintColor = .black
        trashItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.rightBarButtonItem = trashItem
    }
}

// MARK: - UITableViewDelegate
extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (items.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

// MARK: - UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            fatalError("Unexpected cell type")
        }
        
        let item = items[indexPath.item]
        cell.configureCell(item: item)
        cell.setRoundedCorners(for: indexPath, numberOfRows: items.count)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProductCellHeader()
        headerView.configure(subtitle: "\(items.count) блюда")
        return headerView
    }
}

// MARK: - Cart
extension BasketViewController: Cart {
    func fetchCartItems() async throws -> [CartItem] {
        let itetItems = CartItem.fetchMocCartItems()
        
        return itetItems
    }
    
    func deleteCart() async throws {
        self.items = .init()
        self.tableView.reloadData()
        self.hideNextButton()
    }
    
    func updateCartItem(item: CartItem) async throws {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            self.items[index] = item
        }
        
        self.finaPrice()
    }
    
    func updateCartItem(items: [CartItem]) async throws {
        self.items = items
        self.tableView.reloadData()
    }
}

extension BasketViewController: ProductCellDelegate {
    func updatedCartItem(item: CartItem) {
        Task {
            try await self.updateCartItem(item: item)
        }
    }
}

// MARK: - Methods
extension BasketViewController {
    private func finaPrice() {
        var finalPrice: Int = .init()
        
        items.forEach {
            finalPrice += ($0.count * $0.price)
        }
        
        let price = String(finalPrice) + (items.first?.currency ?? "₽")
        self.nextButton.setPrice(price)
    }
    
    private func hideNextButton() {
        UIView.animate(withDuration: 0.3) {
            self.nextButton.snp.updateConstraints{
                $0.bottom.equalToSuperview().inset(-96)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(96)
            }
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func backItemTapped() {
        print( "backItemTapped")
    }
    
    @objc private func trashItemTapped() {
        print( "trashItemTapped")
        Task {
            try await deleteCart()
        }
    }
    
    private func fetchData() async {
        do {
            self.items = try await fetchCartItems()
            DispatchQueue.main.async {
                self.finaPrice()
                self.tableView.reloadData()
            }
        } catch {
            print("Can't get items")
        }
    }
}
