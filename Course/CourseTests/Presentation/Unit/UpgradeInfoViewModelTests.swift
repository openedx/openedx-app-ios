//
//  UpgradeViewModelTests.swift
//  CourseTests
//
//  Created by Vadim Kuznetsov on 28.05.24.
//

import XCTest
@testable import Core
import SwiftyMocky

final class UpgradeInfoViewModelTests: XCTestCase {
    enum UpgradeInfoViewModelTestsError: Error {
        case cantSetup
        case handlerIsNil
        case storeMockIsNil
        case interactorIsNil
        case routerIsNil
        case incorrectValuesReturned
    }
    
    var config: Config?
    var interactor: CourseUpgradeInteractorProtocolMock?
    var storeHandler: StoreKitHandlerProtocolMock?
    var helper: CourseUpgradeHelper?
    var handler: CourseUpgradeHandler?
    var router: BaseRouterMock?
    
    override func setUpWithError() throws {
        config = ConfigMock()
        interactor = CourseUpgradeInteractorProtocolMock()
        storeHandler = StoreKitHandlerProtocolMock()
        let analytics = CoreAnalyticsMock()
        
        router = BaseRouterMock()
        guard let config, let interactor, let storeHandler, let router else { throw UpgradeInfoViewModelTestsError.cantSetup }
        
        helper = CourseUpgradeHelper(config: config, analytics: analytics, router: router)
        
        guard let helper else { throw UpgradeInfoViewModelTestsError.cantSetup }
        handler = CourseUpgradeHandler(
            config: config,
            interactor: interactor,
            storeKitHandler: storeHandler,
            helper: helper
        )

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        config = nil
        interactor = nil
        storeHandler = nil
        helper = nil
        handler = nil
    }

    private func setupForSuccessFetch(sku: String, product: StoreProductInfo) throws {
        guard let storeHandler else { throw UpgradeInfoViewModelTestsError.storeMockIsNil }
        Given(storeHandler, .fetchProduct(sku: .value(sku), willReturn: product))
    }
    
    private func setupForFailureFetch(sku: String, error: Error) throws {
        guard let storeHandler else { throw UpgradeInfoViewModelTestsError.storeMockIsNil }
        Given(storeHandler, .fetchProduct(sku: .value(sku), willThrow: UpgradeError.productNotExist))
    }
    
    private func verifyFetchProduct() throws {
        guard let storeHandler else { throw UpgradeInfoViewModelTestsError.storeMockIsNil }
        Verify(storeHandler, 1, .fetchProduct(sku: .any))
    }
    
    private func viewModel(with handler: CourseUpgradeHandlerProtocol) throws -> UpgradeInfoViewModel {
        return UpgradeInfoViewModel(
            productName: "TestProduct",
            sku: "sku1",
            courseID: "course1",
            screen: .dashboard,
            handler: handler
        )
    }
    
    private func productInfo() -> StoreProductInfo {
        let price = NSDecimalNumber(decimal: 99)
        let localizedPrice: String? = "test localized price"
        let currencySymbol: String? = "$"

        return StoreProductInfo(
            price: price,
            localizedPrice: localizedPrice,
            currencySymbol: currencySymbol
        )
    }
    
    func testFetchProductSuccess() async throws {
        guard let handler else { throw UpgradeInfoViewModelTestsError.handlerIsNil }
        let viewModel = try self.viewModel(with: handler)

        let product = productInfo()
        try setupForSuccessFetch(sku: viewModel.sku, product: product)
        
        await viewModel.fetchProduct()
        try verifyFetchProduct()
        XCTAssertEqual(viewModel.product?.price, product.price)
        XCTAssertEqual(viewModel.product?.localizedPrice, product.localizedPrice)
        XCTAssertEqual(viewModel.product?.currencySymbol, product.currencySymbol)
    }
    
    func testFetchProductFailure() async throws {
        guard let handler else { throw UpgradeInfoViewModelTestsError.handlerIsNil }
        let viewModel = try self.viewModel(with: handler)

        
        let error = UpgradeError.productNotExist
        try setupForFailureFetch(sku: viewModel.sku, error: error)
        
        await viewModel.fetchProduct()
        try verifyFetchProduct()
        XCTAssertEqual(viewModel.error?.localizedDescription, error.localizedDescription)
    }
    
