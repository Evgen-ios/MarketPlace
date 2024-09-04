//
//  CartItem.swift
//  MarketPlace
//
//  Created by Evgeniy Goncharov on 03.09.2024.
//

import Foundation

struct CartItem {
    let id: String
    let name: String
    var count: Int
    let price: Int
    let currency: String
    let imageUrl: String
    
    static func fetchMocCartItems() -> [CartItem] {
        var items: [CartItem] = .init()
        let mocData = ["Суп Том Ям с морепродуктами","Поке с индейкой и чуккой","Поке с тунцом, лососем, авокадо, чесноком","Блинчики с малиной и маскарпоне"]
        let images = ["https://habrastorage.org/webt/xw/5k/ir/xw5kir1cls2paqeh_iv9yr2tixa.png",
                      "https://habrastorage.org/webt/qn/qv/ka/qnqvkaf9jq6axifjho8hih6hmcm.png",
                      "https://habrastorage.org/webt/uh/i0/t_/uhi0t_atnwt-4jfwotamdwtry2y.png",
                      "https://habrastorage.org/webt/jq/ar/v9/jqarv9jdwldmhbyxq8iiyrtnwgq.png"]
        
        mocData.enumerated().forEach {
            let item = CartItem(id: $0.offset.formatted(), name: $0.element, count: 1, price: 100, currency: "₽", imageUrl: images[$0.offset])
            items.append(item)
        }
        
        return items
    }
}
