//
//  clothes.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/02.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices


class clothes: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var mymemo: UITextView!
    
    @IBOutlet weak var myhuku: UIImageView!
    
    var selectedIndex = -1

    var myimage = NSMutableArray()
    
    var selectimageIndex = NSDate()
    
    var scmemo:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    // 画面が表示される度に起動
    override func viewWillAppear(_ animated: Bool) {
        
        // memoの枠線の色と大きさを設定
        self.mymemo.layer.borderColor = UIColor.black.cgColor
        self.mymemo.layer.borderWidth = 1
        // memoeを角丸にする
        self.mymemo.layer.cornerRadius = 20
        
        self.mymemo.layer.masksToBounds = true
        

        
        print("前の画面から\(selectedIndex)行目が選択されました")
        
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
        
        // mumuをDate型にしてnilをいれる
        var mumu: Date? = nil
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myitem> = Myitem.fetchRequest()
        do {
            //データを一括取得
            let fetchResults = try! viewContext.fetch(query)
            // データの取得
            for result:AnyObject in fetchResults{
                
                hizuke = result.value(forKey: "saveDate") as? Date
                today = result.value(forKey: "collection") as? String
                hitokoto = result.value(forKey: "memo") as? String
                mumu = result.value(forKey: "checkindate") as? Date
               
                
                // hitokotoをmymemoに代入
                mymemo?.text = hitokoto
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let dateString: String = dateFormatter.string(from: mumu!)
                
                myLabel?.text = dateString
                
                
                
                // 日付を判断してそれにあった画像を表示
                if hizuke != nil && today != nil {
                    
                    var options:PHImageRequestOptions = PHImageRequestOptions()
                    options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
                    let url = URL(string: today as String!)
                    let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                    let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
                    let manager: PHImageManager = PHImageManager()
                    manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: options) { (image, info) -> Void in
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        // 本日の写真を表示
                        if (df.date(from: todayDateStartTime)! < hizuke! && df.date(from: todayDateEndTime)! > hizuke!){
                            self.myhuku.image = image
                            
                            
                        }
                    }
                }
                
            }
        }catch{
            
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
