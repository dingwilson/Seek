//
//  SplashViewController.swift
//  Seek
//
//  Created by Wilson Ding on 1/20/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class SplashViewController: UIViewController {

    @IBOutlet weak var backgroundVideo: BackgroundVideo!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var seekButton: UIButton!
    
    var selectedUrl = ""
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.backgroundVideo.createBackgroundVideo(name: "Background", type: "mp4", alpha: 0.65)
        
        seekButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appGroupId = "group.com.wilsonding.Seek"
        
        let defaults = UserDefaults(suiteName: appGroupId)
        
        if let url = defaults?.string(forKey: "youtubeUrl") {
            if url != "" {
                urlField.text = url
                defaults?.setValue("", forKey: "youtubeUrl")
            }
        }
    }
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func didPressSeekButton(_ sender: Any) {
        if self.urlField.text != "" {
            self.selectedUrl = self.urlField.text!
            self.performSegue(withIdentifier: "goToSearchQuery", sender: self)
        } else {
            createAlert(title:"Error", message: "The YouTube URL is not valid!")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! SearchQueryViewController
        vc.selectedUrl = self.selectedUrl
    }

}
