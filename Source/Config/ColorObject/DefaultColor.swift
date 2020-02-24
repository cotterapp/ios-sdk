//
//  DefaultColor.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/23/20.
//

import Foundation

public class DefaultColor: ColorObject {
    public init() {
        super.init(hexColor: [
            // MARK: - Enrollment
            EnrollmentColorVCKey.pinTitleColor: "#7f7f7f",
            EnrollmentColorVCKey.pinButtonColor: "#0d8400",
            EnrollmentColorVCKey.pinEmptyColor: "#c1c1c1",
            EnrollmentColorVCKey.pinErrorColor: "#e80003",
            EnrollmentColorVCKey.pinInputColor: "#3500c9",
            EnrollmentColorVCKey.successTitleColor: "#000000",
            EnrollmentColorVCKey.successSubtitleColor: "#c4c4c4",
            EnrollmentColorVCKey.successButtonColor: "#55e9bd",
            
            // MARK: - Transaction
            TransactionColorVCKey.pinTitleColor: "#7f7f7f",
            TransactionColorVCKey.pinButtonColor: "#0d8400",
            TransactionColorVCKey.pinEmptyColor: "#c1c1c1",
            TransactionColorVCKey.pinErrorColor: "#e80003",
            TransactionColorVCKey.pinInputColor: "#3500c9",
            
            // MARK: - Update Profile
            UpdateProfileColorVCKey.pinTitleColor: "#7f7f7f",
            UpdateProfileColorVCKey.pinButtonColor: "#0d8400",
            UpdateProfileColorVCKey.pinEmptyColor: "c1c1c1",
            UpdateProfileColorVCKey.pinErrorColor: "#e80003",
            UpdateProfileColorVCKey.pinInputColor: "#3500c9",
        ])
    }
}
