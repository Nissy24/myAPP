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
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 今日の日付をデッバックエリアに表示
        let now = NSDate()
        let todaypicture = df.string(from: now as Date)
        
        print(todaypicture)
        
        // 昨日の日付　”
        let secondpicture = NSDate(timeInterval: -60*60*24*1, since: now as Date)
        
        print(secondpicture)
        
        // 二日前の日付　”
        let thirdpicture = NSDate(timeInterval: -60*60*24*2, since: now as Date)
        
        print(thirdpicture)
        
        // ３日前の日付　”
        let fourpicture = NSDate(timeInterval: -60*60*24*3, since: now as Date)
        
        print(fourpicture)
        
        // 4日前の日付　”
        let fivepicture = NSDate(timeInterval: -60*60*24*4, since: now as Date)
        
        print(fivepicture)
        
        // 5日前の日付　”
        let sixpicture = NSDate(timeInterval: -60*60*24*5, since: now as Date)
        
        print(sixpicture)
        
        // 6日前の日付　”
        let sevenpicture = NSDate(timeInterval: -60*60*24*6, since: now as Date)
        
        print(sevenpicture)

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
                
                
                
        }
        }catch{
        }
        if today != nil {
        
            let url = URL(string: today as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
        self.one.image = image
        
        }
        two.image = UIImage(named: "")
        
        three.image = UIImage(named: "")
        
        four.image = UIImage(named: "")
        
        five.image = UIImage(named: "")
        
        six.image = UIImage(named: "")
        
        seven.image = UIImage(named: "")
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
