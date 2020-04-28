//
//  ResetPINViewControllerTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

@available(iOS 13.0, *)
class ResetPINViewControllerTests: XCTestCase {

    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: ResetPINViewControllerKey.navTitle)
    let resetTitle = CotterStrings.instance.getText(for: ResetPINViewControllerKey.title)
    let resetOpeningSub = CotterStrings.instance.getText(for: ResetPINViewControllerKey.subtitle)
    let resetFailSub = CotterStrings.instance.getText(for: ResetPINViewControllerKey.resetFailSub)
    let resendEmailText = CotterStrings.instance.getText(for: ResetPINViewControllerKey.resendEmail)
    
    // MARK: - VC Color Definitions
    let primaryColor = Config.instance.colors.primary
    let accentColor = Config.instance.colors.accent
    let dangerColor = Config.instance.colors.danger
    
    let presenter = ResetPINViewPresenterMock()
    
    func makeSUT(actualPresenter: Bool = false) -> ResetPINViewController {
        let storyboard = UIStoryboard(name: "Transaction", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "ResetPINViewController") as! ResetPINViewController
        if !actualPresenter {
            sut.presenter = presenter
        }
        sut.loadViewIfNeeded()
        return sut
    }

    func setupProps() -> ResetPINViewProps {
        return ResetPINViewProps(
            navTitle: navTitle,
            title: resetTitle,
            resetOpeningSub: resetOpeningSub,
            resetFailSub: resetFailSub,
            resendEmail: resendEmailText,
            primaryColor: primaryColor,
            accentColor: accentColor,
            dangerColor: dangerColor
        )
    }
    
    func testViewDidAppearCallsPresenter() {
        let sut = makeSUT()
        
        sut.viewDidAppear(true)
        
        expect(self.presenter.onViewAppearCalled).to(beTrue())
    }

    func testViewDidLoadCallsPresenter() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        expect(self.presenter.onViewLoadCalled).to(beTrue())
    }

    func testClickResendEmailCallsPresenter() {
        let sut = makeSUT()
        
        sut.onClickResendEmail(.init())
        
        expect(self.presenter.clickedResendEmailCalled).to(beTrue())
    }
    
    func testRenderWithUserInfo() {
        let testUserInfo = UserInfo(name: "TestName", sendingMethod: "EMAIL", sendingDestination: "test@gmail.com")
        let maskedSendingDestination = testUserInfo.sendingDestination.maskContactInfo(method: testUserInfo.sendingMethod)
        Config.instance.userInfo = testUserInfo
        let props = setupProps()
        
        let sut = makeSUT()
        
        sut.render(props)
        
        expect(sut.navigationItem.title).to(match(navTitle))
        expect(sut.resetPinTitle.text).to(match(resetTitle))
        expect(sut.resetPinError.textColor).to(equal(dangerColor))
        expect(sut.resetPinSubtitle.text).to(match("\(resetOpeningSub) \(maskedSendingDestination)"))
        expect(sut.resendEmailButton.title(for: .normal)).to(match(resendEmailText))
        expect(sut.resendEmailButton.titleColor(for: .normal)).to(equal(primaryColor))
    }
    
    func testRenderWithNoUserInfo() {
        Config.instance.userInfo = nil
        let props = setupProps()
        
        let sut = makeSUT()
        
        sut.render(props)
        
        expect(sut.navigationItem.title).to(match(navTitle))
        expect(sut.resetPinTitle.text).to(match(resetTitle))
        expect(sut.resetPinError.textColor).to(equal(dangerColor))
        expect(sut.resetPinSubtitle.text).to(match(resetFailSub))
        expect(sut.resendEmailButton.isEnabled).to(beFalse())
    }
    
    func testToggleErrorMsg() {
        let sut = makeSUT(actualPresenter: true) // errorLabel is hidden initially
        let msg = "Test Error"
        
        sut.toggleErrorMsg(msg: msg)
        
        expect(sut.resetPinError.isHidden).to(beFalse())
        expect(sut.resetPinError.text).to(match(msg))
    }
}

class ResetPINViewPresenterMock: ResetPINViewPresenter {
    
    private(set) var onViewAppearCalled = false
    
    func onViewAppeared() {
        onViewAppearCalled = true
    }
    
    private(set) var onViewLoadCalled = false
    
    func onViewLoaded() {
        onViewLoadCalled = true
    }
    
    private(set) var clickedResendEmailCalled = false
    
    func clickedResendEmail() {
        clickedResendEmailCalled = true
    }
}
