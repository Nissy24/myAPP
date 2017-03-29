//
//  ViewController.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/03/27.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var one: UIImageView!
    
    @IBOutlet weak var two: UIImageView!
    
    @IBOutlet weak var three: UIImageView!
    
    @IBOutlet weak var four: UIImageView!
    
    @IBOutlet weak var five: UIImageView!
    
    @IBOutlet weak var six: UIImageView!
    
    @IBOutlet weak var seven: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var label7: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        one.image = UIImage(named: "yesterday.jpg")
        
        two.image = UIImage(named: "")
        
        three.image = UIImage(named: "")
        
        four.image = UIImage(named: "")
        
        five.image = UIImage(named: "")
        
        six.image = UIImage(named: "")
        
        seven.image = UIImage(named: "")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func myaddition(_ sender: UIButton) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
