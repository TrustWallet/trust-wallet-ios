// Copyright DApps Platform Inc. All rights reserved.

import XCTest
@testable import IPOS

class AuthenticateUserCoordinatorTests: XCTestCase {

    func testStart() {
        let coordinator = AuthenticateUserCoordinator(navigationController: FakeNavigationController())

        coordinator.start()

        //XCTAssertTrue(coordinator.navigationController.presentedViewController is LockEnterPasscodeViewController)
    }
}
