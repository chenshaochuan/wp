//
//  KLineModel.swift
//  wp
//
//  Created by 木柳 on 2017/1/16.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import RealmSwift
class KLineModel: NSObject {
    private static var queue = DispatchQueue.init(label: "timeline")
    
    enum KLineType: Int {
        case miu = 1   //1分钟
        case miu5 = 5  //5分钟
        case miu15 = 15 //15分钟
        case miu30 = 30 //30分钟
        case miu60 = 60 //60分钟
        case day = 6   //日K线
    }
    
    //缓存分时数据
    class func cacheTimelineModels(models: [KChartModel], goodType: String) {
        let _ = autoreleasepool(invoking: {
            queue.async(execute: {
                let realm = try! Realm()
                let queryStr = NSPredicate.init(format: "goodType = %@",goodType)
                var goodMaxTime: Int = 0
                if let maxTimeGood = realm.objects(KChartModel.self).sorted(byProperty: "priceTime").filter(queryStr).last{
                    goodMaxTime = maxTimeGood.priceTime
                }
                var goodMinTime: Int = 0
                if let minTimeGood = realm.objects(KChartModel.self).sorted(byProperty: "priceTime").filter(queryStr).first{
                    goodMinTime = minTimeGood.priceTime
                }
        
                for (_, model) in models.enumerated() {
                    if model.priceTime > goodMaxTime || model.priceTime < goodMinTime{
                        model.goodType = goodType
                        model.onlyKey = "\(goodType)\(model.priceTime)"
                        //缓存分时线
                        try! realm.write {
                            realm.add(model, update: true)
                        }
                    }
                }
            })
        })
    }
    
    //缓存K线模型
    class func cacheKLineModels(klineType: KLineType, goodType: String) {
        let _ = autoreleasepool(invoking: {
            queue.async(execute: {
                let realm = try! Realm()
//                var goodMinTime: Int = 0
//                if let minTimeGood = realm.objects(classType).sorted(byProperty: "priceTime").filter(queryStr).first{
//                    goodMinTime = minTimeGood.priceTime
//                }
                
                let queryStr = NSPredicate.init(format: "goodType = %@",goodType)
                let queryTypeStr = NSPredicate.init(format: "klineType = %d",klineType.rawValue)
                var goodMaxTime: Int = 0
                if let maxTimeGood = realm.objects(KLineChartModel.self).sorted(byProperty: "priceTime").filter(queryStr).filter(queryTypeStr).last{
                    goodMaxTime = maxTimeGood.priceTime
                }
                queryModels(type: klineType, goodType: goodType, minTime: goodMaxTime)
            })
        })
    }
    
    //查询更多数据
    class func queryModels(type: KLineType, goodType: String, minTime: Int){
        let margin = type.rawValue * 60
        var min = minTime > Int(Date.startTimestemp()) ? minTime : Int(Date.startTimestemp())
        var max = min + margin
        let current = Int(Date.nowTimestemp())
        while max < current {
            queryModel(type: type, goodType: goodType, fromTime: min, toTime: max)
            min = max
            max = min + margin
        }
    }
    
    //查询某个时间段的K线数据并计算出该时间段的K线模型
    class func queryModel(type: KLineType,goodType: String, fromTime: Int, toTime: Int) {
        let realm = try! Realm()
        let queryStr = NSPredicate.init(format: "goodType = %@",goodType)
        let result = realm.objects(KChartModel.self).sorted(byProperty: "priceTime").filter(queryStr).filter("priceTime > \(fromTime)").filter("priceTime < \(toTime)")
        
        var resultModel: KLineChartModel?
        for (index, model) in result.enumerated() {
            if index == 0 {
                resultModel = KLineChartModel()
                resultModel!.priceTime = model.priceTime
                resultModel!.goodType = model.goodType
                resultModel!.exchangeName = model.exchangeName
                resultModel!.platformName = model.platformName
                resultModel!.currentPrice = model.currentPrice
                resultModel!.change = model.change
                resultModel!.openingTodayPrice = model.openingTodayPrice
                resultModel!.closedYesterdayPrice = model.closedYesterdayPrice
                resultModel!.highPrice = resultModel!.currentPrice
                resultModel!.lowPrice = resultModel!.currentPrice
                resultModel!.openPrice = resultModel!.currentPrice
                resultModel!.klineType = type.rawValue
            }else{
                //收盘价
                if index == result.count - 1 {
                    resultModel?.closePrice = model.currentPrice
                    resultModel?.onlyKey = "\(goodType)\(model.priceTime)"
                }
                //最高价
                if resultModel!.highPrice < model.currentPrice {
                    resultModel!.highPrice = model.currentPrice
                }
                //最低价
                if resultModel!.lowPrice > model.currentPrice {
                    resultModel!.lowPrice = model.currentPrice
                }
            }
        }
        if resultModel != nil {
            try! realm.write {
                realm.add(resultModel!, update: true)
            }
        }
    }
    
    //读取分时数据
    class func queryTimelineModels(fromTime: Int, toTime: Int, goodType: String, complete: @escaping CompleteBlock){
        let _ = autoreleasepool(invoking: {
            queue.async(execute: {
                var models: [KChartModel] = []
                let realm = try! Realm()
                let queryStr = NSPredicate.init(format: "goodType = %@",goodType)
                let result = realm.objects(KChartModel.self).sorted(byProperty: "priceTime").filter(queryStr).filter("priceTime > \(fromTime)")
                for model in result {
                    models.append(model)
                }
                complete(models as AnyObject?)
                print("读取分时数据===========================\(Thread.current)")
            })
        })
    }
    
    //读取k线数据
    class func queryKLineModels(type: KLineType, fromTime: Int, toTime: Int, goodType: String, complete: @escaping CompleteBlock){
        let _ = autoreleasepool(invoking: {
            queue.async(execute: {
                var models: [KChartModel] = []
                let realm = try! Realm()
                let queryStr = NSPredicate.init(format: "goodType = %@",goodType)
                let queryTypeStr = String.init(format: "klineType = %d", type.rawValue)
                let result = realm.objects(KLineChartModel.self).sorted(byProperty: "priceTime").filter("priceTime > \(fromTime)").filter(queryStr).filter(queryTypeStr)
                for model in result {
                    models.append(model)
                }
                complete(models as AnyObject?)
                print("读取\(type)K分时数据===========================\(Thread.current)")
            })
        })
    }
   
}
