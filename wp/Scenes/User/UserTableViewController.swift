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
    
    @IBOutlet weak var iconImage: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      propertyNumber.isHidden = true
        integralLabel.isHidden = true
        nameLabel.isHidden = true
        yuanLabel.isHidden = true
        fenLabel.isHidden = true
        tableView.isScrollEnabled = false
        
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
    }
    //注册按钮
    @IBAction func registerDidClick(_ sender: Any) {
    }
    
    //我的资产
    @IBAction func myPropertyDidClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyWealtVC), object: nil, userInfo: nil)
        print("我的资产")
    }
    //个人中心
    @IBAction func myMessageDidClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.jumpToMyMessage), object: nil, userInfo: nil)
        sideMenuController?.toggle()
    }
    //我的积分
    @IBAction func myIntegral(_ sender: Any) {
        print("我的积分")
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
    
  
   
}
