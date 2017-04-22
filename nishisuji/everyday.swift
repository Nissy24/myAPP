//
//  everyday.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/16.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices

class everyday: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    var myimage = NSMutableArray()

    var selectedIndex = -1
    
    var scmemo:Int = -1
    
    var selectimageIndex = NSDate()
    
    @IBOutlet weak var syasin: UIImageView!
    
    @IBOutlet weak var syousai: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func myreturn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //　配列初期化
        myimage = NSMutableArray()
        
        // dfに詳しい日付を入れる
        let dfstart = DateFormatter()
        dfstart.dateFormat = "yyyy-MM-dd 00:00:00"
        
        let dfend = DateFormatter()
        dfend.dateFormat = "yyyy-MM-dd 23:59:59"
        
        let todayDateStartTime = dfstart.string(from: selectimageIndex as Date)
        
        let todayDateEndTime = dfend.string(from: selectimageIndex as Date)
        
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // hizukeをDate型にしてnilをいれる
        var hizuke: Date? = nil
        
        // todayをString型にしてnilをいれる
        var today: String? = nil
        
        // hitokotoをString型にしてnilをいれる
        var hitokoto: String? = nil
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myfashion> = Myfashion.fetchRequest()
        do {
            //データを一括取得
            let fetchResults = try! viewContext.fetch(query)
            // データの取得
            for result:AnyObject in fetchResults{
                
                hizuke = result.value(forKey: "saveDate") as? Date
                today = result.value(forKey: "fashion") as? String
                hitokoto = result.value(forKey: "memo") as? String
                
                syousai?.text = hitokoto
                
                // 日付を判断してそれにあった画像を表示
                if hizuke != nil && today != nil {
                    
                    let url = URL(string: today as String!)
                    let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                    let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
                    let manager: PHImageManager = PHImageManager()
                    manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                // 本日の写真を表示
                if (df.date(from: todayDateStartTime)! < hizuke! && df.date(from: todayDateEndTime)! > hizuke!){
                    self.syasin.image = image
                        }
                    }
                }
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
