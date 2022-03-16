// 
// Copyright 2022 New Vector Ltd
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

import ASTemplateConfiguration
import UIKit

enum BookingTab: Int {
    case flight
    case hotel
}

class BookingViewController: UIViewController {
    private var flightsViewController: UIViewController!
    private var hotelsViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setChildren()
        setSegmentedControl()
        addFlightsView()
        tabBarController?.tabBar.isTranslucent = false
    }

    private func setSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["Flights", "Hotels"])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        navigationBar?.topItem?.titleView = segmentedControl
    }

    private func setChildren() {
        flightsViewController = AviasalesViewControllersFactory.shared.flightsViewController()
        hotelsViewController = AviasalesViewControllersFactory.shared.hotelsViewController()
    }

    private func addFlightsView() {
        vc_addChildViewController(viewController: flightsViewController, onView: view, animated: true)
    }

    private func addHotelsView() {
        vc_addChildViewController(viewController: hotelsViewController, onView: view, animated: true)
        hotelsViewController.view.layoutIfNeeded()
        hotelsViewController.view.updateConstraints()
    }

    @objc private func didSelectTab(_ sender: UISegmentedControl) {
        guard let selectedTab = BookingTab(rawValue: sender.selectedSegmentIndex) else {
            preconditionFailure("Selected Tab Not Implemented")
        }
        switch selectedTab {
        case .flight:
            hotelsViewController.vc_removeFromParent(animated: true)
        case .hotel:
            addHotelsView()
        }
    }
}
