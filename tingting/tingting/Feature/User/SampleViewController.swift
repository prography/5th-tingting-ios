//
//  SampleViewController.swift
//  tingting
//
//  Created by 김선우 on 11/30/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sampleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonPressed(_ sender: Any) {
        
    }
}

extension SampleViewController {
    static func initiate() -> SampleViewController {
        
        let vc = SampleViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
