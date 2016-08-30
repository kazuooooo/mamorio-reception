//
//  DeliveryTests.swift
//  ReceptionKit
//
//  Created by Andy Cho on 2016-08-29.
//  Copyright © 2016 Andy Cho. All rights reserved.
//

import XCTest
import KIF
@testable import ReceptionKit

class DeliveryTests: KIFTestCase {

    var mockMessageSender = MockMessageSender()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        reset()
        mockMessageSender = mockOutMessageSender()
    }

    func testUPSDeliveryRequiresSignature() {
        tapDelivery()
        tapUPS()
        tapSignatureRequired()
        assertPleaseWaitMessageExists()
        assertMessage(.RequiresSignature(deliveryCompany: .UPS))

    }

    func testCanadaPostDeliveryDoesNotRequireSignature() {
        tapDelivery()
        tapCanadaPost()
        tapLeftAtReception()
        assertThankYouMessageExists()
        assertMessage(.LeftAtReception(deliveryCompany: .CanadaPost))
    }

    func testOtherCompanyOption() {
        tapDelivery()
        tapOther()
        tapLeftAtReception()
        assertThankYouMessageExists()
        assertMessage(.LeftAtReception(deliveryCompany: .Other))
    }

}

private extension DeliveryTests {

    // MARK: Helpers - Main page

    private func tapDelivery() {
        tester.tapViewWithAccessibilityLabel(Text.Delivery.accessibility())
    }

    // MARK: Helpers - Delivery companies

    private func tapUPS() {
        tester.tapViewWithAccessibilityLabel(DeliveryCompany.UPS.text())
    }

    private func tapCanadaPost() {
        tester.tapViewWithAccessibilityLabel(DeliveryCompany.CanadaPost.text())
    }

    private func tapOther() {
        tester.tapViewWithAccessibilityLabel(DeliveryCompany.Other.text())
    }

    // MARK: Helpers - Type of delivery

    private func tapSignatureRequired() {
        tester.tapViewWithAccessibilityLabel(Text.Signature.accessibility())
    }

    private func tapLeftAtReception() {
        tester.tapViewWithAccessibilityLabel(Text.LeftAtReception.accessibility())
    }

    // MARK: Helpers - Successfully sent message

    /// Check that we see the please wait screen
    private func assertPleaseWaitMessageExists() {
        tester.waitForViewWithAccessibilityLabel(Text.PleaseWait.accessibility())
        tester.waitForViewWithAccessibilityLabel(Text.PleaseWaitMessage.accessibility())
    }

    /// Check that we see the thank you screen
    private func assertThankYouMessageExists() {
        tester.waitForViewWithAccessibilityLabel(Text.ThankYou.accessibility())
        tester.waitForViewWithAccessibilityLabel(Text.NiceDay.accessibility())
    }

    /**
     Helper to check sent message

     - parameter sentMessage: The message that should have been sent
     */
    private func assertMessage(sentMessage: SlackMessage) {
        assertMessageSent(mockMessageSender, message: sentMessage)
    }
}