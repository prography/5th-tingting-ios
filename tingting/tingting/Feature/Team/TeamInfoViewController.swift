//
//  TeamInfoViewController.swift
//  tingting
//
//  Created by 김선우 on 11/23/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class TeamInfoViewController: UIViewController {

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

}

extension TeamInfoViewController {
    static func initiate() -> TeamInfoViewController {
        let vc = TeamInfoViewController.withStoryboard(storyboard: .team)
        return vc
    }
}
