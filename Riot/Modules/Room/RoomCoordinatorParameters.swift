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

/// RoomCoordinator input parameters
struct RoomCoordinatorParameters {
    
    // MARK: - Properties
    
    /// The navigation router that manage physical navigation
    let navigationRouter: NavigationRouterType?
    
    /// The navigation router store that enables to get a NavigationRouter from a navigation controller
    /// `navigationRouter` property takes priority on `navigationRouterStore`
    let navigationRouterStore: NavigationRouterStoreProtocol?
    
    /// Presenter for displaying loading indicators, success messages and other user indicators
    let userIndicatorPresenter: UserIndicatorTypePresenterProtocol?
    
    /// The matrix session in which the room should be available.
    let session: MXSession
    
    /// The room identifier
    let roomId: String
    
    /// The identifier of the parent space. `nil` for home space
    let parentSpaceId: String?

    /// If not nil, the room will be opened on this event.
    let eventId: String?
    
    /// If not nil, specified thread will be opened.
    let threadId: String?
    
    /// Display configuration for the room
    let displayConfiguration: RoomDisplayConfiguration
    
    /// The data for the room preview.
    let previewData: RoomPreviewData?
    
    /// If `true`, the room settings screen will be initially displayed. Default `false`
    let showSettingsInitially: Bool
    
    // MARK: - Setup
    
    private init(navigationRouter: NavigationRouterType?,
                 navigationRouterStore: NavigationRouterStoreProtocol?,
                 userIndicatorPresenter: UserIndicatorTypePresenterProtocol?,
                 session: MXSession,
                 roomId: String,
                 parentSpaceId: String?,
                 eventId: String?,
                 threadId: String?,
                 displayConfiguration: RoomDisplayConfiguration,
                 previewData: RoomPreviewData?,
                 showSettingsInitially: Bool) {
        self.navigationRouter = navigationRouter
        self.navigationRouterStore = navigationRouterStore
        self.userIndicatorPresenter = userIndicatorPresenter
        self.session = session
        self.roomId = roomId
        self.parentSpaceId = parentSpaceId
        self.eventId = eventId
        self.threadId = threadId
        self.displayConfiguration = displayConfiguration
        self.previewData = previewData
        self.showSettingsInitially = showSettingsInitially
    }
    
    /// Init to present a joined room
    init(navigationRouter: NavigationRouterType? = nil,
         navigationRouterStore: NavigationRouterStoreProtocol? = nil,
         userIndicatorPresenter: UserIndicatorTypePresenterProtocol? = nil,
         session: MXSession,
         parentSpaceId: String?,
         roomId: String,
         eventId: String? = nil,
         threadId: String? = nil,
         showSettingsInitially: Bool,
         displayConfiguration: RoomDisplayConfiguration = .default) {
        
        self.init(navigationRouter: navigationRouter,
                  navigationRouterStore: navigationRouterStore,
                  userIndicatorPresenter: userIndicatorPresenter,
                  session: session,
                  roomId: roomId,
                  parentSpaceId: parentSpaceId,
                  eventId: eventId,
                  threadId: threadId,
                  displayConfiguration: displayConfiguration,
                  previewData: nil,
                  showSettingsInitially: showSettingsInitially)
    }
    
    /// Init to present a room preview
    init(navigationRouter: NavigationRouterType? = nil,
         navigationRouterStore: NavigationRouterStoreProtocol? = nil,
         parentSpaceId: String?,
         previewData: RoomPreviewData) {
        
        self.init(navigationRouter: navigationRouter,
                  navigationRouterStore: navigationRouterStore,
                  userIndicatorPresenter: nil,
                  session: previewData.mxSession,
                  roomId: previewData.roomId,
                  parentSpaceId: parentSpaceId,
                  eventId: nil,
                  threadId: nil,
                  displayConfiguration: .default,
                  previewData: previewData,
                  showSettingsInitially: false)
    }
}
