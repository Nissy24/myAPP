//
//  category.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/03/27.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit

class category: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var mytableview: UITableView!
    
    var mycategory = ["トップス","ジャケット/アウター","パンツ","オールインワン・サロンペット","スカート","ワンピース","スーツ/ネクタイ/かりゆしウェア","バッグ","シューズ","ファッション雑貨","時計","ヘアアクセサリー","アクセサリー","アンダーウェア","レッグウェア","帽子"]
    
    var selectedIndex = -1
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mycategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // 文字を表示するセルの所得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customCell
        // 表示文字の設定
        cell.mylabel.text = mycategory[indexPath.row]
        
        // 文字を設定したセルを返す
        return cell
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
