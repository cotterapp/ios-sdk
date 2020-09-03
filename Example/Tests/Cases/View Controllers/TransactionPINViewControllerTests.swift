//
//  TransactionPINViewControllerTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

@available(iOS 13.0, *)
class TransactionPINViewControllerTests: XCTestCase {
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: TransactionPINViewControllerKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: TransactionPINViewControllerKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: TransactionPINViewControllerKey.hidePin)
    let forgetPinText = CotterStrings.instance.getText(for: TransactionPINViewControllerKey.forgetPin)
    let titleText = CotterStrings.instance.getText(for: TransactionPINViewControllerKey.title)
    
    // MARK: - VC Color Definitions
    let primaryColor = Config.instance.colors.primary
    let accentColor = Config.instance.colors.accent
    let dangerColor = Config.instance.colors.danger
    
    let presenter = TransactionPINViewPresenterMock()
    
    func makeSUT(actualPresenter: Bool = false) -> TransactionPINViewController {
        let storyboard = UIStoryboard(name: "Transaction", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "TransactionPINViewController") as! TransactionPINViewController
        if !actualPresenter {
            sut.presenter = presenter
        }
        sut.loadViewIfNeeded()
        return sut
    }
    
    func setupProps() -> TransactionPINViewProps {
        return TransactionPINViewProps(
            navTitle: navTitle,
            showPinText: showPinText,
            hidePinText: hidePinText,
            forgetPinText: forgetPinText,
            title: titleText,
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
    
    func testOnClickPinVisCallsPresenter() {
        let sut = makeSUT()
        
        sut.onClickPinVis(.init())
        
        expect(self.presenter.onClickPinVisCalled).to(beTrue())
    }
    
    func testRender() {
        let props = setupProps()
        
        let sut = makeSUT()
        
        sut.render(props)
        
        // expect(sut.navigationItem.title).to(match(navTitle))
        expect(sut.titleLabel.text).to(match(titleText))
        expect(sut.errorLabel.textColor).to(equal(dangerColor))
        expect(sut.pinVisibilityButton.title(for: .normal)).to(match(showPinText))
        expect(sut.pinVisibilityButton.titleColor(for: .normal)).to(equal(primaryColor))
        expect(sut.forgetPinButton.title(for: .normal)).to(match(forgetPinText))
        expect(sut.forgetPinButton.titleColor(for: .normal)).to(equal(accentColor))
    }
    
    func testOnClickPinVis() {
        let props = setupProps()
        
        let sut = makeSUT(actualPresenter: true)
        sut.render(props) // Sets pinVisibilityButton title to be showPinText initially
        
        sut.onClickPinVis(sut.pinVisibilityButton)
        
        expect(sut.pinVisibilityButton.title(for: .normal)).to(match(hidePinText))
    }
    
    func testToggleErrorMsg() {
        let sut = makeSUT(actualPresenter: true) // errorLabel is hidden initially
        let msg = "Test Error"
        
        sut.setError(msg: msg)
        
        expect(sut.errorLabel.isHidden).to(beFalse())
        expect(sut.errorLabel.text).to(match(msg))
    }
}

class TransactionPINViewPresenterMock: TransactionPINViewPresenter {
    
    private(set) var onViewAppearCalled = false
    
    func onViewAppeared() {
        onViewAppearCalled = true
    }
    
    private(set) var onViewLoadCalled = false
    
    func onViewLoaded() {
        onViewLoadCalled = true
    }
    
    private(set) var onClickPinVisCalled = false
    
    func onClickPinVis(button: UIButton) {
        onClickPinVisCalled = true
    }
    
}
