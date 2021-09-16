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

import UIKit
import Reusable

@objc
protocol URLPreviewViewDelegate: AnyObject {
    func didOpenURLFromPreviewView(_ previewView: URLPreviewView, for eventID: String, in roomID: String)
    func didCloseURLPreviewView(_ previewView: URLPreviewView, for eventID: String, in roomID: String)
}

@objcMembers
/// A view to display `URLPreviewData` generated by the `URLPreviewManager`.
class URLPreviewView: UIView, NibLoadable, Themable {
    // MARK: - Constants
    
    private static let sizingView = URLPreviewView.instantiate()
    
    private enum Constants {
        /// The fixed width of the preview view.
        static let width: CGFloat = 267.0
        /// A reduced width available for use on 4" devices.
        static let reducedWidth: CGFloat = 230
    }
    
    // MARK: - Properties
    
    /// The preview data to display in the view.
    var preview: URLPreviewData? {
        didSet {
            guard let preview = preview else {
                renderLoading()
                return
            }
            renderLoaded(preview)
        }
    }
    
    /// The total width available for the view to layout.
    /// Note: The view's width will be the largest `Constant` that fits this size.
    var availableWidth: CGFloat = 375 {
        didSet {
            // TODO: adjust values when using RoomBubbleCellData's maxTextViewWidth property
            widthConstraint.constant = availableWidth <= 320 ? Constants.reducedWidth : Constants.width
        }
    }
    
    weak var delegate: URLPreviewViewDelegate?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var textContainerView: UIView!
    @IBOutlet private weak var siteNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // The constraint that determines the view's width
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    // Matches the label's height with the close button.
    // Use a strong reference to keep it around when deactivating.
    @IBOutlet private var siteNameLabelHeightConstraint: NSLayoutConstraint!
    
    /// Returns true when `titleLabel` has a non-empty string.
    private var hasTitle: Bool {
        guard let title = titleLabel.text else { return false }
        return !title.isEmpty
    }
    
    // MARK: - Setup
    
    static func instantiate() -> Self {
        let view = Self.loadFromNib()
        view.update(theme: ThemeService.shared().theme)
        view.translatesAutoresizingMaskIntoConstraints = false      // fixes unsatisfiable constraints encountered by the sizing view
        
        return view
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        siteNameLabel.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        descriptionLabel.isUserInteractionEnabled = false
    }
    
    // MARK: - Public
    
    func update(theme: Theme) {
        backgroundColor = theme.colors.navigation
        
        siteNameLabel.textColor = theme.colors.secondaryContent
        siteNameLabel.font = theme.fonts.caption2SB
        
        titleLabel.textColor = theme.colors.primaryContent
        titleLabel.font = theme.fonts.calloutSB
        
        descriptionLabel.textColor = theme.colors.secondaryContent
        descriptionLabel.font = theme.fonts.caption1
        
        let closeButtonAsset = ThemeService.shared().isCurrentThemeDark() ? Asset.Images.urlPreviewCloseDark : Asset.Images.urlPreviewClose
        closeButton.setImage(closeButtonAsset.image, for: .normal)
    }
    
    static func contentViewHeight(for preview: URLPreviewData?, fitting maxWidth: CGFloat) -> CGFloat {
        sizingView.availableWidth = maxWidth
        sizingView.frame = CGRect(x: 0, y: 0, width: sizingView.widthConstraint.constant, height: 1)
        
        // Call render directly to avoid storing the preview data in the sizing view
        if let preview = preview {
            sizingView.renderLoaded(preview)
        } else {
            sizingView.renderLoading()
        }

        sizingView.setNeedsLayout()
        sizingView.layoutIfNeeded()
        
        let fittingSize = CGSize(width: sizingView.widthConstraint.constant, height: UIView.layoutFittingCompressedSize.height)
        let layoutSize = sizingView.systemLayoutSizeFitting(fittingSize)
        
        return layoutSize.height
    }
    
    // MARK: - Private
    /// Tells the view to show in it's loading state.
    private func renderLoading() {
        // hide the content
        imageView.isHidden = true
        textContainerView.isHidden = true
        
        // show the loading interface
        loadingView.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    /// Tells the view to display it's loaded state for the supplied data.
    private func renderLoaded(_ preview: URLPreviewData) {
        // update preview content
        imageView.image = preview.image
        siteNameLabel.text = preview.siteName ?? preview.url.host
        titleLabel.text = preview.title
        descriptionLabel.text = preview.text
        
        // hide the loading interface
        loadingView.isHidden = true
        loadingActivityIndicator.stopAnimating()
        
        // show the content
        textContainerView.isHidden = false
        
        // tweak the layout depending on the content
        if imageView.image == nil {
            imageView.isHidden = true
            
            siteNameLabelHeightConstraint.isActive = true
            descriptionLabel.numberOfLines = hasTitle ? 3 : 5
        } else {
            imageView.isHidden = false
            
            siteNameLabelHeightConstraint.isActive = false
            descriptionLabel.numberOfLines = 2
        }
    }
    
    // MARK: - Action
    @IBAction private func openURL(_ sender: Any) {
        MXLog.debug("[URLPreviewView] Link was tapped.")
        guard let preview = preview else { return }
        
        // Ask the delegate to open the URL for the event, as the bubble component
        // has the original un-sanitized URL that needs to be opened.
        delegate?.didOpenURLFromPreviewView(self, for: preview.eventID, in: preview.roomID)
    }
    
    @IBAction private func close(_ sender: Any) {
        guard let preview = preview else { return }
        delegate?.didCloseURLPreviewView(self, for: preview.eventID, in: preview.roomID)
    }
}
