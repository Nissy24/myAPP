//
//  tuika.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/02.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit

class tuika: UIViewController {
    
 
    @IBOutlet weak var mymy: UILabel!
    
    var mycategory = ["トップス","ジャケット/アウター","パンツ","オールインワン・サロンペット","スカート","ワンピース","スーツ/ネクタイ/かりゆしウェア","バッグ","シューズ","ファッション雑貨","時計","ヘアアクセサリー","アクセサリー","アンダーウェア","レッグウェア","帽子"]
    
    // 前画面から行番号を受け取るためのプロパティ
    var scSeletectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 画面が表示される度に起動
    override func viewWillAppear(_ animated: Bool) {
        print("前の画面から\(scSeletectedIndex)行目が選択されました")
        
        mymy.text = mycategory[scSeletectedIndex]
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
