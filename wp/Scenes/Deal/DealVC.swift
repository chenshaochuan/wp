//
//  DealVC.swift
//  wp
//
//  Created by 木柳 on 2016/12/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class DealVC: BaseTableViewController, TitleCollectionviewDelegate {
    
    @IBOutlet weak var myMoneyLabel: UILabel!
    @IBOutlet weak var myQuanLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var upDownView: UIView!
    @IBOutlet weak var winRateConstraint: NSLayoutConstraint!
    @IBOutlet weak var kLineView: KLineView!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var dealTable: MyDealTableView!
    @IBOutlet weak var titleView: TitleCollectionView!
    private var klineBtn: UIButton?
    
    //MARK: --Test
    @IBAction func testItemTapped(_ sender: Any) {
        //        initDealTableData()
        initProductData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showTabBarWithAnimationDuration()
    }
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3) {
            self.winRateConstraint.constant = 100
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
      //  hideTabBarWithAnimationDuration()
    }
    deinit {
        DealModel.share().removeObserver(self, forKeyPath: "selectDealModel")
    }
    //MARK: --DATA
    func initData() {
        //初始化持仓数据
        initDealTableData()
        //初始化下商品数据
        initProductData()
        //持仓点击
        DealModel.share().addObserver(self, forKeyPath: "selectDealModel", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectDealModel" {
            if DealModel.share().type == .btnTapped {
                UserDefaults.standard.removeObject(forKey: SocketConst.Key.id)
                return
            }
            
            if DealModel.share().type == .cellTapped {
                DealModel.share().isDealDetail = true
                performSegue(withIdentifier: BuyVC.className(), sender: nil)
                return
            }
        }
    }
    
    // 当前商品列表数据
    func initProductData() {
        var allProducets: [ProductModel] = []
        AppAPIHelper.deal().products(pid: 0, complete: { [weak self](result) -> ()? in
            
            if let products: [ProductModel] = result as! [ProductModel]?{
                allProducets += products
                self?.titleView.objects = allProducets
                let product = allProducets[0]
                DealModel.share().selectProduct = product
                self?.didSelectedObject(object: product)
                //请求实时报价
                
                
                
            }
            return nil
            }, error: errorBlockFunc())
    }
    // 持仓列表数据
    func initDealTableData() {
        AppAPIHelper.deal().currentDeals(complete: { [weak self](result) -> ()? in
            if result == nil{
                return nil
            }
            if let resultModel: [PositionModel] = result as! [PositionModel]?{
                self?.dealTable.dealTableData = resultModel
            }
            return nil
            }, error: errorBlockFunc())
    }
    // 当前报价
    internal func didSelectedObject(object: AnyObject?) {
        if let model: ProductModel = object as! ProductModel? {
            DealModel.share().selectProduct = model
            initRealTimeData()
            kLineView.refreshKLine()
        }
    }
    func initRealTimeData() {
        if let product = DealModel.share().selectProduct {
            let good = [SocketConst.Key.goodType: product.typeCode,
                        SocketConst.Key.exchangeName: product.exchangeName,
                        SocketConst.Key.platformName: product.platformName]
            let param: [String: Any] = [SocketConst.Key.id: UserModel.currentUserId,
                                        SocketConst.Key.token: UserModel.token ?? "",
                                        SocketConst.Key.goodsinfos: [good]]
            AppAPIHelper.deal().realtime(param: param, complete: { [weak self](result) -> ()? in
                if let models: [KChartModel] = result as! [KChartModel]?{
                    for model in models{
                        if model.goodType == DealModel.share().selectProduct?.typeCode{
                            self?.priceLabel.text = String.init(format: "%.2f", model.currentPrice)
                            self?.highLabel.text = String.init(format: "%.2f", model.highPrice)
                            self?.lowLabel.text = String.init(format: "%.2f", model.lowPrice)
                            self?.openLabel.text = String.init(format: "%.2f", model.openingTodayPrice)
                            self?.closeLabel.text = String.init(format: "%.2f", model.closedYesterdayPrice)
                            self?.nameLabel.text = "\(product.name)(元/千克)"
                        }
                    }
                }
                return nil
                }, error: errorBlockFunc())
        }
    }
    
    //MARK: --UI
    func initUI() {
        timeBtnTapped(minBtn)
        titleView.itemDelegate = self
        titleView.reuseIdentifier = ProductTitleItem.className()
    }
    
    //MARK: --商品选择
    func didSelectedObjects(object: AnyObject?) {
        if let product = object as? ProductModel {
            DealModel.share().selectProduct = product
        }
    }
    
    //MARK: --KlineView and Btns
    @IBAction func timeBtnTapped(_ sender: UIButton) {
        if let btn = klineBtn {
            btn.isSelected = false
            btn.backgroundColor = UIColor.init(rgbHex: 0xe6e9ed)
        }
        
        kLineView.selectIndex = sender.tag
        sender.isSelected = true
        sender.backgroundColor = AppConst.Color.CMain
        klineBtn = sender
    }
    
    //MARK: --买涨/买跌
    @IBAction func dealBtnTapped(_ sender: UIButton) {
        DealModel.share().dealUp = sender.tag == 1
        DealModel.share().isDealDetail = false
        performSegue(withIdentifier: BuyVC.className(), sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == BuyVC.className() {
            return checkLogin()
        }
        return true
    }
}
