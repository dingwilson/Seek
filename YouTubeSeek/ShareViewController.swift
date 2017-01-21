//
//  ShareViewController.swift
//  YouTubeSeek
//
//  Created by Wilson Ding on 1/20/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        let featureRemovedString = contentText.replacingOccurrences(of: "&feature=share", with: "")
        
        let appGroupId = "group.com.wilsonding.Seek"
        
        if let defaults = UserDefaults(suiteName: appGroupId) {
            defaults.setValue(featureRemovedString, forKey: "youtubeUrl")
        }
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
