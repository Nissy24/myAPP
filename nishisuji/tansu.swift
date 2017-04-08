//
//  tansu.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/02.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices

class tansu: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var myimage = NSMutableArray()
    
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

       // cell.myitem?.image = UIImage(named: "")
        
        //　背景色の設定
        cell.backgroundColor = UIColor.white
        
        // 作成したcellオブジェクトを戻り値として返す
        return cell
        
        
    }
    
    // collectionViewがタップされた時発動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    //　配列初期化
    myimage = NSMutableArray()
    
    // AppDelegateを使う用意をしておく
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // エンティティを操作するためのオブジェクトを作成
    let viewContext = appDelegate.persistentContainer.viewContext
    
    // todayをString型にしてnilをいれる
    var today: String? = nil
    
    // どのエンティティからdataを取得してくるか設定
    let query: NSFetchRequest<Myitem> = Myitem.fetchRequest()
    do {
    //データを一括取得
    let fetchResults = try! viewContext.fetch(query)
    // データの取得
    for result:AnyObject in fetchResults{
    // todayにnewFashionViewControllerの170行目のstrURLと一緒！！
    today = result.value(forKey: "collection") as? String
    }
    }catch{
    }
    
        if today != nil {
            
            let url = URL(string: today as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                self.myclothes.image = image
            }
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