    typealias FlowData = (sku: String, product: StoreProductInfo, basketID: Int, symbol: String, receipt: String )
    private func prepareSuccessFlow(for sku: String, product: StoreProductInfo) throws -> FlowData {
        guard let interactor else { throw UpgradeInfoViewModelTestsError.interactorIsNil }
        
        let basket = UpgradeBasket(success: "true", basketID: 99)
        Given(interactor, .addBasket(sku: .value(sku), willReturn: basket))
        
        let checkoutBasket = CheckoutBasket(paymentPageURL: "paymentURL")
        Given(interactor, .checkoutBasket(basketID: .value(basket.basketID), willReturn: checkoutBasket))
        
        guard let storeHandler else { throw UpgradeInfoViewModelTestsError.storeMockIsNil }
        let response = StoreKitUpgradeResponse(success: true, receipt: "Some receipt here")
        Given(storeHandler, .purchaseProduct(.value(sku), willReturn: response))
        
        guard let receipt = response.receipt,
              let symbol = product.currencySymbol
        else { throw UpgradeInfoViewModelTestsError.incorrectValuesReturned }
        
        let checkout = FulfillCheckout(orderData: .init(status: "Success"))
        Given(interactor, .fulfillCheckout(
            basketID: .value(basket.basketID),
            price: .value(product.price),
            currencyCode: .value(symbol),
            receipt: .value(receipt),
            willReturn: checkout)
        )
        return (sku: sku, product: product, basketID: basket.basketID, symbol: symbol, receipt: receipt)
    }
    
    @MainActor 
    private func verifySuccessFlow(flowData: FlowData) throws {
        guard let interactor else { throw UpgradeInfoViewModelTestsError.interactorIsNil }
        Verify(interactor, 1, .addBasket(sku: .value(flowData.sku)))
        Verify(interactor, 1, .checkoutBasket(basketID: .value(flowData.basketID)))
        guard let storeHandler else { throw UpgradeInfoViewModelTestsError.storeMockIsNil }
        Verify(storeHandler, 1, .purchaseProduct(.value(flowData.sku)))
        Verify(
            interactor,
            1,
            .fulfillCheckout(
                basketID: .value(flowData.basketID),
                price: .value(flowData.product.price),
                currencyCode: .value(flowData.symbol),
                receipt: .value(flowData.receipt)
            )
        )
        // Check router flow
        guard let router else { throw UpgradeInfoViewModelTestsError.routerIsNil }
        Verify(router, 1, .hideUpgradeInfo(animated: .any))
        Verify(router, 1, .showUpgradeLoaderView(animated: .any))
        Verify(router, 1, .hideUpgradeLoaderView(animated: .any))
    }

    func testUpgradeHandlerSuccess() async throws {
        guard let handler else { throw UpgradeInfoViewModelTestsError.handlerIsNil }
        let viewModel = try self.viewModel(with: handler)

        let product = productInfo()
        viewModel.product = product
        let flowData = try prepareSuccessFlow(for: viewModel.sku, product: product)
        
        await viewModel.purchase()
        
        // Verify purchase backend processing
        try await verifySuccessFlow(flowData: flowData)
        
        var stateIsSuccess: Bool = false
        if case .complete = handler.state {
            stateIsSuccess = true
        }
        XCTAssertTrue(stateIsSuccess)
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.interactiveDismissDisabled, false)
    }
    
    func testUpgradeHelperSuccess() async throws {
        let helper = CourseUpgradeHelperProtocolMock()
        guard let config, let interactor, let storeHandler else { throw UpgradeInfoViewModelTestsError.cantSetup }
        let handler = CourseUpgradeHandler(config: config, interactor: interactor, storeKitHandler: storeHandler, helper: helper)
        
        let product = productInfo()
        let viewModel = try self.viewModel(with: handler)
        viewModel.product = product
        
        let _ = try prepareSuccessFlow(for: viewModel.sku, product: product)
        await viewModel.purchase()
        
        guard let localizedPrice = product.localizedPrice else { throw UpgradeInfoViewModelTestsError.incorrectValuesReturned }
        Verify(
            helper,
            1,
            .setData(courseID: .value(viewModel.courseID),
                     pacing: .value("pacing"),
                     blockID: .value(nil),
                     localizedCoursePrice: .value(localizedPrice),
                     screen: .value(viewModel.screen)
                    )
        )
    }
}
