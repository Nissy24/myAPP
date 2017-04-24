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

class newFashionViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate{
    
    var myfashion = NSMutableArray()
    var selectedDate = Date()

    
    @IBOutlet weak var mydetail: UITextView!
    
    @IBOutlet weak var fashion: UIImageView!
    
    @IBOutlet weak var mydate: UILabel!
    
    @IBOutlet weak var mymemo: UILabel!
    
    @IBOutlet weak var formview: UIView!
    
    let mySystemButton:UIButton = UIButton(type: .system)
    
    // datePicekrが乗るView(下に隠しておく)
    let baseView:UIView = UIView(frame: CGRect(x: 0, y: 720, width: 200, height: 250))
    
    let diaryDatePicker:UIDatePicker = UIDatePicker(frame: CGRect(x: 10, y: 20, width: 300, height: 220))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        
        print(df.string(from: Date()))

        mydate.text = df.string(from: Date())
        
        read()
        
        // memoの枠線の色と大きさを設定
        self.mydetail.layer.borderColor = UIColor.black.cgColor
        self.mydetail.layer.borderWidth = 1
        // memoeを角丸にする
        self.mydetail.layer.cornerRadius = 20
        
        self.mydetail.layer.masksToBounds = true
        
        // datePickerのmodeを日付のみに設定
        diaryDatePicker.datePickerMode = UIDatePickerMode.date
        
        //baseViewにdatePickerを配置
        baseView.addSubview(diaryDatePicker)
        
        //baseViewにボタンを配置
        // Systemボタンに配置するx,y座標とサイズを設定.
        mySystemButton.frame = CGRect(x: self.view.frame.width-60, y: 0, width: 50, height: 20)
        
        // Systemボタンにタイトルを設定する.
        mySystemButton.setTitle("Close", for: .normal)
        
        //baseViewにボタンを配置
        baseView.addSubview(mySystemButton)
        
        
        //下にピッタリ配置、横幅ピッタリの大きさにしておく
        baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        
        baseView.frame.size = CGSize(width: self.view.frame.width, height: baseView.frame.height)
        
        
        baseView.backgroundColor = UIColor.gray
        self.view.addSubview(baseView)
        
        
        //キーボードの上にcloseボタンを配置
        //ビューを作成する。
        let upView = UIView()
        upView.frame.size.height = 60
        upView.backgroundColor = UIColor.lightGray
        
        //「閉じるボタン」を作成する。
        let closeButton = UIButton(frame:CGRect(x:self.view.bounds.size.width-70, y:0, width:70, height:50))
        closeButton.setTitle("閉じる", for: .normal)
        
        
        closeButton.addTarget(self, action: #selector(closeKeyboard(_:)), for: .touchUpInside)
        
        //ビューに「閉じるボタン」を追加する。
        upView.addSubview(closeButton)
        
        //キーボードのアクセサリにビューを設定する。
        mydetail.inputAccessoryView = upView
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
                let fashion: String? = result.value(forKey: "fashion") as? String
                let checkindate: Date? = result.value(forKey: "checkindate") as? Date
                
                print("title:\(title) saveDate:\(saveDate) memo:\(memo) fashion:\(fashion)) checkindate:\(checkindate)")
                
                // 記入されたタイトル,日付を配列に追加
                myfashion.add(["title":title,"date":saveDate,"fashion":fashion,"checkindeate":checkindate])
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
        
        // Myfashionエンティティオブジェクトを作成
        let Myfashion = NSEntityDescription.entity(forEntityName: "Myfashion", in: viewContext)
        
        // Myitemエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: Myfashion!, insertInto: viewContext)
        
        let myDefault = UserDefaults.standard
        
        let huku = myDefault.string(forKey: "selectedPhotoURL")
        
        deletetoday()
        
        //値のセット
        newRecord.setValue(mydate.text, forKey: "title") // 値を代入
        newRecord.setValue(Date(), forKey: "saveDate")//値を代入
        newRecord.setValue(Date(), forKey: "checkindate")
        newRecord.setValue(mydetail.text, forKey: "memo")
        newRecord.setValue(huku, forKey: "fashion")
                
        do {
            // レコード（行）の即時保存
            try viewContext.save()
            
            // 再読み込み
//            read()
        }catch{
        }

        // 部品のアラートを作る
        let alertController = UIAlertController(title:"保存完了", message: "",preferredStyle: .alert)
        
        // OKボタンを追加
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // アラートを表示する
        present(alertController, animated: true, completion: nil)
    }
    
    // 全部を読み込んで、おんなじ日付のやつを消して、最新だけを貰う
    func deletetoday(){
        //　配列初期化
        myfashion = NSMutableArray()
        
        // dfに詳しい日付を入れる
        let dfstart = DateFormatter()
        dfstart.dateFormat = "yyyy-MM-dd 00:00:00"
        
        let dfend = DateFormatter()
        dfend.dateFormat = "yyyy-MM-dd 23:59:59"
        
        // 今日の日付の始まりをデッバックエリアに表示
        let todayDate = NSDate()
        
        let todayDateStartTime = dfstart.string(from: todayDate as Date)
        
        print(todayDateStartTime)
        
        // 今日の日付の終わりをデッバックエリアに表示
        let todayDateEndTime = dfend.string(from: todayDate as Date)
        
        print(todayDateEndTime)
        
        

        
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // todayをString型にしてnilをいれる
        var today: String? = nil
        
        // hizukeをDate型にしてnilをいれる
        var hizuke: Date? = nil
        
        let query: NSFetchRequest<Myfashion> = Myfashion.fetchRequest()
        
        do {
            //データを一括取得
            let fetchResults = try! viewContext.fetch(query)
            
            // データの取得
            for result:AnyObject in fetchResults{
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                //今日のデータだったら、消す！（最新だけ残す）
                today = result.value(forKey: "fashion") as? String
                hizuke = result.value(forKey: "saveDate") as? Date
                
                if hizuke != nil && today != nil {
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    // 本日の写真を表示
                    if (df.date(from: todayDateStartTime)! < hizuke! && df.date(from: todayDateEndTime)! > hizuke!){
                            let record = result as! NSManagedObject
                            // 一行ずつ削除
                            viewContext.delete(record)
                    }
                }
            }
            // 削除した状態を保存
            try! viewContext.save()
            
            // 再読み込み
//            read()
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
        
        imagePicker.dismiss(animated: true, completion: nil)
        
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
    
    // テキストフィールド入力開始
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        
        print(textField.tag)
        
        // 日付のtextfield
        // baseViewの表示
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - self.baseView.frame.height)
        })
        // キーボードを出さないようにする
        return false
    }
    
    // baseViewを表示して、
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing\n")
        
        print(textView.tag)
        
        //キーボードが出てたら閉じる
        mydetail.resignFirstResponder()
        
        //日付のViewも一旦閉じる
        hideBaseView()
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.formview.frame.origin = CGPoint(x: 5, y:self.formview.frame.origin.y - 250)
            
            
            
        }, completion: {finished in print("上に現れました")})
        return true
    }
    
    
    //baseViewを隠す
    func hideBaseView(){
        self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
    }

    
    func closeKeyboard(_ sender: UIButton){
        mydetail.resignFirstResponder()
        
        //formViewを元に戻す
        mydetail.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.formview.frame.origin = CGPoint(x: 5, y:self.formview.frame.origin.y + 250)
            
            
            
        }, completion: {finished in print("上に現れました")})
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
