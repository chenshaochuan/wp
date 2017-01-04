//
//  ShareVC.swift
//  wp
//
//  Created by 木柳 on 2016/12/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
protocol VistorLoginViewDelegate:NSObjectProtocol {
    //设置协议方法
    func visitorViewRegisterViewSelected()
}
class ShareVCCell: UITableViewCell {
    
    
    var delegate: VistorLoginViewDelegate?
    /// 头像
    @IBOutlet weak var iconImage: UIImageView!
    ///  头像
    @IBOutlet weak var userImage: UIImageView!
    ///  姓名
    @IBOutlet weak var nameLabel: UILabel!
    ///  类型
    @IBOutlet weak var typeLabel: UILabel!
    ///  时间
    @IBOutlet weak var timeLabel: UILabel!
    ///  收益
    @IBOutlet weak var benifityLabel: UILabel!
    
    
    
//    override func update(_ data: Any!) {
//        let dataModel = data as! TestModel
//        nameLabel.text = dataModel.name
//    }
}

class ShareVC: BaseListTableViewController {
    
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var weekBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    private var lastTypeBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translucent(clear: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        translucent(clear: false)
    }
    //MARK: --DATA
    func initData() {
        
    }
    
    override func didRequest() {
         self.didRequestComplete([""] as AnyObject)
        
        AppAPIHelper.share().getData(userId: "122222", phone: "121323", complete: { [weak self](result) -> ()? in
//            self?.reloadda(parm: result as! NSDictionary)
            
           
            return nil
            
            }, error: errorBlockFunc())
        

//        didRequestComplete([model,model,model] as AnyObject)
    }
    
    
    //MARK: --UI
    func initUI() {
        
        tableView.rowHeight = 66
        rankTypeBtnTapped(dayBtn)
        tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
    }
    //MARK: --昨天之星，上周名人，月度名人
    @IBAction func rankTypeBtnTapped(_ sender: UIButton) {
        if let btn = lastTypeBtn {
            btn.isSelected = false
            btn.backgroundColor = UIColor.white
        }
        sender.isSelected = true
        sender.backgroundColor = AppConst.Color.CMain
        lastTypeBtn = sender
    }
    
   
}
