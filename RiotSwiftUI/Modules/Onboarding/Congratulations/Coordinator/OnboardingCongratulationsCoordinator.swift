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

struct OnboardingCongratulationsCoordinatorParameters {
    let userSession: UserSession
    let personalizationDisabled: Bool
}

enum OnboardingCongratulationsCoordinatorResult {
    case personaliseProfile(UserSession)
    case takeMeHome(UserSession)
}

final class OnboardingCongratulationsCoordinator: Coordinator, Presentable {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let parameters: OnboardingCongratulationsCoordinatorParameters
    private let onboardingCongratulationsHostingController: UIViewController
    private var onboardingCongratulationsViewModel: OnboardingCongratulationsViewModelProtocol
    
    // MARK: Public

    // Must be used only internally
    var childCoordinators: [Coordinator] = []
    var completion: ((OnboardingCongratulationsCoordinatorResult) -> Void)?
    
    // MARK: - Setup
    
    @available(iOS 14.0, *)
    init(parameters: OnboardingCongratulationsCoordinatorParameters) {
        self.parameters = parameters
        
        // TODO: Add confetti when personalizationDisabled is false
        let viewModel = OnboardingCongratulationsViewModel(userId: parameters.userSession.userId,
                                                           personalizationDisabled: parameters.personalizationDisabled)
        let view = OnboardingCongratulationsScreen(viewModel: viewModel.context)
        onboardingCongratulationsViewModel = viewModel
        onboardingCongratulationsHostingController = VectorHostingController(rootView: view)
    }
    
    // MARK: - Public
    func start() {
        MXLog.debug("[OnboardingCongratulationsCoordinator] did start.")
        onboardingCongratulationsViewModel.completion = { [weak self] result in
            guard let self = self else { return }
            MXLog.debug("[OnboardingCongratulationsCoordinator] OnboardingCongratulationsViewModel did complete with result: \(result).")
            
            switch result {
            case .personaliseProfile:
                self.completion?(.personaliseProfile(self.parameters.userSession))
            case .takeMeHome:
                self.completion?(.takeMeHome(self.parameters.userSession))
            }
        }
    }
    
    func toPresentable() -> UIViewController {
        return self.onboardingCongratulationsHostingController
    }
}
