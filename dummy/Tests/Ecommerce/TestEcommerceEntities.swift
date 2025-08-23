

import XCTest
@testable import PSATracker

class TestEcommerceEntities: XCTestCase {
    func testBuildsCartEntity() {
        let cart = CartEntity(
            totalValue: 1000,
            currency: "USD",
            cartId: "id"
        )
        let entity = cart.entity
        
        XCTAssertEqual(ecommerceCartSchema, entity.schema)
        XCTAssertEqual("id", entity.data["cart_id"] as? String)
        XCTAssertEqual("USD", entity.data["currency"] as? String)
        XCTAssertEqual(1000, entity.data["total_value"] as? Decimal)
    }
    
    func testBuildsProductEntity() {
        let product = ProductEntity(
            id: "id",
            category: "category",
            currency: "GBP",
            price: 123.45,
            listPrice: 130,
            name: "name",
            quantity: 1,
            size: "small",
            variant: "cerise",
            brand: "snowplow",
            inventoryStatus: "in_stock",
            position: 7,
            creativeId: "creative"
        )
        let entity = product.entity
        
        XCTAssertEqual(ecommerceProductSchema, entity.schema)
        XCTAssertEqual("id", entity.data["id"] as? String)
        XCTAssertEqual("category", entity.data["category"] as? String)
        XCTAssertEqual("GBP", entity.data["currency"] as? String)
        XCTAssertEqual(123.45, entity.data["price"] as? Decimal)
        XCTAssertEqual(130, entity.data["list_price"] as? Decimal)
        XCTAssertEqual("name", entity.data["name"] as? String)
        XCTAssertEqual(1, entity.data["quantity"] as? Int)
        XCTAssertEqual("small", entity.data["size"] as? String)
        XCTAssertEqual("cerise", entity.data["variant"] as? String)
        XCTAssertEqual("snowplow", entity.data["brand"] as? String)
        XCTAssertEqual("in_stock", entity.data["inventory_status"] as? String)
        XCTAssertEqual(7, entity.data["position"] as? Int)
        XCTAssertEqual("creative", entity.data["creative_id"] as? String)
    }
    
    func testBuildsPromotionEntity() {
        let promotion = PromotionEntity(
            id: "id",
            name: "name",
            productIds: ["product1", "product2", "product3"],
            position: 5,
            creativeId: "creative",
            type: "animated",
            slot: "sidebar"
        )
        let entity = promotion.entity
        
        XCTAssertEqual(ecommercePromotionSchema, entity.schema)
        XCTAssertEqual("id", entity.data["id"] as? String)
        XCTAssertEqual("name", entity.data["name"] as? String)
        XCTAssertEqual(["product1", "product2", "product3"], entity.data["product_ids"] as? [String])
        XCTAssertEqual(5, entity.data["position"] as? Int)
        XCTAssertEqual("creative", entity.data["creative_id"] as? String)
        XCTAssertEqual("animated", entity.data["type"] as? String)
        XCTAssertEqual("sidebar", entity.data["slot"] as? String)
    }
}
