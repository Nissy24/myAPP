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
import GoogleMobileAds

class tansu: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GADBannerViewDelegate {
    
    var mycategory = ["トップス","ジャケット/アウター","パンツ","オールインワン・サロンペット","スカート","ワンピース","スーツ/ネクタイ/かりゆしウェア","バッグ","シューズ","ファッション雑貨","時計","ヘアアクセサリー","アクセサリー","アンダーウェア","レッグウェア","帽子","その他"]

    var selectedIndex = -1
    
    var myimage = NSMutableArray()

    var selectimageIndex = NSDate()
    
    // AdMod ID を入れてください
    let AdMobID = "ca-app-pub-3530000000000000/0123456789"
    let TEST_DEVICE_ID = "61b0154xxxxxxxxxxxxxxxxxxxxxxxe0"
    
    let AdModTest:Bool = true
    let SimulatorTest:Bool = true
    
    @IBOutlet weak var mycollectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(myimage)
        
        read()
        
        showAdBanner()
    }
    
    // 広告を表示する
    func showAdBanner(){
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - 60)
        
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        admobView.adUnitID = AdMobID
        admobView.delegate = self
        admobView.rootViewController = self
        
        let admobRequest = GADRequest()
        
        
        if(AdModTest){
            // simulator テスト
            if SimulatorTest {
                admobRequest.testDevices = [kGADSimulatorID]
                print("simulator")
            }
                // 実機テスト
            else {
                admobRequest.testDevices = [TEST_DEVICE_ID]
                print("device")
            }
        }
            // 本番
            admobView.load(admobRequest)
        
        
        
        self.view.addSubview(admobView)
        
    }

    // collectionViewが選択された時に発動
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
//        print("\(indexPath.row)行目が選択されました")
//        
//        // メンバ変数に行番号を保存
//        selectedIndex = indexPath.row
//
//        // セグエを指定して画面遷移
//        performSegue(withIdentifier: "hyouzi", sender: indexPath)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
    func read(){
        
    
        //　配列初期化
        myimage = NSMutableArray()
        
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // todayをString型にしてnilをいれる
        var today: String? = nil
        // mydateをDate型にしてnilをいれる
        var mydate: Date? = nil
        // myhukuをString型にしてnilをいれる
        var myhuku: String? = nil
        
        // hitokotoをString型にしてnilをいれる
        var hitokoto: String? = nil
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myitem> = Myitem.fetchRequest()
        do {
            //データを一括取得
            let fetchResults = try! viewContext.fetch(query)
            // データの取得
            for result:AnyObject in fetchResults{
                // todayにnewFashionViewControllerの170行目のstrURLと一緒！！
                today = result.value(forKey: "collection") as? String
                mydate = result.value(forKey: "saveDate") as? Date
                myhuku = result.value(forKey: "title") as? String
                hitokoto = result.value(forKey: "memo") as? String
                
                // if文でカテゴリーがタップしたら別で表示する。
                if myhuku == mycategory[selectedIndex] {
                // 記入したタイトル、画像、日付を追加
                myimage.add(["collection":today,"saveDate":mydate,"title":mycategory,"memo":hitokoto])
                }
                
            }
        }catch{
        }
    }

    
    //セクション数の設定 テーブルビューでは省略
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Item数の設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myimage.count
    }
    
    //セル内に表示するデータの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cellオブジェクト
        let cell:customImage = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! customImage
        
        // 配列から画像と日付の情報を取得
        let dic = myimage[indexPath.row] as! NSDictionary
        
        var imageview: String? = dic["collection"] as! String
        var mydate: Date? = dic["saveDate"] as! Date
        
        
        // 画像の表示
        if imageview != nil {
            
            var options:PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.isSynchronous = true
            let url = URL(string: imageview as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: options) { (image, info) -> Void in
                cell.myitem?.image = image
                
            }
        }
        
        
       // cell.myitem?.image = UIImage(named: "")
        
        //　背景色の設定
        cell.backgroundColor = UIColor.white
        
        // 作成したcellオブジェクトを戻り値として返す
        return cell
        
        
    }
    
    // collectionViewがタップされた時発動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        // メンバ変数に行番号を保存
                selectedIndex = indexPath.row
        
                // セグエを指定して画面遷移
                performSegue(withIdentifier: "hyouzi", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier! == "hyouzi") {
            let hukuitem = segue.destination as! clothes

            // 配列から画像と日付の情報を取得
            let dic = myimage[(sender as! IndexPath).row] as! NSDictionary
            
            //私が書きました
            hukuitem.scmemo = ((dic["saveDate"] as? Date))!
                }
    }
    
    @IBAction func mydelete(_ sender: UILongPressGestureRecognizer) {
        
        let point: CGPoint =  sender.location(in: self.mycollectionview)
        let indexPath = self.mycollectionview.indexPathForItem(at: point)
        
        print(indexPath?.row)
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
            (action: UIAlertAction!) -> Void in
            print("OK")
            
            
            
            
            // AppDelegateを使う用意をしておく
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // エンティティを操作するためのオブジェクトを作成
            let viewContext = appDelegate.persistentContainer.viewContext
            
             let request: NSFetchRequest<Myitem> = Myitem.fetchRequest()
            
            let picture = NSPredicate(format: "saveDate = %@" , self.selectimageIndex as CVarArg)
            
            request.predicate = picture
            
            do{
            //データを一括取得
            let fetchResults = try! viewContext.fetch(request)
            
            // todayをString型にしてnilをいれる
            var today: String? = nil
            
            // データの取得
            for result:AnyObject in fetchResults{
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                //今日のデータだったら、消す！（最新だけ残す）
                today = result.value(forKey: "collection") as? String
                
            let record = result as! NSManagedObject
                
            // 一行ずつ削除
            viewContext.delete(record)
                
                
                let view: UIImageView = UIImageView()
                view.removeFromSuperview()
            
                try! viewContext.save()
                }}})
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
