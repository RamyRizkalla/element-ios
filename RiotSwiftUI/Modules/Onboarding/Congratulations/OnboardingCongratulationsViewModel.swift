//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14, *)
typealias OnboardingCongratulationsViewModelType = StateStoreViewModel<OnboardingCongratulationsViewState,
                                                                  Never,
                                                                  OnboardingCongratulationsViewAction>
@available(iOS 14, *)
class OnboardingCongratulationsViewModel: OnboardingCongratulationsViewModelType, OnboardingCongratulationsViewModelProtocol {

    // MARK: - Properties

    // MARK: Private

    // MARK: Public

    var completion: ((OnboardingCongratulationsViewModelResult) -> Void)?

    // MARK: - Setup

    init(userId: String, initialCount: Int = 0) {
        super.init(initialViewState: OnboardingCongratulationsViewState(userId: userId))
    }

    // MARK: - Public

    override func process(viewAction: OnboardingCongratulationsViewAction) {
        switch viewAction {
        case .personaliseProfile:
            completion?(.personaliseProfile)
        case .takeMeHome:
            completion?(.takeMeHome)
        }
    }
}
