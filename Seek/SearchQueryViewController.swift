//
//  SearchQueryViewController.swift
//  Seek
//
//  Created by Wilson Ding on 1/20/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Alamofire

class SearchQueryViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seekButton: UIButton!
    
    var selectedUrl = ""
    var selectedTime = 0
    
    var timestampArray = [0, 0, 2, 3, 4]
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seekButton.layer.cornerRadius = 10
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        self.playerView.load(withVideoId: selectedUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playerView.cueVideo(byId: selectedUrl, startSeconds: Float(selectedTime), suggestedQuality: .default)
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
    
    func sendDataToServerWith(id: String, query: String, endpoint: String) {
        Alamofire.request("http://c02b794f.ngrok.io/\(endpoint)?v=\(id)&q=\(query)").responseJSON { response in
            print(response.response!) // HTTP URL response
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            } else {
                print("JSON serialization failed. Raw data: \(response.result)")
            }
        }
    }
    
    @IBAction func didPressSeekButton(_ sender: Any) {
        if self.searchTextField.text != "" {
            let youtubeId = selectedUrl.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
            sendDataToServerWith(id: youtubeId, query: searchTextField.text!, endpoint: "audiosearch")
            sendDataToServerWith(id: youtubeId, query: searchTextField.text!, endpoint: "videosearch")
            self.performSegue(withIdentifier: "goToList", sender: self)
        } else {
            createAlert(title:"Error", message: "The Search Query is not valid!")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! ListTableViewController
        vc.timestampArray = self.timestampArray
    }

}
