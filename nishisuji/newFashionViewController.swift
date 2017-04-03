//
//  newFashionViewController.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/03/29.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit

class newFashionViewController: UIViewController {

    @IBOutlet weak var fashion: UIImageView!
    
    @IBOutlet weak var mydetail: UITextView!
    
    @IBOutlet weak var mydate: UILabel!
    
    @IBOutlet weak var mymemo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        
        print(df.string(from: Date()))

        mydate.text = df.string(from: Date())
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapReturn(_ sender: UIButton) {
        self.dismiss(animated: true)
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
