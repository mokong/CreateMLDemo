//
//  PipeImageDetectorVC.swift
//  PipeDetectorDemo
//
//  Created by Horizon on 30/09/2022.
//

import UIKit
import Vision
import SnapKit

class PipeImageDetectorVC: UIViewController {


    // MARK: - properties
    fileprivate var coreMLRequest: VNCoreMLRequest?
    fileprivate var drawingBoxesView: DrawingBoxesView?
    fileprivate var displayImageView: UIImageView = UIImageView()
    fileprivate var randomLoadBtn: UIButton = UIButton(type: .custom)
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDisplayImageView()
        setupCoreMLRequest()
        setupBoxesView()
        setupRandomLoadBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - init
    fileprivate func setupDisplayImageView() {
        view.addSubview(displayImageView)
        displayImageView.contentMode = .scaleAspectFit
        displayImageView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
    }
    
    fileprivate func setupCoreMLRequest() {
        guard let model = try? pipe_output(configuration: MLModelConfiguration()).model,
              let visionModel = try? VNCoreMLModel(for: model) else {
            return
        }
        
        coreMLRequest = VNCoreMLRequest(model: visionModel, completionHandler: { [weak self] (request, error) in
            self?.handleVMRequestDidComplete(request, error: error)
        })
        coreMLRequest?.imageCropAndScaleOption = .centerCrop
    }
    
    fileprivate func setupBoxesView() {
        let drawingBoxesView = DrawingBoxesView()
        drawingBoxesView.frame = displayImageView.frame
        displayImageView.addSubview(drawingBoxesView)
        drawingBoxesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.drawingBoxesView = drawingBoxesView
    }
    
    fileprivate func setupRandomLoadBtn() {
        drawingBoxesView?.removeBox()
        drawingBoxesView = nil
        setupBoxesView()
        
        randomLoadBtn.setTitle("????????????????????????", for: .normal)
        randomLoadBtn.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(randomLoadBtn)
        let screenW = UIScreen.main.bounds.width
        let screeH = UIScreen.main.bounds.height
        let btnH = 52.0
        let btnW = 200.0
        randomLoadBtn.frame = CGRect(x: (screenW - btnW) / 2.0, y: screeH - btnH - 10.0, width: btnW, height: btnH)
        
        randomLoadBtn.addTarget(self, action: #selector(handleRandomLoad), for: .touchUpInside)
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    fileprivate func handleVMRequestDidComplete(_ request: VNRequest, error: Error?) {
        drawingBoxesView?.removeBox()

        let results = request.results as? [VNRecognizedObjectObservation]
        DispatchQueue.main.async {
//            for prediction in results! {
//                print(prediction)
//                if prediction.confidence > 0.5 {
//                    self.drawingBoxesView?.drawBox(with: results!)
//                }
//            }
            
            self.drawingBoxesView?.drawBox(with: results!)

//            if let prediction = results?.first {
//                self.drawingBoxesView?.drawBox(with: [prediction])
//            } else {
//                self.drawingBoxesView?.removeBox()
//            }
        }
    }
    
    @objc fileprivate func handleRandomLoad() {
        let imageName = randomImageName()
        if let image = UIImage(named: imageName),
            let cgImage = image.cgImage,
            let request = coreMLRequest {
            displayImageView.image = image
            let handler = VNImageRequestHandler(cgImage: cgImage)
            try? handler.perform([request])
        }
    }
    
    // MARK: - other
    fileprivate func randomImageName() -> String {
        let maxNum: UInt32 = 18
        let minNum: UInt32 = 1
        let randomNum = arc4random_uniform(maxNum - minNum) + minNum
        let imageName = "images-\(randomNum).jpeg"
        return imageName
//        let maxNum: UInt32 = 14
//        let minNum: UInt32 = 1
//        let randomNum = arc4random_uniform(maxNum - minNum) + minNum
//        let imageName = "image\(randomNum).png"
//        return imageName
    }    
}
