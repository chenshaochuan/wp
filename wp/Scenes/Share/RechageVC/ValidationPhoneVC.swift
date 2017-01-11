//
//  ValidationPhoneVC.swift
//  wp
//
//  Created by sum on 2017/1/6.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class ValidationPhoneVC: BaseTableViewController {
    
    //验证码数字
    @IBOutlet weak var code: UITextField!
    
    // 银行卡交验信息
    @IBOutlet weak var information: UILabel!
    
    // 发送验证码
    @IBOutlet weak var voiceCodeBtn: UIButton!
    // 定时器
    private var timer: Timer?
    // 定时器倒计时时间
    private var codeTime = 60
    override func viewDidLoad() {
        super.viewDidLoad()

       title = "验证手机号"
    
        
        
        
    }
    // 网络请求
    override func didRequest() {
        
        
        
        
        
        
//       AppAPIHelper.user().bingcard(bank: "", branchBank: "", province: "", city: "", cardNo: "", name: "", complete: { (result) -> ()? in
//        
//       }, error: errorBlockFunc())
        
    }
    @IBAction func bindBank(_ sender: Any) {
        
       
        AppAPIHelper.user().bingcard(bank:  ShareModel.share().name, branchBank: ShareModel.share().name, cardNo: ShareModel.share().name, name: ShareModel.share().name, complete: { (result) -> ()? in
            
            return nil
        }, error: errorBlockFunc())
    
    }
    //MARK: --点击发送验证码
    @IBAction func requestVoiceCode(_ sender: UIButton) {
          self.voiceCodeBtn.isEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateBtnTitle), userInfo: nil, repeats: true)
    }
    // 更新倒计时时间
    func updateBtnTitle() {
        if codeTime == 0 {
            voiceCodeBtn.isEnabled = true
            voiceCodeBtn.setTitle("重新发送", for: .normal)
            codeTime = 60
            timer?.invalidate()
            return
        }
        voiceCodeBtn.isEnabled = false
        codeTime = codeTime - 1
        let title: String = "\(codeTime)秒后重新发送"
        voiceCodeBtn.setTitle(title, for: .normal)
    }
   
}
