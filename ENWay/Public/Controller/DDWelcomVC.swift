//
//  DDWelcomVC.swift
//  Project
//
//  Created by WY on 2018/1/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDWelcomVC: DDNormalVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let loginVC = LoginVC()
//
//        self.navigationController?.pushViewController(loginVC, animated: true )

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true )
        self.navigationController?.setNavigationBarHidden(true , animated: true )
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
