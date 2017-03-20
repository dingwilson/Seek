//
//  SplashViewController.swift
//  Seek
//
//  Created by Wilson Ding on 1/20/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import Alamofire

class SplashViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundVideo: BackgroundVideo!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var seekButton: UIButton!
    
    var selectedUrl = ""
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.urlField.delegate = self
        
        self.backgroundVideo.createBackgroundVideo(name: "Background", type: "mp4", alpha: 0.25)
        
        self.backgroundVideo.fadeOut()
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
        
        self.backgroundVideo.fadeIn()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func sendDataToServerWith(id: String) {
        Alamofire.request("https://f1882f9f.ngrok.io/watch?v=\(id)").responseJSON { response in
            print(response.response!) // HTTP URL response
        }
    }

    @IBAction func didPressSeekButton(_ sender: Any) {
        if self.urlField.text != "" {
            self.selectedUrl = self.urlField.text!
            
            self.selectedUrl = selectedUrl.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
            self.selectedUrl = selectedUrl.replacingOccurrences(of: "&feature=share", with: "")
            sendDataToServerWith(id: selectedUrl)
            
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
        let destinationNavigationController = segue.destination as! UINavigationController
        let targetVC = destinationNavigationController.topViewController as! SearchQueryViewController
        //let targetVC = segue.destination as! SearchQueryViewController
        
        targetVC.selectedUrl = self.selectedUrl
    }

}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
