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
    
    var scmemo:Date = Date()
    
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
                
                // 日付を判断してそれにあった画像を表示
                if hizuke != nil && today != nil {
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        // 本日の写真を表示
                        if (hizuke == scmemo){
                            displayImage(displayurl: today!)
                            // hitokotoをmymemoに代入
                            mymemo?.text = hitokoto
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy/MM/dd"
                            let dateString: String = dateFormatter.string(from: hizuke!)
                            
                            myLabel?.text = dateString


                        }
                    }
                }
        }
        
    }
    
    // 表示したい画像のURLと日を表す数字を渡して、画像表示
    func displayImage(displayurl:String){
        let url = URL(string: displayurl as String!)
        var options:PHImageRequestOptions = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isSynchronous = true
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
        let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
        let manager: PHImageManager = PHImageManager()
        manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: options) { (image, info) -> Void in
                self.myhuku.image = image
        }
    }

    func deleteDate(){
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Myitem> = Myitem.fetchRequest()
        
        let namePredicte = NSPredicate(format: "saveDate = %@", scmemo as CVarArg)
        
        request.predicate = namePredicte
        
        do{
            //データを一括取得
            let fetchResults = try! viewContext.fetch(request)
            
            for result: AnyObject in fetchResults{
            let record = result as! NSManagedObject
            // 一行ずつ削除
            viewContext.delete(record)
            }
            try viewContext.save()
            
            navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
        }catch{
        }
    }
    
    @IBAction func mydelete(_ sender: UIButton) {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "アイテム削除", message: "削除してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in self.deleteDate()
            print("OK")
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
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
