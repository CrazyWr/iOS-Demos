//
//  QRCodeScanManager.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/10.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanManager: NSObject {

    weak var previewVC: UIViewController?
    
    public func starScan() {
        //1. 判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput) {
            print("添加输入设备出错")
            return
        }
        //2. 判断输出
        if !session.canAddOutput(deviceOutput) {
            print("添加输出设备出错")
            return
        }
        //3. 添加输入输出
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        //4. 设置输出的解析类型
        //AVMetadataObject.h
        //支持所有能解析的类型
        //设置输出类型必须在添加完输入输出设备之后
        deviceOutput.metadataObjectTypes = deviceOutput.availableMetadataObjectTypes
        //5. 设置输出对象的代理, 解析成功通知代理
        deviceOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        //添加预览图层到最底层
        if previewVC == nil{
            assert(false, "请设置previewVC, 显示预览图层")
        }
        previewVC?.view.layer.insertSublayer(previewLayer, at:0)
        //6. 开始扫描
        session.startRunning()
    }
    
    func drawBorder(rect: CGRect?) {
        if rect == nil{
            return
        }
        //1. 创建图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        //2. 创建路径
        layer.path = UIBezierPath(roundedRect: rect!, cornerRadius: 0.0).cgPath
        borderLayer.addSublayer(layer)
        previewLayer.addSublayer(borderLayer)
    }
    
    // 清空原图层
    func clearBorder() {
        if borderLayer.sublayers != nil{
            for sublayer in borderLayer.sublayers! {
                sublayer.removeFromSuperlayer()
            }
        }

    }
    
    // MARK: 懒加载
    /// 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    /// 输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        //获取摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //创建输入对象
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    /// 输出设备
    private lazy var deviceOutput:AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        return output
    }()
    
    /// 预览图层
    fileprivate lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer?.frame = UIScreen.main.bounds
        return layer!
    }()
    
    /// 边框图层
    private lazy var borderLayer: CALayer = CALayer()
    
}

extension QRCodeScanManager: AVCaptureMetadataOutputObjectsDelegate{
    //只要解析到数据就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // 清空边框
        clearBorder()
        
        for item in metadataObjects {
            //坐标转换为界面可识别坐标
            let obj = previewLayer.transformedMetadataObject(for: item as? AVMetadataObject) as? AVMetadataMachineReadableCodeObject
            //扫描结果
            let stringValue = obj?.stringValue
            //二维码坐标
            let rect = obj?.bounds
            drawBorder(rect: rect)
            
            print(stringValue ?? "空")
            print(obj?.bounds ?? "空")
        }
    }
}
