//
//  SearchQueryViewController.swift
//  Seek
//
//  Created by Wilson Ding on 1/20/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class SearchQueryViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seekButton: UIButton!
    
    var selectedUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        seekButton.layer.cornerRadius = 10
        
        let youtubeId = selectedUrl.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")

        self.playerView.load(withVideoId: youtubeId)
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
    
    func sendDataToServerWith(id: String, query: String) {
        
    }
    
    @IBAction func didPressSeekButton(_ sender: Any) {
        if self.searchTextField.text != "" {
            let youtubeId = selectedUrl.replacingOccurrences(of: "https://www.youtube.com", with: "")
            sendDataToServerWith(id: youtubeId, query: searchTextField.text!)
        } else {
            createAlert(title:"Error", message: "The Search Query is not valid!")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
