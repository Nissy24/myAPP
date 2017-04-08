//
//  tuika.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/02.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices

class tuika: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var myitem = NSMutableArray()
    var selectedDate = Date()
    
 
    @IBOutlet weak var mymy: UILabel!
    
    @IBOutlet weak var buydate: UILabel!
    
    @IBOutlet weak var myclothes: UIImageView!
    
    @IBOutlet weak var mymemo: UITextView!
    
    
    var mycategory = ["トップス","ジャケット/アウター","パンツ","オールインワン・サロンペット","スカート","ワンピース","スーツ/ネクタイ/かりゆしウェア","バッグ","シューズ","ファッション雑貨","時計","ヘアアクセサリー","アクセサリー","アンダーウェア","レッグウェア","帽子","その他"]
    
    // 前画面から行番号を受け取るためのプロパティ
    var scSeletectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        read()
    }
    
    // 既に存在するデータの読み込み処理
    func read(){
        
        //　配列初期化
        myitem = NSMutableArray()
        
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myitem> = Myitem.fetchRequest()
        
        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            // データの取得
            for result:AnyObject in fetchResults{
                let title: String? = result.value(forKey: "title") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                let memo: String? = result.value(forKey: "memo") as? String
                let collection: String? = result.value(forKey: "collection") as? String
                let checkindate: Date? = result.value(forKey: "checkindate") as? Date
                
                print("title:\(title) saveDate:\(saveDate) memo:\(memo) collection:\(collection) checkindate:\(checkindate)")
                
                // 記入されたタイトル,日付を配列に追加
                myitem.add(["title":title,"date":saveDate,"collection":collection])
                
            }
        }catch{
        }
        
        // 後から変えるtodoListTableView.reloadData()
    }

    
    // 画面が表示される度に起動
    override func viewWillAppear(_ animated: Bool) {
        print("前の画面から\(scSeletectedIndex)行目が選択されました")
        
        mymy.text = mycategory[scSeletectedIndex]
    }

    @IBAction func savecollection(_ sender: UIButton) {
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // Myitemエンティティオブジェクトを作成
        let Myitem = NSEntityDescription.entity(forEntityName: "Myitem", in: viewContext)
    
        // Myitemエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: Myitem!, insertInto: viewContext)
        
        let myDefault = UserDefaults.standard
        
        let item = myDefault.string(forKey: "selectedPhotoURL")
        
        //値のセット
        newRecord.setValue(mymy.text, forKey: "title") // 値を代入
        newRecord.setValue(Date(), forKey: "saveDate")//値を代入
        newRecord.setValue(Date(), forKey: "checkindate")
        newRecord.setValue(mymemo.text, forKey: "memo")
        newRecord.setValue(item, forKey: "collection")
        
        do {
            // レコード（行）の即時保存
            try viewContext.save()
            
            // 再読み込み
            read()
        }catch{
        }
    }
    
    @IBAction func mycategoryitem(_ sender: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {    //追記
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
            let controller = UIImagePickerController()
            
            controller.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    //カメラロールで写真を選んだ後
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        
        let strURL:String = assetURL.description
        
        print(strURL)
        
        
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        
        // データを書き込んで
        myDefault.set(strURL, forKey: "selectedPhotoURL")
        
        // 即反映させる
        myDefault.synchronize()
        
        
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
        if strURL != nil{
            
            let url = URL(string: strURL as String!)
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
