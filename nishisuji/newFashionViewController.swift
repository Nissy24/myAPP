//
//  newFashionViewController.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/03/29.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import CoreData

class newFashionViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var myfashion = NSMutableArray()
    var selectedDate = Date()

    
    @IBOutlet weak var mydetail: UITextView!
    
    @IBOutlet weak var fashion: UIImageView!
    
    @IBOutlet weak var mydate: UILabel!
    
    @IBOutlet weak var mymemo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        
        print(df.string(from: Date()))

        mydate.text = df.string(from: Date())
        
        // Do any additional setup after loading the view.
        
        read()
    }
    
    // 既に存在するデータの読み込み処理
    func read(){
        
        //　配列初期化
        myfashion = NSMutableArray()
        
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myfashion> = Myfashion.fetchRequest()
        
        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            // データの取得
            for result:AnyObject in fetchResults{
                let title: String? = result.value(forKey: "title") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                let memo: String? = result.value(forKey: "memo") as? String
                let fashion: String? = result.value(forKey: "selectedPhotoURL") as? String
                let checkindate: Date? = result.value(forKey: "checkindate") as? Date
                
                print("title:\(title) saveDate:\(saveDate) memo:\(memo) fashion:\(fashion)) checkindate:\(checkindate)")
                
                // 記入されたタイトル,日付を配列に追加
                myfashion.add(["title":title,"date":saveDate,"selectedPhotoURL":fashion])
                
            }
        }catch{
        }
        
        // 後から変えるtodoListTableView.reloadData()
    }
    
    
    
    
    @IBAction func tapReturn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapsave(_ sender: UIButton) {
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // Myitemエンティティオブジェクトを作成
        let Myitem = NSEntityDescription.entity(forEntityName: "Myitem", in: viewContext)
        
        // Myitemエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: Myitem!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(mydate.text, forKey: "title") // 値を代入
        newRecord.setValue(Date(), forKey: "saveDate")//値を代入
        newRecord.setValue(Date(), forKey: "checkindate")
        newRecord.setValue(mymemo.text, forKey: "memo")
        newRecord.setValue(myfashion, forKey: "selectedPhotoURL")
        //newRecord.setValue(myclothes.(何か入れるよ！！！), forKey: "collection")
        
        do {
            // レコード（行）の即時保存
            try viewContext.save()
            
            // 再読み込み
            read()
        }catch{
        }

    }
    
    
    @IBAction func tapimage(_ sender: UITapGestureRecognizer) {
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {    //追記
    //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
    let controller = UIImagePickerController()
    
    controller.delegate = self
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
        self.fashion.image = image
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
