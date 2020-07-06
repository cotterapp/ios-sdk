//
//  PINConfirmViewControllerTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

@available(iOS 13.0, *)
class PINConfirmViewControllerTests: XCTestCase {

    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: PINConfirmViewControllerKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: PINConfirmViewControllerKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: PINConfirmViewControllerKey.hidePin)
    let title = CotterStrings.instance.getText(for: PINConfirmViewControllerKey.title)
    
    // MARK: - VC Color Definitions
    let primaryColor = Config.instance.colors.primary
    let accentColor = Config.instance.colors.accent
    let dangerColor = Config.instance.colors.danger
    
    let presenter = PINConfirmViewPresenterMock()
    
    func makeSUT(actualPresenter: Bool = false) -> PINConfirmViewController {
        let storyboard = UIStoryboard(name: "Cotter", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "PINConfirmViewController") as! PINConfirmViewController
        if !actualPresenter {
            sut.presenter = presenter
        }
        sut.loadViewIfNeeded()
        return sut
    }
    
    func setupProps() -> PINConfirmViewProps {
        return PINConfirmViewProps(
            navTitle: navTitle,
            showPinText: showPinText,
            hidePinText: hidePinText,
            title: title,
            primaryColor: primaryColor,
            accentColor: accentColor,
            dangerColor: dangerColor
        )
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
        expect(sut.titleLabel.text).to(match(title))
        expect(sut.pinVisibilityButton.title(for: .normal)).to(match(showPinText))
        expect(sut.pinVisibilityButton.titleColor(for: .normal)).to(equal(primaryColor))
        expect(sut.errorLabel.textColor).to(equal(dangerColor))
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
        
        sut.toggleErrorMsg(msg: msg)
        
        expect(sut.errorLabel.isHidden).to(beFalse())
        expect(sut.errorLabel.text).to(match(msg))
    }
}

class PINConfirmViewPresenterMock: PINConfirmViewPresenter {
    
    private(set) var onViewLoadCalled = false
    
    func onViewLoaded() {
        onViewLoadCalled = true
    }
    
    private(set) var onClickPinVisCalled = false
    
    func onClickPinVis(button: UIButton) {
        onClickPinVisCalled = true
    }
}
