//
//  ResetPINFinalViewControllerTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

@available(iOS 13.0, *)
class ResetPINFinalViewControllerTests: XCTestCase {

    // MARK: VC Text Definitions
    let successTitle = CotterStrings.instance.getText(for: ResetPINFinalViewControllerKey.title)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.resetPinSuccessImg)
    
    let presenter = ResetPINFinalViewPresenterMock()
    
    func makeSUT(actualPresenter: Bool = false) -> ResetPINFinalViewController {
        let storyboard = UIStoryboard(name: "Transaction", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "ResetPINFinalViewController") as! ResetPINFinalViewController
        if !actualPresenter {
            sut.presenter = presenter
        }
        sut.loadViewIfNeeded()
        return sut
    }

    func setupProps() -> ResetPINFinalViewProps {
        ResetPINFinalViewProps(
            successTitle: successTitle,
            successImage: successImage
        )
    }
    
    func testViewDidLoadCallsPresenter() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        expect(self.presenter.onViewLoadCalled).to(beTrue())
    }
    
    func testRender() {
        let props = setupProps()
        
        let sut = makeSUT()
        
        sut.render(props)
        
        expect(sut.successLabel.text).to(match(successTitle))
        expect(sut.imagePath).to(match(successImage))
    }
    
}

class ResetPINFinalViewPresenterMock: ResetPINFinalViewPresenter {
    
    private(set) var onViewLoadCalled = false
    
    func onViewLoaded() {
        onViewLoadCalled = true
    }

}
