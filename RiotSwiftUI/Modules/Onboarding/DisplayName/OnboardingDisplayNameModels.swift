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

import Foundation

// MARK: View model

enum OnboardingDisplayNameViewModelResult {
    case save(String)
    case skip
}

// MARK: View

struct OnboardingDisplayNameViewState: BindableState {
    var bindings: OnboardingDisplayNameBindings
    var validationErrorMessage: String?
    
    var textFieldFooterMessage: String {
        validationErrorMessage ?? VectorL10n.onboardingDisplayNameHint
    }
}

struct OnboardingDisplayNameBindings {
    var displayName: String
    var alertInfo: AlertInfo<Int>?
}

enum OnboardingDisplayNameViewAction {
    case validateDisplayName
    case save
    case skip
}
