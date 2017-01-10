//
//  PwdVC.swift
//  wp
//
//  Created by 木柳 on 2016/12/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class PwdVC: BaseTableViewController {

    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var repwdText: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    //MARK: --DATA
    func initData() {
        
    }
    //MARK: --UI
    func initUI() {
        
    }
    //MARK: --Function
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        if checkTextFieldEmpty([pwdText,repwdText]){
            if pwdText.text != repwdText.text{
                SVProgressHUD.showErrorMessage(ErrorMessage: "两次输入密码不一致，请重新输入", ForDuration: 1.5, completion: { 
                    self.pwdText.text = ""
                    self.repwdText.text = ""
                })
                return
            }else{
                //重置密码
                if true || UserModel.share().forgetPwd {
                    SVProgressHUD.showProgressMessage(ProgressMessage: "设定中...")
                    let password = ((pwdText.text! + AppConst.sha256Key).sha256()+UserModel.share().phone!).sha256()
                    AppAPIHelper.login().repwd(phone: UserModel.share().phone!, type: 1,  pwd: password, code: UserModel.share().code!, complete: { [weak self](result) -> ()? in
                        SVProgressHUD.showWainningMessage(WainningMessage: "设定成功", ForDuration: 1, completion: {
//                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.performSegue(withIdentifier: NickNameVC.className(), sender: nil)
                            self?.fetchUserInfo(phone: UserModel.share().phone!, pwd: password)
                        })
                        return nil
                    }, error: errorBlockFunc())
                    return
                }
                
                //注册
                SVProgressHUD.showProgressMessage(ProgressMessage: "设置中...")
                let password = ((pwdText.text! + AppConst.sha256Key).sha256()+UserModel.share().phone!).sha256()
                AppAPIHelper.login().register(phone: UserModel.share().phone!, code: UserModel.share().code!, pwd: password, complete: { [weak self](result) -> ()? in
                    SVProgressHUD.dismiss()
                    if result != nil {
                        if let code: Int = result?["result"] as! Int?{
                            if code == 0{
                                SVProgressHUD.showErrorMessage(ErrorMessage: "用户已注册", ForDuration: 1, completion: nil)
                                return nil
                            }
                        }
                        self?.fetchUserInfo(phone: UserModel.share().phone!, pwd: password)
                       
                    }else{
                        SVProgressHUD.showErrorMessage(ErrorMessage: "注册失败，请稍后再试", ForDuration: 1, completion: nil)
                    }
                    return nil
                    }, error: errorBlockFunc())

            }
        }
    }
    
    func fetchUserInfo(phone: String, pwd: String) {
        AppAPIHelper.login().login(phone: phone, pwd: pwd, complete: { ( result) -> ()? in
            SVProgressHUD.dismiss()
            //存储用户信息
            if result != nil{
                UserModel.upateUserInfo(userObject: result!)
            }else{
                SVProgressHUD.showErrorMessage(ErrorMessage: "更新用户信息失败", ForDuration: 1, completion: nil)
            }
            return nil
        }, error: errorBlockFunc())
    }

}
