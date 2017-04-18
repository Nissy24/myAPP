//
//  ViewController.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/03/27.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var myimage = NSMutableArray()

    @IBOutlet weak var one: UIImageView!
    
    @IBOutlet weak var two: UIImageView!
    
    @IBOutlet weak var three: UIImageView!
    
    @IBOutlet weak var four: UIImageView!
    
    @IBOutlet weak var five: UIImageView!
    
    @IBOutlet weak var six: UIImageView!
    
    @IBOutlet weak var seven: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var label7: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func myaddition(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //　配列初期化
        myimage = NSMutableArray()
        
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
        
        // 昨日の日付　”
        let secondDate = NSDate(timeInterval: -60*60*24*1, since: todayDate as Date)
        
        let secondDateStartTime = dfstart.string(from: secondDate as Date)
        
        print(secondDateStartTime)
        
        let secondDateEndTime = dfend.string(from: secondDate as Date)
        
        print(secondDateEndTime)
        
        // 二日前の日付　”
        let thirdDate = NSDate(timeInterval: -60*60*24*2, since: todayDate as Date)

        let thirdDateStartTime = dfstart.string(from: thirdDate as Date)
        
        print(thirdDateStartTime)
        
        let thirdDateEndTime = dfend.string(from: thirdDate as Date)
        
        print(thirdDateEndTime)
        
        // ３日前の日付　”
        let fourDate = NSDate(timeInterval: -60*60*24*3, since: todayDate as Date)
        
        let fourDateStartTime = dfstart.string(from: fourDate as Date)
        
        print(fourDateStartTime)
        
        let fourDateEndTime = dfend.string(from: fourDate as Date)
        
        print(fourDateEndTime)
        
        // 4日前の日付　”
        let fiveDate = NSDate(timeInterval: -60*60*24*4, since: todayDate as Date)
        
        let fiveDateStartTime = dfstart.string(from: fiveDate as Date)
        
        print(fiveDateStartTime)
        
        let fiveDateEndTime = dfend.string(from: fiveDate as Date)
        
        print(fiveDateEndTime)
        
        // 5日前の日付　”
        let sixDate = NSDate(timeInterval: -60*60*24*5, since: todayDate as Date)
        
        let sixDateStartTime = dfstart.string(from: sixDate as Date)
        
        print(sixDateStartTime)
        
        let sixDateEndTime = dfend.string(from: sixDate as Date)
        
        print(sixDateEndTime)
        
        // 6日前の日付　”
        let sevenDate = NSDate(timeInterval: -60*60*24*6, since: todayDate as Date)
        
        let sevenDateStartTime = dfstart.string(from: sevenDate as Date)
        
        print(sevenDateStartTime)
        
        let sevenDateEndTime = dfend.string(from: sevenDate as Date)
        
        print(sevenDateEndTime)

        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // todayをString型にしてnilをいれる
        var today: String? = nil
        
        // hizukeをDate型にしてnilをいれる
        var hizuke: Date? = nil
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myfashion> = Myfashion.fetchRequest()
        do {
            //データを一括取得
            let fetchResults = try! viewContext.fetch(query)
            // データの取得
            for result:AnyObject in fetchResults{
                // todayにnewFashionViewControllerの170行目のstrURLと一緒！！
                today = result.value(forKey: "fashion") as? String
                hizuke = result.value(forKey: "saveDate") as? Date
                
                if hizuke != nil && today != nil {
                    
                    let url = URL(string: today as String!)
                    let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                    let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
                    let manager: PHImageManager = PHImageManager()
                    manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                        
                        // 保存されているデータをデバッグエリアに表示
                        print(hizuke)
                        
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        // 本日の写真を表示
                        if (df.date(from: todayDateStartTime)! < hizuke! && df.date(from: todayDateEndTime)! > hizuke!){
                            self.one.image = image
                        }
                        
                        // １日前の写真を表示
                        if (df.date(from: secondDateStartTime)! < hizuke! && df.date(from: secondDateEndTime)! > hizuke!){
                            self.two.image = image
                        }
                        // 二日前の写真を表示
                        if (df.date(from: thirdDateStartTime)! < hizuke! && df.date(from: thirdDateEndTime)! > hizuke!){
                            self.three.image = image
                        }
                        // 三日前の写真を表示
                        if (df.date(from: fourDateStartTime)! < hizuke! && df.date(from: fourDateEndTime)! > hizuke!){
                            self.four.image = image
                        }
                        // 四日前の写真を表示
                        if (df.date(from: fiveDateStartTime)! < hizuke! && df.date(from: fiveDateEndTime)! > hizuke!){
                            self.five.image = image
                        }
                        // 五日前の写真を表示
                        if (df.date(from: sixDateStartTime)! < hizuke! && df.date(from: sixDateEndTime)! > hizuke!){
                            self.six.image = image
                        }
                        // 六日前の写真を表示
                        if (df.date(from: sevenDateStartTime)! < hizuke! && df.date(from: sevenDateEndTime)! > hizuke!){
                            self.seven.image = image
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
