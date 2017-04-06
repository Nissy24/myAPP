//
//  tansu.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/02.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit

class tansu: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var myclothes: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //セクション数の設定 テーブルビューでは省略
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Item数の設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    //セル内に表示するデータの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cellオブジェクト
        let cell:customImage = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! customImage

        cell.myitem?.image = UIImage(named: "yesterday.jpg")
        
        //　背景色の設定
        cell.backgroundColor = UIColor.white
        
        // 作成したcellオブジェクトを戻り値として返す
        return cell
        
        
    }
    
    // collectionViewがタップされた時発動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
