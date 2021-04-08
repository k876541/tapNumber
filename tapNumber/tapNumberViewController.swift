//
//  tapNumberViewController.swift
//  tapNumber
//
//  Created by Ryan Chang on 2021/4/4.
//

import UIKit
import AVFoundation

class tapNumberViewController: UIViewController {

    let player = AVPlayer()
    
    @IBOutlet var NumberButton: [UIButton]!
    @IBOutlet var passwordImageView: [UIImageView]!
    @IBOutlet weak var shakeView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var password = "1234"
    var code:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.alpha = CGFloat(0.25)
        // Do any additional setup after loading the view.
    }

    
    @IBAction func tapNumber(_ sender: UIButton) {
        //讓輸入的數字增加在密碼的最後一位（使用sender.tag來判斷輸入的位數）
        //這裡也是可以使用currenttitle來判斷點擊按鈕時,按鈕的文字判別成輸入的密碼
        code.append(String(sender.tag))
        
        //每輸入一個位數,就更改一張圖片
        imageChange()

        if code.count == 4 {
            if password == code {
                //讓畫面跳到correctPassword指向的view controller
                performSegue(withIdentifier: "correctPassword", sender: nil)
                    code = ""
                clear()
            }else {
                // 使用 CABasicAnimation 讓密碼錯誤的 view 震動 的方式 ！
                shake()
                
                //錯誤時播放音效
                sound()
                
                //呼叫UIAlertController ,然後把密碼清除,把圖片清除
                finish()
            }
        }
    }
    
    //刪除按鈕的動作
    @IBAction func deleteButton(_ sender: UIButton) {
        if code.count > 0 {
            passwordImageView[code.count - 1].image = UIImage(named: "")
            code.removeLast()
            print(code)
        }
    }
    
    //跳出警報視窗
    func finish() {
        let alert = UIAlertController(title: "你猜錯了！", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Again", style: .default, handler: { action in self.clear() })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //讓密碼的view搖晃
    func shake() {
        let codeShake = CABasicAnimation(keyPath: "position")
        codeShake.duration = 0.085
        codeShake.repeatCount = 3
        codeShake.fromValue = NSValue(cgPoint: CGPoint(x: shakeView.center.x - 10, y: shakeView.center.y))
        codeShake.toValue = NSValue(cgPoint: CGPoint(x: shakeView.center.x + 10, y: shakeView.center.y))
        shakeView.layer.add(codeShake, forKey: "position")
    }
    
    //每一個位數輸入後,都會改變圖片
    func imageChange() {
        switch code.count {
        case 1:
            passwordImageView[0].image = UIImage(named: "questionmark")
        case 2:
            passwordImageView[1].image = UIImage(named: "questionmark")
        case 3:
            passwordImageView[2].image = UIImage(named: "questionmark")
        case 4:
            passwordImageView[3].image = UIImage(named: "questionmark")
        default: break
        }
    }
    
    //把圖片清除
    func clear() {
        code = ""
        for i in 0...3 {
            passwordImageView[i].image = UIImage(named: "")
        }
    }
    
    //播放聲音
    func sound() {
        let fileUrl = Bundle.main.url(forResource: "wrong", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}
