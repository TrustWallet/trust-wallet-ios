// Copyright SIX DAY LLC. All rights reserved.

import XCTest
import BigInt
@testable import Trust

class SendViewModelTest: XCTestCase {
    var sendViewModel = SendViewModel(transferType: .ether(destination: .none), config: .make(), storage: FakeTokensDataStore(), balance: Balance(value: BigInt(0.998544373 * pow(10, 18))))
    var decimalFormatter = DecimalFormatter()
    override func setUp() {
        sendViewModel.amount = "198212312.123123"
        super.setUp()
    }
    func testPairRateRepresantetio() {
        let expectedFiatResult = sendViewModel.stringFormatter.currency(with: 128.9, and: sendViewModel.config.currency.rawValue)
        sendViewModel.pairRate = 128.9
        let fiatRepresentation = sendViewModel.pairRateRepresantetion()
        XCTAssertEqual("~ \(expectedFiatResult) USD", fiatRepresentation)
        let expectedCryptoResult = sendViewModel.stringFormatter.token(with: 298981.983212, and: sendViewModel.decimals)
        sendViewModel.pairRate = 298981.983212
        sendViewModel.currentPair = sendViewModel.currentPair.swapPair()
        let cryptoRepresentation = sendViewModel.pairRateRepresantetion()
        XCTAssertEqual("~ \(expectedCryptoResult) ETH", cryptoRepresentation)
    }
    func testUpdatePairRate() {
        XCTAssertEqual(0.0, sendViewModel.pairRate)
        sendViewModel.updatePaitRate(with: 1.8, and: 300.2)
        XCTAssertEqual(540.36, sendViewModel.pairRate)
        sendViewModel.currentPair = sendViewModel.currentPair.swapPair()
        sendViewModel.updatePaitRate(with: 24.3, and: 967)
        XCTAssertEqual(sendViewModel.pairRate.doubleValue, 39.794238683127, accuracy: 0.000000000001)
    }
    func testAmountUpdate() {
        XCTAssertEqual("198212312.123123", sendViewModel.amount)
        sendViewModel.updateAmount(with: "1.245")
        XCTAssertEqual("1.245", sendViewModel.amount)
    }
    func testRate() {
        let expectedFiatResult = sendViewModel.stringFormatter.currency(with: 298.124453, and: sendViewModel.config.currency.rawValue)
        sendViewModel.pairRate = 298.124453
        _ = sendViewModel.pairRateRepresantetion()
        XCTAssertEqual(expectedFiatResult, sendViewModel.rate)
        let expectedCryptoResult = sendViewModel.stringFormatter.token(with: 12.53453, and: sendViewModel.decimals)
        sendViewModel.pairRate = 12.53453
        sendViewModel.currentPair = sendViewModel.currentPair.swapPair()
        _ = sendViewModel.pairRateRepresantetion()
        XCTAssertEqual(expectedCryptoResult, sendViewModel.rate)
    }
    func testAmount() {
        XCTAssertEqual("198212312.123123", sendViewModel.amount)
    }
    func testDecimals() {
        XCTAssertEqual(18, sendViewModel.decimals)
    }
    func testMaxEther() {
        XCTAssertEqual("0.998544373", sendViewModel.sendMaxAmount())
    }
    func testMaxEtherUSD() {
        if sendViewModel.currentPair.left == sendViewModel.symbol {
            sendViewModel.currentPair = sendViewModel.currentPair.swapPair()
        }
        XCTAssertEqual("\(0.998544373 * 947.102)", sendViewModel.sendMaxAmount())
    }
}
