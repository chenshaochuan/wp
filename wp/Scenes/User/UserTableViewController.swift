//
//  UserTableViewController.swift
//  wp
//
//  Created by macbook air on 16/12/22.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SideMenuController
class UserTableViewController: BaseTableViewController {
    //头像
    @IBOutlet weak var iconImage: UIImageView!
    //用户名
    @IBOutlet weak var nameLabel: UILabel!
    //资金
    @IBOutlet weak var propertyNumber: UILabel!
    @IBOutlet weak var yuanLabel: UILabel!
    //积分
    @IBOutlet weak var integralLabel: UILabel!
    @IBOutlet weak var fenLabel: UILabel!
    //未登录时的占位
    @IBOutlet weak var concealLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    //登录
    @IBOutlet weak var loginBtn: UIButton!
    //注册
    @IBOutlet weak var register: UIButton!
    //跳转按钮
    @IBOutlet weak var pushBtn: UIButton!
    //资金按钮
    @IBOutlet weak var myPropertyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotify()
        if checkLogin() {
            loginBtn.isHidden = true
            register.isHidden = true
            concealLabel.isHidden = true
            integralLabel.isHidden = true
            fenLabel.isHidden = true
            pushBtn.isHidden = false
            myPropertyBtn.isHidden = false
            placeholderLabel.isHidden = false
            propertyNumber.text = "\(UserModel.getCurrentUser()!.balance)0"
            if ((UserModel.getCurrentUser()?.avatarLarge) != ""){
                iconImage.image = UIImage(named: (UserModel.getCurrentUser()?.avatarLarge) ?? "")
            }
            else{
                iconImage.image = UIImage(named: "default-head")
            }
            if ((UserModel.getCurrentUser()?.screenName) != "") {
                nameLabel.text = UserModel.getCurrentUser()?.screenName
                nameLabel.sizeToFit()
                
            }
            else{
                nameLabel.text = "Bug退散"
            }
        }
        else{
            myPropertyBtn.isHidden = true
            propertyNumber.isHidden = true
            nameLabel.isHidden = true
            yuanLabel.isHidden = true
            pushBtn.isHidden = true
            integralLabel.isHidden = true
            fenLabel.isHidden = true
            tableView.isScrollEnabled = false
        }
    }
    //MARK: -- 添加通知
    func registerNotify() {
        let notificationCenter = NotificationCenter.default
        //退出登录
        notificationCenter.addObserver(self, selector: #selector(quitEnterClick), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.QuitEnterClick), object: nil)
        //登录成功
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
        //修改个人信息
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.ChangeUserinfo), object: nil)
        
    }
    
    func updateUI()  {
        
        if ((UserModel.getCurrentUser()?.avatarLarge) != ""){
            iconImage.image = UIImage(named: (UserModel.getCurrentUser()?.avatarLarge) ?? "")
        }
        else{
            iconImage.image = UIImage(named: "default-head")
        }
        
        if ((UserModel.getCurrentUser()?.screenName) != "") {
            nameLabel.text = UserModel.getCurrentUser()?.screenName
            nameLabel.sizeToFit()
        }
        else{
            nameLabel.text = "Bug退散"
        }
        loginBtn.isHidden = true
        register.isHidden = true
        concealLabel.isHidden = true
        placeholderLabel.isHidden = false
        propertyNumber.isHidden = false
        integralLabel.isHidden = true
        nameLabel.isHidden = false
        yuanLabel.isHidden = false
        fenLabel.isHidden = true
        pushBtn.isHidden = false
        myPropertyBtn.isHidden = false
        
        //用户余额数据请求
        AppAPIHelper.user().accinfo(complete: {[weak self](result) -> ()? in
            if let object = result {
                let  money : Double =  object["balance"] as! Double
                self?.propertyNumber.text =  "\(money)0"
                UserModel.updateUser(info: { (result)-> ()? in
//<<<<<<< HEAD
//                    UserModel.share().currentUser?.balance = Int(money)
//=======
                    UserModel.share().currentUser?.balance = Double(money)
//>>>>>>> wp/master
                })
            }
            //个人信息数据请求
            AppAPIHelper.user().getUserinfo(complete: { [weak self](result) -> ()? in
                if let modes: [UserInfo] = result as? [UserInfo]{
                    let model = modes.first
                    UserModel.updateUser(info: { (result) -> ()? in
                        if model!.avatarLarge != nil {
                           UserModel.share().currentUser?.avatarLarge = model!.avatarLarge
                        }
                        UserModel.share().currentUser?.screenName = model!.screenName
                        UserModel.share().currentUser?.phone = model!.phone
                        return nil
                    })
                }
                return nil
                }, error: self?.errorBlockFunc())
            return nil
            }, error: errorBlockFunc())
       
        
        
    }
    
    func quitEnterClick() {
        propertyNumber.isHidden = true
        integralLabel.isHidden = true
        nameLabel.isHidden = true
        yuanLabel.isHidden = true
        fenLabel.isHidden = true
        pushBtn.isHidden = true
        loginBtn.isHidden = false
        register.isHidden = false
        concealLabel.isHidden = false
        placeholderLabel.isHidden = false
        myPropertyBtn.isHidden = true
        iconImage.image = UIImage(named: "default-head.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5 {
            
            return 10
        }
        return 0
    }
    //登录按钮
    @IBAction func enterDidClick(_ sender: Any) {
        
        if checkLogin() {
            
        }
        
    }
    //注册按钮
    @IBAction func registerDidClick(_ sender: Any) {
        
        let homeStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
        let nav: UINavigationController = homeStoryboard.instantiateInitialViewController() as! UINavigationController
        let controller = homeStoryboard.instantiateViewController(withIdentifier: RegisterVC.className())
        nav.pushViewController(controller, animated: true)
        present(nav, animated: true, completion: nil)
        
        print("我的注册")
        
    }
    //我的资产
    @IBAction func myPropertyDidClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyWealtVC), object: nil, userInfo: nil)
        print("我的资产")
        sideMenuController?.toggle()
    }
    //个人中心
    @IBAction func myMessageDidClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyMessage), object: nil, userInfo: nil)
        sideMenuController?.toggle()
    }
    //我的积分
    @IBAction func myIntegral(_ sender: Any) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section =  indexPath.section
        switch section {
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyAttention), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            print("我的关注")
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyPush), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            print("我的推单")
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyBask), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            print("我的晒单")
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToDeal), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            
            print("交易明细")
        case 5:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToFeedback), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            print("意见反馈")
        case 6:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToProductGrade), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            print("产品评分")
        case 7:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToAttentionUs), object: nil, userInfo: nil)
            sideMenuController?.toggle()
            print("关注我们")
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
