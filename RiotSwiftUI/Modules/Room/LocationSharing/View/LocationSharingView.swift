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
import CoreLocation

@available(iOS 14.0, *)
struct LocationSharingView: View {
    
    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    // MARK: Public
    
    @ObservedObject var context: LocationSharingViewModel.Context
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                LocationSharingMapView(tileServerMapURL: context.viewState.mapStyleURL,
                                       annotations: context.viewState.annotations,
                                       highlightedAnnotation: context.viewState.highlightedAnnotation,
                                       userAvatarData: context.viewState.userAvatarData,
                                       showsUserLocation: context.viewState.showsUserLocation,
                                       userLocation: $context.userLocation,
                                       errorSubject: context.viewState.errorSubject)
                    .ignoresSafeArea()
                MapCreditsView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(VectorL10n.cancel, action: {
                        context.send(viewAction: .cancel)
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text(VectorL10n.locationSharingTitle)
                        .font(.headline)
                        .foregroundColor(theme.colors.primaryContent)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if context.viewState.displayExistingLocation {
                        Button {
                            context.send(viewAction: .share)
                        } label: {
                            Image(uiImage: Asset.Images.locationShareIcon.image)
                                .accessibilityIdentifier("LocationSharingView.shareButton")
                        }
                        .disabled(!context.viewState.shareButtonEnabled)
                    } else {
                        Button(VectorL10n.locationSharingShareAction, action: {
                            context.send(viewAction: .share)
                        })
                            .disabled(!context.viewState.shareButtonEnabled)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .introspectNavigationController { navigationController in
                ThemeService.shared().theme.applyStyle(onNavigationBar: navigationController.navigationBar)
            }
            .alert(item: $context.alertInfo) { info in
                info.alert
            }
        }
        .accentColor(theme.colors.accent)
        .activityIndicator(show: context.viewState.showLoadingIndicator)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private var activityIndicator: some View {
        if context.viewState.showLoadingIndicator {
            ActivityIndicator()
        }
    }
}

// MARK: - Previews

@available(iOS 14.0, *)
struct LocationSharingView_Previews: PreviewProvider {
    static let stateRenderer = MockLocationSharingScreenState.stateRenderer
    static var previews: some View {
        stateRenderer.screenGroup()
    }
}
