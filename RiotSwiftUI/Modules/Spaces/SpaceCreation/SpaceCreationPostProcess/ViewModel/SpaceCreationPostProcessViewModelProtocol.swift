// File created from SimpleUserProfileExample
// $ createScreen.sh Spaces/SpaceCreation/SpaceCreationPostProcess SpaceCreationPostProcess
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

protocol SpaceCreationPostProcessViewModelProtocol {
    
    var completion: ((SpaceCreationPostProcessViewModelResult) -> Void)? { get set }
    @available(iOS 14, *)
    static func makeSpaceCreationPostProcessViewModel(spaceCreationPostProcessService: SpaceCreationPostProcessServiceProtocol) -> SpaceCreationPostProcessViewModelProtocol
    @available(iOS 14, *)
    var context: SpaceCreationPostProcessViewModelType.Context { get }
}
