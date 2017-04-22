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

class tuika: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    var myitem = NSMutableArray()
    var selectedDate = Date()
    
 
    @IBOutlet weak var mymy: UILabel!
    
    @IBOutlet weak var mydate: UITextField!
    
    @IBOutlet weak var myclothes: UIImageView!
    
    @IBOutlet weak var mymemo: UITextView!
    
    @IBOutlet weak var formview: UIView!
    
    var mycategory = ["トップス","ジャケット/アウター","パンツ","オールインワン・サロンペット","スカート","ワンピース","スーツ/ネクタイ/かりゆしウェア","バッグ","シューズ","ファッション雑貨","時計","ヘアアクセサリー","アクセサリー","アンダーウェア","レッグウェア","帽子","その他"]
    
    // 前画面から行番号を受け取るためのプロパティ
    var scSeletectedIndex = -1
    
    // datePicekrが乗るView(下に隠しておく)
    let baseView:UIView = UIView(frame: CGRect(x: 0, y: 720, width: 200, height: 250))
    
    let diaryDatePicker:UIDatePicker = UIDatePicker(frame: CGRect(x: 10, y: 20, width: 300, height: 220))

    let mySystemButton:UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // memoの枠線の色と大きさを設定
        self.mymemo.layer.borderColor = UIColor.black.cgColor
        self.mymemo.layer.borderWidth = 1
        // memoeを角丸にする
        self.mymemo.layer.cornerRadius = 20
        
        self.mymemo.layer.masksToBounds = true
        


        // Do any additional setup after loading the view.
        read()
        
        // datePickerのmodeを日付のみに設定
        diaryDatePicker.datePickerMode = UIDatePickerMode.date
        
        // イベントの追加
        diaryDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        
        //baseViewにdatePickerを配置
        baseView.addSubview(diaryDatePicker)
        
        //baseViewにボタンを配置
        // Systemボタンに配置するx,y座標とサイズを設定.
        mySystemButton.frame = CGRect(x: self.view.frame.width-60, y: 0, width: 50, height: 20)
        
        // Systemボタンにタイトルを設定する.
        mySystemButton.setTitle("Close", for: .normal)
        
        // イベントの追加
        mySystemButton.addTarget(self, action: #selector(closeDatePickerView(sender:)), for: .touchUpInside)
        
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
        mymemo.inputAccessoryView = upView
        
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
                myitem.add(["title":title,"date":saveDate,"collection":collection,"memo":memo])
                
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
                self.myclothes.image = image
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
        mymemo.resignFirstResponder()
        
        //日付のViewも一旦閉じる
        hideBaseView()
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.formview.frame.origin = CGPoint(x: 5, y:self.formview.frame.origin.y - 263)
            
            
            
        }, completion: {finished in print("上に現れました")})
        return true
    }

    //baseViewを隠す
    func hideBaseView(){
        self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
    }

    //DatePickerが載っているViewを閉じる
    func closeDatePickerView(sender: UIButton){
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
            
            
            
        }, completion: {finished in print("下に隠れました")})
    }
    
    //DatePickerで、選択している日付を変えた時、日付用のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        
        // フォーマットを設定
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        
        print(df.string(from: sender.date))
        
        let strSelectedDate = df.string(from: sender.date)
        
        mydate.text = strSelectedDate
        
    }
    
    // DatePickerが乗ったViewを隠す
    func closeDatePicker(sender:UIButton){
        UIView.animate(withDuration: 0.5, animations: {() -> Void in self.baseView.frame.origin = CGPoint(x: 0, y: self.view.bounds.height)})
    }
    
    func closeKeyboard(_ sender: UIButton){
        mymemo.resignFirstResponder()
        
        //formViewを元に戻す
        mymemo.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.formview.frame.origin = CGPoint(x: 5, y:self.formview.frame.origin.y + 263)
            
            
            
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
