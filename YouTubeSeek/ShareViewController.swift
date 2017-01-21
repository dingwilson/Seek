//
//  ShareViewController.swift
//  YouTubeSeek
//
//  Created by Wilson Ding on 1/20/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }
        
        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments as? [NSItemProvider] {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                        
                        itemProvider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { (result: NSSecureCoding?, error: Error!) -> Void in
                            self.textView.text = result as! String!
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func didPressCancelButton(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    

    @IBAction func didPressSendButton(_ sender: Any) {
        let featureRemovedString = textView.text.replacingOccurrences(of: "&feature=share", with: "")
        
        let appGroupId = "group.com.wilsonding.Seek"
        
        if let defaults = UserDefaults(suiteName: appGroupId) {
            defaults.setValue(featureRemovedString, forKey: "youtubeUrl")
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
}
