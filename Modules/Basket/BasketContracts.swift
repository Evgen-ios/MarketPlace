//
//  BasketContracts.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 03.09.2024.
//

import Foundation

protocol Cart {
    /**
     * Возвращает список всех элементов в корзине
     */
    func fetchCartItems() async throws -> [CartItem]

    /**
     * Удаляет корзину
     */
    func deleteCart() async throws

    /**
     * Обновляет элемент корзины
     */
    func updateCartItem(item: CartItem) async throws

    /**
     * Обновляет элементы корзины
     */
    func updateCartItem(items: [CartItem]) async throws
}

protocol ProductCellDelegate: AnyObject {
    /**
     * Обновляет элемент корзины
     */
    func updatedCartItem(item: CartItem)
}
