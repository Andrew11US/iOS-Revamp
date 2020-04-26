//
//  ViewController.swift
//  Revamp
//
//  Created by Andrew on 3/26/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Charts
import CenteredCollectionView
import SPPermissions

class MainVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var histogramBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var adjustmentsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var openLibraryLbl: UILabel!
    @IBOutlet weak var histogramView: LineChartView!
    @IBOutlet weak var adjustmentsTableView: UITableView!
    @IBOutlet weak var adjustmentsView: UIView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var setAdjustmentView: UIView!
    @IBOutlet weak var adjustmentsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var historyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var setAdjustmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var applyAdjustmentBtn: UIButton!
    
    //MARK: - Variables
    private var imagePicker: ImagePicker!
    private var imageScrollView: ImageScrollView!
    private var historyCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    private var permissions: [SPPermission] = [.camera, .photoLibrary]
    private var adjustments: [Adjustment] = [Adjustment(name: "gray", action: ProcessingManager.makeGrayscale(image:))]
    private var historyImages: [HistoryImage] = []
    
    // MARK: - ViewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(OpenCVWrapper.openCVVersion())
        setHistoryCollectionView()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        setButtons()
    }
    
    // MARK: - ViewDidAppear method
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
            self.requestPermissions()
        }
    }
    
    //MARK: - IBActions
    @IBAction func openBtnTapped(_ sender: UIButton) {
        if imageScrollView == nil {
            imagePicker.present(from: sender)
        } else {
            presentCloseAlert()
        }
        self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
        self.animate(view: historyView, constraint: historyViewHeight, to: 0)
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        self.histogramView.isHidden = true
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        let items = [imageScrollView.baseImage.image!]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true)
        self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
        self.animate(view: historyView, constraint: historyViewHeight, to: 0)
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
    }
    
    @IBAction func openLibraryTapped(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func historyBtnTapped(_ sender: UIButton) {
        if historyViewHeight.constant > 0 {
            self.animate(view: historyView, constraint: historyViewHeight, to: 0)
        } else {
            self.animate(view: historyView, constraint: historyViewHeight, to: 250)
            self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
            self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        }
    }
    
    @IBAction func adjustmentsBtnTapped(_ sender: UIButton) {
        if adjustmentsViewHeight.constant > 0 {
            self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
        } else {
            self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 500)
            self.animate(view: historyView, constraint: historyViewHeight, to: 0)
            self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        }
    }
    
    @IBAction func histogramBtnTapped(_ sender: UIButton) {
        if histogramView.isHidden {
            histogramView.isHidden = false
            drawHistogram(image: imageScrollView.baseImage.image!)
        } else {
            histogramView.isHidden = true
        }
    }
    
    @IBAction func applyAdjustmentBtnTapped(_ sender: UIButton) {
        imageScrollView.set(image: makeGrayscale(image: imageScrollView.baseImage.image!))
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
    }
    
    // MARK: - ImageScrollView setup
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
    
    // MARK: - Draw Histogram
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
    
    // MARK: - Monitors buttons
    func setButtons() {
        if imageScrollView == nil {
            historyBtn.isEnabled = false
            histogramBtn.isEnabled = false
            adjustmentsBtn.isEnabled = false
            shareBtn.isEnabled = false
            openLibraryLbl.isHidden = false
            openBtn.setTitle("Open", for: .normal)
        } else {
            historyBtn.isEnabled = true
            histogramBtn.isEnabled = true
            adjustmentsBtn.isEnabled = true
            shareBtn.isEnabled = true
            openLibraryLbl.isHidden = true
            openBtn.setTitle("Close", for: .normal)
        }
    }
    
    // MARK: - historyCollectionView setup
    func setHistoryCollectionView() {
        historyCollectionViewFlowLayout = (historyCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        historyCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        historyCollectionViewFlowLayout.itemSize = CGSize(width: 250, height: 200)
        historyCollectionViewFlowLayout.minimumLineSpacing = 30
    }
    
    // MARK: - Close action AlertController
    func presentCloseAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { alert in
            self.imageScrollView.removeFromSuperview()
            self.imageScrollView = nil
            self.setButtons()
            self.historyImages.removeAll()
            self.historyCollectionView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = openBtn
            alertController.popoverPresentationController?.sourceRect = openBtn.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.present(alertController, animated: true)
    }
    
    // MARK: - Request mandatory authrizations
    func requestPermissions() {
        var notAuthorized = false
        for permission in permissions {
            if !permission.isAuthorized {
                notAuthorized = true
            }
        }
        
        if notAuthorized {
            let controller = SPPermissions.dialog(permissions)
            controller.present(on: self)
        }
    }
    
    @objc func makeGrayscale(image: UIImage) -> UIImage {
        print("Performed")
        return OpenCVWrapper.makeGray(image)
    }
}

// MARK: - UITableView delegate and dataSource
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
        self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 500)
//        let img: UIImage = adjustments[indexPath.row].action(imageScrollView.baseImage.image!)
//        imageScrollView.set(image: img)
//        historyImages.append(HistoryImage(name: adjustments[indexPath.row].name, image: img))
//        historyCollectionView.reloadData()
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

// MARK: - historyCollectionView delegate and dataSource
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageScrollView.set(image: historyImages[indexPath.row].image)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as? HistoryCell {
            
            let image = historyImages[indexPath.row]
            cell.configureCell(historyImage: image)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UIImagePickerController deledate
extension MainVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let img = image {
            setupImageScrollView()
            imageScrollView.set(image: img)
            setButtons()
            historyImages.append(HistoryImage(name: "Original Image", image: img))
            historyCollectionView.reloadData()
        } else {
            print("User did cancel")
        }
    }
}

