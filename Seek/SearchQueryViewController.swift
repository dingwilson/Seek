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
    
    var selectedUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.playerView.load(withVideoId: selectedUrl)
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
