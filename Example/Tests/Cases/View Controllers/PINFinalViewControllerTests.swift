//
//  PINFinalViewControllerTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

@available(iOS 13.0, *)
class PINFinalViewControllerTests: XCTestCase {

    // MARK: VC Text Definitions
    let successTitle = CotterStrings.instance.getText(for: PINFinalViewControllerKey.title)
    let successSubtitle = CotterStrings.instance.getText(for: PINFinalViewControllerKey.subtitle)
    let successButtonTitle = CotterStrings.instance.getText(for: PINFinalViewControllerKey.buttonText)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
    
    // MARK: - VC Color Definitions
    let primaryColor = Config.instance.colors.primary
    let accentColor = Config.instance.colors.accent
    let dangerColor = Config.instance.colors.danger
    
    let presenter = PINFinalViewPresenterMock()

    func makeSUT(actualPresenter: Bool = false) -> PINFinalViewController {
        let storyboard = UIStoryboard(name: "Cotter", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "PINFinalViewController") as! PINFinalViewController
        if !actualPresenter {
            sut.presenter = presenter
        }
        sut.loadViewIfNeeded()
        return sut
    }
    
    func setupProps() -> PINFinalViewProps {
        return PINFinalViewProps(
            title: successTitle,
            subtitle: successSubtitle,
            buttonTitle: successButtonTitle,
            successImage: successImage,
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
    
    func testOnFinishCallsPresenter() {
        let sut = makeSUT()
        
        sut.finish(.init())
        
        expect(self.presenter.onFinishCalled).to(beTrue())
    }
    
    func testRender() {
        let props = setupProps()
        
        let sut = makeSUT()
        
        sut.render(props)
        
        expect(sut.successLabel.text).to(match(successTitle))
        expect(sut.successSubLabel.text).to(match(successSubtitle))
        expect(sut.finishButton.title(for: .normal)).to(match(successButtonTitle))
        expect(sut.imagePath).to(match(successImage))
    }

}

class PINFinalViewPresenterMock: PINFinalViewPresenter {
    
    private(set) var onViewLoadCalled = false
    
    func onViewLoaded() {
        onViewLoadCalled = true
    }
    
    private(set) var onFinishCalled = false
    
    func onFinish(button: UIButton) {
        onFinishCalled = true
    }
}
