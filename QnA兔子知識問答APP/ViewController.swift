//
//  ViewController.swift
//  QnA兔子知識問答APP
//
//  Created by Rose on 2021/5/10.
//

import UIKit
import AVFoundation

// 宣告 static 變數 data 儲存讀取 csv 產生的 array: 基本版
import CodableCSV
extension Bunny {
    static var data: [Self] {
        var array = [Self]()
        if let data = NSDataAsset(name: "bunny")?.data {
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine
            }
            do {
                array = try decoder.decode([Self].self, from: data)
            } catch {
                print(error)
            }
        }
        return array
    }
}

class ViewController: UIViewController {
    
    var bunny = Bunny.data
    
    //var questions = [Bunny]()
    //用變數紀錄第N題 從第一題開始
    var index = 0
    //統計問答的總數
    var count:Int = 1
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bunnyOff: UIImageView!
    @IBOutlet weak var bunnyOpen: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var speakButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(bunny[33])
        //預設值
        questionLabel.text = bunny[index].description
        answerLabel.text = ""
        
        //統計題目
        //totalLabel.text = String(bunny.count)
        let total = String(bunny.count)
        //統計題目
        totalLabel.text = String(index+1) + "/" + total
        
        //隨機出題
        //bunny.shuffle()
        bunnyOff.isHidden = false
        speakButton.isHidden = true
        
    }
    
    
    //顯示答案
    @IBAction func showAnswer(_ sender: Any) {
        answerLabel.text = bunny[index].answer
        //顯示答題的兔子狀態
        bunnyOpen.isHidden = false
        bunnyOff.isHidden = true
        speakButton.isHidden = false
    }
    
    // 下一個問題
    @IBAction func next(_ sender: Any) {
        // 先判斷 index沒有超出範圍
        // bunny.count取得陣列數量 -1是因為從0開始
        // 算式： index = (3+1)/4 = 0
        index = (index + 1) % bunny.count
        questionLabel.text = bunny[index].description
        answerLabel.text = ""
        
        // 題目累加
        //count = count + 1
        let total = String(bunny.count)
        //統計題目
        totalLabel.text = String(index+1) + "/" + total
        
        //顯示未答題的兔子狀態
        bunnyOpen.isHidden = true
        bunnyOff.isHidden = false
        speakButton.isHidden = true
        
        //進度條
        progressSlider.value = Float(index)
        
    }
    
    // 說出答案
    @IBAction func speak(_ sender: UIButton) {
        var speechUtterance = AVSpeechUtterance()
        speechUtterance = AVSpeechUtterance(string: "\(answerLabel.text!)")
        speechUtterance.rate = 0.5
        speechUtterance.pitchMultiplier = 1.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(speechUtterance)
    }
    
    
    //重玩
//    @IBAction func replay(_ sender: Any) {
//
//    }
    


}

