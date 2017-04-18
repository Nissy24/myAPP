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
    
    var mycategory = ["トップス","ジャケット/アウター","パンツ","オールインワン・サロンペット","スカート","ワンピース","スーツ/ネクタイ/かりゆしウェア","バッグ","シューズ","ファッション雑貨","時計","ヘアアクセサリー","アクセサリー","アンダーウェア","レッグウェア","帽子","その他"]
    
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
    
    // セルが選択したとき発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)行目が選択されました")
        
        // メンバ変数に行番号を保存
        selectedIndex = indexPath.row
        
        // セグエを指定して画面遷移
        performSegue(withIdentifier: "SecondView", sender: indexPath)
        
    }
    
    // Segueで画面遷移するとき発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if文でshowTsuikaViewが押された時のコードを書く
        if (segue.identifier! == "showTsuikaView") {
        // タップされたボタンのtableviewの選択行を取得
        var btn = sender as! UIButton
        var cell = btn.superview?.superview as! UITableViewCell
        var row = mytableview.indexPath(for: cell)?.row
        // 行数を表示
        print("\(row)");
        
        // 次の遷移先の画面をインスタンス化して取得
        let secondVC = segue.destination as!
        tuika
        
        // 次の遷移先の画面のプロパティに、選択された行番号を保存
        selectedIndex = row!
        secondVC.scSeletectedIndex = selectedIndex
        }else{
            var indexPath = sender as! IndexPath
            var row = indexPath.row
            // 次の遷移先の画面をインスタンス化して取得
            let secondVC = segue.destination as!
            tansu
            
            // 次の遷移先の画面のプロパティに、選択された行番号を保存
            selectedIndex = row
            secondVC.selectedIndex = selectedIndex
        }
        
        
        
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
