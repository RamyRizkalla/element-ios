// File created from SimpleUserProfileExample
// $ createScreen.sh Spaces/SpaceCreation/SpaceCreationEmailInvites SpaceCreationEmailInvites
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
import SwiftUI

/// Using an enum for the screen allows you define the different state cases with
/// the relevant associated data for each case.
@available(iOS 14.0, *)
enum MockSpaceCreationEmailInvitesScreenState: MockScreenState, CaseIterable {
    // A case for each state you want to represent
    // with specific, minimal associated data that will allow you
    // mock that screen.
    case defaultEmailValues
    case emailEntered
    case emailValidationFailed
    case loading

    /// The associated screen
    var screenType: Any.Type {
        SpaceCreationEmailInvites.self
    }
    
    /// A list of screen state definitions
    static var allCases: [MockSpaceCreationEmailInvitesScreenState] {
        [.defaultEmailValues, .emailEntered, .emailValidationFailed, .loading]
    }
    
    /// Generate the view struct for the screen state.
    var screenView: ([Any], AnyView)  {
        let creationParams = SpaceCreationParameters()
        let service: MockSpaceCreationEmailInvitesService
        switch self {
        case .defaultEmailValues:
            service = MockSpaceCreationEmailInvitesService(defaultValidation: true, isLoading: false)
        case .emailEntered:
            creationParams.emailInvites = ["test1@element.io", "test2@element.io"]
            service = MockSpaceCreationEmailInvitesService(defaultValidation: true, isLoading: false)
        case .emailValidationFailed:
            creationParams.emailInvites = ["test1@element.io", "test2@element.io"]
            service = MockSpaceCreationEmailInvitesService(defaultValidation: false, isLoading: false)
        case .loading:
            creationParams.emailInvites = ["test1@element.io", "test2@element.io"]
            service = MockSpaceCreationEmailInvitesService(defaultValidation: true, isLoading: true)
        }
        let viewModel = SpaceCreationEmailInvitesViewModel(creationParameters: creationParams, service: service)
        
        // can simulate service and viewModel actions here if needs be.
        
        return (
            [viewModel],
            AnyView(SpaceCreationEmailInvites(viewModel: viewModel.context)
                .addDependency(MockAvatarService.example))
        )
    }
}
