//
//  PINViewControllerTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter


@available(iOS 13.0, *)
class PINViewControllerTests: XCTestCase {
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: PINViewControllerKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: PINViewControllerKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: PINViewControllerKey.hidePin)
    let title = CotterStrings.instance.getText(for: PINViewControllerKey.title)
    
    // MARK: - VC Color Definitions
    let primaryColor = Config.instance.colors.primary
    let accentColor = Config.instance.colors.accent
    let dangerColor = Config.instance.colors.danger
    
    // MARK: - Alert Text Definitions
    let alertBackTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackTitle)
    let alertBackBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackBody)
    let alertBackAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackActionButton)
    let alertBackCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackCancelButton)
    
    let presenter = PINViewPresenterMock()
    
    func makeSUT() -> PINViewController {
        let storyboard = UIStoryboard(name: "Cotter", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "PINViewController") as! PINViewController
        sut.presenter = presenter
        sut.loadViewIfNeeded()
        return sut
    }
    
    func setupProps() -> PINViewProps {
        return PINViewProps(
            navTitle: navTitle,
            showPinText: showPinText,
            hidePinText: hidePinText,
            title: title,
            primaryColor: primaryColor,
            accentColor: accentColor,
            dangerColor: dangerColor,
            alertBackTitle: alertBackTitle,
            alertBackBody: alertBackBody,
            alertBackAction: alertBackAction,
            alertBackCancel: alertBackCancel
        )
    }

    func testViewDidLoadCallsPresenter() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        expect(self.presenter.onViewLoadedCalled).to(beTrue())
        expect(self.presenter.onAddConfigsCalled).to(beTrue())
        expect(self.presenter.onAddDelegatesCalled).to(beTrue())
        expect(self.presenter.onInstantiateCodeTextFieldFunctionsCalled).to(beTrue())
    }
    
    func testOnClickPinVisCallsPresenter() {
        let sut = makeSUT()
        
        sut.onClickPinVis(.init())
        
        expect(self.presenter.onClickPinVisCalled).to(beTrue())
    }
    
    func testOnToggleErrorMsgCallsPresenter() {
        let sut = makeSUT()
        
        sut.toggleErrorMsg(msg: "")
        
        expect(self.presenter.onToggleErrorMsgCalled).to(beTrue())
    }
    
    func testRender() {
        let props = setupProps()
        
        let sut = makeSUT()
        
        sut.render(props)
        
        expect(sut.navigationItem.title).to(match(navTitle))
        expect(sut.titleLabel.text).to(match(title))
        expect(sut.pinVisibilityButton.title(for: .normal)).to(match(showPinText))
        expect(sut.pinVisibilityButton.titleColor(for: .normal)).to(equal(primaryColor))
        expect(sut.errorLabel.textColor).to(equal(dangerColor))
    }
    
    func testOnClickPinVis() {
        let props = setupProps()
        
        let sut = makeSUT()
        sut.render(props) // Sets pinVisibilityButton title to be showPinText initially
        
        sut.onClickPinVis(sut.pinVisibilityButton)
        
        expect(sut.pinVisibilityButton.title(for: .normal)).to(match(hidePinText))
    }
    
    func testToggleErrorMsg() {
        let sut = makeSUT() // errorLabel is hidden initially
        let msg = "Test Error"
        
        sut.toggleErrorMsg(msg: msg)
        
        expect(sut.errorLabel.isHidden).to(beFalse())
        expect(sut.errorLabel.text).to(match(msg))
    }
}

class PINViewPresenterMock : PINViewPresenter {
    
    private(set) var onViewLoadedCalled = false
    
    func onViewLoaded() {
        onViewLoadedCalled = true
    }
    
    private(set) var onClickPinVisCalled = false
    
    func onClickPinVis() {
        onClickPinVisCalled = true
    }
    
    private(set) var onInstantiateCodeTextFieldFunctionsCalled = false
    
    func onInstantiateCodeTextFieldFunctions() {
        onInstantiateCodeTextFieldFunctionsCalled = true
    }
    
    private(set) var onAddConfigsCalled = false
    
    func onAddConfigs() {
        onAddConfigsCalled = true
    }
    
    private(set) var onAddDelegatesCalled = false
    
    func onAddDelegates() {
        onAddDelegatesCalled = true
    }
    
    private(set) var onToggleErrorMsgCalled = false
    
    func onToggleErrorMsg() {
        onToggleErrorMsgCalled = true
    }
}
