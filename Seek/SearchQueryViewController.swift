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
import SwiftyJSON

class SearchQueryViewController: UIViewController, YTPlayerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seekButton: UIButton!
    @IBOutlet weak var timestampButton: UIButton!
    @IBOutlet weak var loadAudio: UILabel!
    @IBOutlet weak var loadVideo: UILabel!
    @IBOutlet weak var loadFinal: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var selectedUrl = ""
    var selectedTime : Float = 0.0
    
    var currentPercentage: Float = 0.0
    
    var timestampArray : [Timestamp] = []
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timestampButton.isHidden = true
        
        self.searchTextField.delegate = self
        
        self.playerView.delegate = self
        
        self.playerView.load(withVideoId: selectedUrl)
        
        self.playerView.cueVideo(byId: selectedUrl, startSeconds: selectedTime, suggestedQuality: .default)
        
        loadAudio.text = "Loading Audio Analysis..."
        loadVideo.text = "Loading Video Analysis..."
        loadFinal.text = "Calculating Timestamps..."
        progressView.isHidden = true
        loadAudio.isHidden = true
        loadVideo.isHidden = true
        loadFinal.isHidden = true
        timestampButton.isHidden = true
        searchTextField.text = ""
        timestampArray = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentPercentage = 0.0
        update(new: currentPercentage)
        
        loadAudio.text = "Loading Audio Analysis..."
        loadVideo.text = "Loading Video Analysis..."
        loadFinal.text = "Calculating Timestamps..."
        loadAudio.textColor = UIColor.black
        loadVideo.textColor = UIColor.black
        loadFinal.textColor = UIColor.black
        progressView.isHidden = true
        loadAudio.isHidden = true
        loadVideo.isHidden = true
        loadFinal.isHidden = true
        timestampButton.isHidden = true
        searchTextField.text = ""
        timestampArray = []
        
        timestampArray.append(Timestamp(timestamp: 0.0, detail: "Return To Beginning"))
        
        if selectedTime != 0.0 {
            self.playerView.cueVideo(byId: selectedUrl, startSeconds: selectedTime, suggestedQuality: .default)
            self.playerView.playVideo()
        }
    }
    
    func update(new: Float) {
        if (new >= 1) {
            progressView.setProgress(1, animated: true)
        } else {
            progressView.setProgress(new, animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
    }
    
    func sendDataToServerWith(id: String, query: String, endpoint: String) {
        
        self.progressView.isHidden = false
        
        if endpoint == "audiosearch" {
            self.loadAudio.isHidden = false
        }
        
        if endpoint == "videosearch" {
            self.loadVideo.isHidden = false
        }
        
        self.loadFinal.isHidden = false
        
        Alamofire.request("https://f1882f9f.ngrok.io/\(endpoint)?v=\(id)&q=\(query)").responseJSON { response in
            print(response.response!) // HTTP URL response
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
                var jsonArray : [Timestamp] = []
                
                for (key,subJson):(String, JSON) in JSON(json) {
                    let floatArray = subJson.rawValue as! [Float]
                    
                    for timestampValue in floatArray {
                        let timestampObject = Timestamp(timestamp: timestampValue, detail: "\(endpoint) for: \(key)")
                        jsonArray.append(timestampObject)
                    }
                }
                
                self.timestampArray += jsonArray
                
                if endpoint == "audiosearch" {
                    self.loadAudio.textColor = UIColor.green
                    self.loadAudio.text = "Done!"
                    self.currentPercentage = self.currentPercentage + 0.33
                    self.update(new: self.currentPercentage)
                }
                
                if endpoint == "videosearch" {
                    self.loadVideo.textColor = UIColor.green
                    self.loadVideo.text = "Done!"
                    
                    self.currentPercentage = self.currentPercentage + 0.33
                    self.update(new: self.currentPercentage)
                }

            } else {
                print("JSON serialization failed. Raw data: \(response.result)")
                
                if endpoint == "audiosearch" {
                    self.loadAudio.textColor = UIColor.red
                    self.loadAudio.text = "Failed! API Key Max Usage Reached."
                    self.currentPercentage = self.currentPercentage + 0.33
                    self.update(new: self.currentPercentage)
                }
                
                if endpoint == "videosearch" {
                    self.loadVideo.textColor = UIColor.red
                    self.loadVideo.text = "Failed! API Key Max Usage Reached."
                    
                    self.currentPercentage = self.currentPercentage + 0.33
                    self.update(new: self.currentPercentage)
                }
            }
            
            if self.currentPercentage == 0.66 {
                self.loadFinal.textColor = UIColor.green
                self.loadFinal.text = "Done!"
                
                self.currentPercentage = self.currentPercentage + 0.34
                self.update(new: self.currentPercentage)
                
                self.timestampButton.isHidden = false
            }
        }
    }
    
    @IBAction func didPressSeekButton(_ sender: Any) {
        if self.searchTextField.text != "" {
            let youtubeId = selectedUrl.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
            sendDataToServerWith(id: youtubeId, query: searchTextField.text!, endpoint: "audiosearch")
            sendDataToServerWith(id: youtubeId, query: searchTextField.text!, endpoint: "videosearch")
        } else {
            createAlert(title:"Error", message: "The Search Query is not valid!")
        }
    }
    
    @IBAction func didPressTimestampButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToList", sender: self)
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
