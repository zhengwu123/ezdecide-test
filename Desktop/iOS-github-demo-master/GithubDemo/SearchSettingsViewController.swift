//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by zheng wu on 3/2/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func didSwitch()
}

class SearchSettingsViewController: UIViewController {
weak var delegate: SettingsPresentingViewControllerDelegate?
    var settings: GithubRepoSearchSettings!
    @IBAction func cancelTapped(_ sender: Any) {
        self.delegate?.didCancelSettings()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var starCount: UILabel!

    @IBOutlet var slider: UISlider!
    @IBAction func onSlide(_ sender: Any) {
        let multiply: Double = 10000.0
        print(slider.value)
        let sliderVal: Double = Double(slider.value)
        settings.minStars = Int(sliderVal * multiply)
        print(settings.minStars)
        starCount.text = "\(settings.minStars)"
    }
    @IBAction func savetapped(_ sender: Any) {
        self.delegate?.didSaveSettings(settings: settings)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
