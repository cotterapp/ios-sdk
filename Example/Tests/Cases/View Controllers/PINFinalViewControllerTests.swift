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

    func makeSUT() -> PINFinalViewController {
        let storyboard = UIStoryboard(name: "Cotter", bundle: Cotter.resourceBundle)
        let sut = storyboard.instantiateViewController(identifier: "PINFinalViewController") as! PINFinalViewController
        sut.presenter = presenter
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
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoadCallsPresenter() {
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        expect(self.presenter.onViewLoadedCalled).to(beTrue())
        expect(self.presenter.onConfigureNavCalled).to(beTrue())
        expect(self.presenter.onConfigureButtonCalled).to(beTrue())
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

class PINFinalViewPresenterMock : PINFinalViewPresenter {
    
    private(set) var onViewLoadedCalled = false
    
    func onViewLoaded() {
        onViewLoadedCalled = true
    }
    
    private(set) var onFinishCalled = false
    
    func onFinish() {
        onFinishCalled = true
    }
    
    private(set) var onConfigureNavCalled = false
    
    func onConfigureNav() {
        onConfigureNavCalled = true
    }
    
    private(set) var onConfigureButtonCalled = false
    
    func onConfigureButton() {
        onConfigureButtonCalled = true
    }
}
