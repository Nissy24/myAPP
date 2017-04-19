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

class everyday: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var myimage = NSMutableArray()

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
        
        // 今日の日付の始まりをデッバックエリアに表示
        let todayDate = NSDate()
        
        let todayDateStartTime = dfstart.string(from: todayDate as Date)
        
        print(todayDateStartTime)
        
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // hizukeをDate型にしてnilをいれる
        var hizuke: Date? = nil
        
        // todayをString型にしてnilをいれる
        var today: String? = nil
        
        // どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<Myfashion> = Myfashion.fetchRequest()
        do {
            //データを一括取得
            let fetchResults = try! viewContext.fetch(query)
            // データの取得
            for result:AnyObject in fetchResults{
                
                hizuke = result.value(forKey: "saveDate") as? Date
                today = result.value(forKey: "fashion") as? String

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
