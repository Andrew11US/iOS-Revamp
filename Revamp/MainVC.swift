//
//  ViewController.swift
//  Revamp
//
//  Created by Andrew on 3/26/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Charts

class MainVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var histogramView: LineChartView!
    @IBOutlet weak var adjustmentsTableView: UITableView!
    @IBOutlet weak var adjustmentView: UIView!
    @IBOutlet weak var adjustmentViewHeightConstraint: NSLayoutConstraint!
    
    private var adjustments = ["1", "2", "3", "4", "5","11", "2", "3", "4", "5","111", "2", "3", "4", "5"]
    
    //MARK: - Variables
    var imageScrollView: ImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(OpenCVWrapper.openCVVersion())
    }
    
    @IBAction func openBtnTapped(_ sender: UIButton) {
        if imageScrollView != nil {
            imageScrollView.removeFromSuperview()
        }
        setupImageScrollView()
        let image = UIImage(named: "t2")
        self.imageScrollView.set(image: image!)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
//        self.imageScrollView.set(image: OpenCVWrapper.makeGray(imageScrollView.baseImage.image!))
        
//        drawHistogram(image: imageScrollView.baseImage.image)
        self.imageScrollView.set(image: (imageScrollView.baseImage.image?.MaxFilter(width: 3, height: 3))!)
//        self.imageScrollView.set(image: OpenCVWrapper.makeGray(imageScrollView.baseImage.image!))
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        self.animate(view: adjustmentView, constraint: adjustmentViewHeightConstraint, to: 0)
    }
    
    @IBAction func adjustmentsBtnTapped(_ sender: UIButton) {
        if adjustmentViewHeightConstraint.constant > 0 {
            self.animate(view: adjustmentView, constraint: adjustmentViewHeightConstraint, to: 0)
        } else {
            self.animate(view: adjustmentView, constraint: adjustmentViewHeightConstraint, to: 500)
        }
    }
    
    func setupImageScrollView() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        view.sendSubviewToBack(imageScrollView)
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    private func drawHistogram(image: UIImage?) {
        guard let histogram = image?.histogram() else { return }
        
        var redEntry  = [ChartDataEntry]()
        var greenEntry  = [ChartDataEntry]()
        var blueEntry  = [ChartDataEntry]()
        
        for (key, value) in histogram.red.enumerated() {
            let item = ChartDataEntry(x: Double(key), y: Double(value))
            redEntry.append(item)
        }
        
        for (key, value) in histogram.green.enumerated() {
            let item = ChartDataEntry(x: Double(key), y: Double(value))
            greenEntry.append(item)
        }
        
        for (key, value) in histogram.blue.enumerated() {
            let item = ChartDataEntry(x: Double(key), y: Double(value))
            blueEntry.append(item)
        }
        
        let redLine = LineChartDataSet(entries: redEntry, label: "Red")
        redLine.colors = [UIColor.appRed]
        redLine.circleRadius = 0.0
        redLine.circleHoleRadius = 0
        redLine.mode = .cubicBezier
        
        let greenLine = LineChartDataSet(entries: greenEntry, label: "Green")
        greenLine.colors = [UIColor.appGreen]
        greenLine.circleRadius = 0.0
        greenLine.circleHoleRadius = 0
        greenLine.mode = .cubicBezier
        
        let blueLine = LineChartDataSet(entries: blueEntry, label: "Blue")
        blueLine.colors = [UIColor.systemBlue] // << TODO: - change !!!
        blueLine.circleRadius = 0.0
        blueLine.circleHoleRadius = 0
        blueLine.mode = .cubicBezier

        let data = LineChartData()
        data.addDataSet(redLine)
        data.addDataSet(greenLine)
        data.addDataSet(blueLine)
        
        histogramView.data = data
        histogramView.animate(yAxisDuration: 2)
        histogramView.leftAxis.enabled = false
        histogramView.rightAxis.enabled = false
        histogramView.xAxis.enabled = false
        histogramView.legend.enabled = false
    }

}

// MARK: - UITableView deledate and dataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adjustments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: ", adjustments[indexPath.row])
        self.animate(view: adjustmentView, constraint: adjustmentViewHeightConstraint, to: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdjustmentCell", for: indexPath) as? AdjustmentCell {
            
            cell.configureCell(adjustment: adjustments[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

