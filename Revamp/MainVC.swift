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
    private var sView: UIView!
    private var imagePicker: ImagePicker!
    private var imageScrollView: ImageScrollView!
    private var historyCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    private var permissions: [SPPermission] = [.camera, .photoLibrary]
    private var historyImages: [HistoryImage] = []
    private var selectedAdjustment: Adjustment!
    private var adjustments: [Adjustment] = Adjustment.allCases
    
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
    
    @IBAction func aboutActionTriggered(_ sender: UIButton) {
        print("About app")
    }
    
    @IBAction func historyBtnTapped(_ sender: UIButton) {
        if historyViewHeight.constant > 0 {
            self.animate(view: historyView, constraint: historyViewHeight, to: 0)
        } else {
            self.animate(view: historyView, constraint: historyViewHeight, to: 250)
            self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
            self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        }
        historyCollectionView.reloadData()
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
    
    // MARK: - Apply adjustment
    @IBAction func applyAdjustmentBtnTapped(_ sender: UIButton) {
        switch selectedAdjustment {
        case .grayscale:
            imageScrollView.set(image: OpenCVWrapper.toGrayscale(imageScrollView.baseImage.image!))
        case .equalize:
            imageScrollView.set(image: OpenCVWrapper.histogramEqualization(imageScrollView.baseImage.image!))
        case .thresholdBinarized:
            imageScrollView.set(image: OpenCVWrapper.threshold(imageScrollView.baseImage.image!, level: (sView as! ThresholdView).threshold))
        case .thresholGray:
            imageScrollView.set(image: OpenCVWrapper.grayscaleThreshold(imageScrollView.baseImage.image!, level: (sView as! ThresholdView).threshold))
        case .contrast:
            imageScrollView.set(image: OpenCVWrapper.contrastEnhancement(imageScrollView.baseImage.image!, r1: Int32((sView as! ContrastView).fromMin), r2: Int32((sView as! ContrastView).fromMax), s1: Int32((sView as! ContrastView).toMin), s2: Int32((sView as! ContrastView).toMax)))
        case .invert:
            imageScrollView.set(image: OpenCVWrapper.invert(imageScrollView.baseImage.image!))
        case .thresholAdaptive:
            imageScrollView.set(image: OpenCVWrapper.adaptiveThreshold(imageScrollView.baseImage.image!, level: (sView as! ThresholdView).threshold))
        case .blur:
            imageScrollView.set(image: OpenCVWrapper.blur(imageScrollView.baseImage.image!, level: Int32((sView as! BlurView).blurLevel)))
        case .gaussian:
            imageScrollView.set(image: OpenCVWrapper.gaussianBlur(imageScrollView.baseImage.image!, level: Int32((sView as! BlurView).blurLevel)))
        case .median:
            imageScrollView.set(image: OpenCVWrapper.medianFilter(imageScrollView.baseImage.image!, level: Int32((sView as! BlurView).blurLevel)))
        case .thresholdOtsu:
            imageScrollView.set(image: OpenCVWrapper.otsuThreshold(imageScrollView.baseImage.image!, level: (sView as! ThresholdView).threshold))
        case .posterize:
            imageScrollView.set(image: OpenCVWrapper.posterize(imageScrollView.baseImage.image!, level: Int32((sView as! PosterizeView).grayLevels)))
        case .watershed:
            imageScrollView.set(image: OpenCVWrapper.watershed(imageScrollView.baseImage.image!))
        case .sobel:
            imageScrollView.set(image: OpenCVWrapper.sobel(imageScrollView.baseImage.image!, type: Int32((sView as! SobelView).type), border: Int32((sView as! SobelView).border)))
        case .laplacian:
            imageScrollView.set(image: OpenCVWrapper.laplacian(imageScrollView.baseImage.image!))
        case .canny:
            imageScrollView.set(image: OpenCVWrapper.canny(imageScrollView.baseImage.image!, lower: Int32((sView as! CannyView).lowerBound), upper: Int32((sView as! CannyView).upperBound)))
        case .mask:
            imageScrollView.set(image: OpenCVWrapper.mask3x3(imageScrollView.baseImage.image!, mask: (sView as! MaskView).kernel, divisor: Int32((sView as! MaskView).divisor)))
        case .sharpen:
            imageScrollView.set(image: OpenCVWrapper.sharpen(imageScrollView.baseImage.image!, type: Int32((sView as! SharpenView).type), border: Int32((sView as! SharpenView).border)))
        case .prewitt:
            imageScrollView.set(image: OpenCVWrapper.prewitt(imageScrollView.baseImage.image!, type: Int32((sView as! PrewittView).type), border: Int32((sView as! PrewittView).border)))
        case .edge:
            imageScrollView.set(image: OpenCVWrapper.edgeDetection(imageScrollView.baseImage.image!, type: Int32((sView as! EdgeDetectionView).type), border: Int32((sView as! EdgeDetectionView).border)))
        case .morphology:
            imageScrollView.set(image: OpenCVWrapper.morphology(imageScrollView.baseImage.image!, operation: Int32((sView as! MorphologyView).operation), element: Int32((sView as! MorphologyView).element), n: Int32((sView as! MorphologyView).iterations), border: Int32((sView as! MorphologyView).border)))
        case .thinning:
            imageScrollView.set(image: OpenCVWrapper.thinning(imageScrollView.baseImage.image!))
        case .moments:
            FunctionsLib.showMoments(img: imageScrollView.baseImage.image!)
        default: break
        }
        
        historyImages.append(HistoryImage(name: selectedAdjustment.rawValue, image: imageScrollView.baseImage.image!))
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        removeFromView()
    }
    
    @IBAction func cancelAdjustmentBtnTapped(_ sender: UIButton) {
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        removeFromView()
    }
    
    // MARK: - Custom Views setup
    func setupImageScrollView() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        view.sendSubviewToBack(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
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
    
    func restyleSettingsView(adjustment: Adjustment) -> Int {
        let size = 61
        switch adjustment {
        case .thresholdBinarized, .thresholGray, .thresholAdaptive, .thresholdOtsu:
            setupAdjustmentSettingsView(viewType: .thresholdView)
            return 300
        case .contrast:
            setupAdjustmentSettingsView(viewType: .contrastView)
            return 300
        case .blur, .gaussian, .median:
            setupAdjustmentSettingsView(viewType: .blurView)
            return 300
        case .sobel:
            setupAdjustmentSettingsView(viewType: .sobelView)
            return 300
        case .canny:
            setupAdjustmentSettingsView(viewType: .cannyView)
            return 300
        case .mask:
            setupAdjustmentSettingsView(viewType: .maskView)
            return 300
        case .sharpen:
            setupAdjustmentSettingsView(viewType: .sharpenView)
            return 300
        case .prewitt:
            setupAdjustmentSettingsView(viewType: .prewittView)
            return 300
        case .edge:
            setupAdjustmentSettingsView(viewType: .edgeDetectionView)
            return 300
        case .morphology:
            setupAdjustmentSettingsView(viewType: .morphologyView)
            return 300
        case .posterize:
            setupAdjustmentSettingsView(viewType: .posterizeView)
            return 300
        default:
            return size
        }
    }
    
    private func setupAdjustmentSettingsView(viewType: ViewType) {
        switch viewType {
        case .thresholdView:
            sView = ThresholdView(frame: setAdjustmentView.bounds)
        case .contrastView:
            sView = ContrastView(frame: setAdjustmentView.bounds)
        case .blurView:
            sView = BlurView(frame: setAdjustmentView.bounds)
        case .sobelView:
            sView = SobelView(frame: setAdjustmentView.bounds)
        case .cannyView:
            sView = CannyView(frame: setAdjustmentView.bounds)
        case .maskView:
            sView = MaskView(frame: setAdjustmentView.bounds)
        case .sharpenView:
            sView = SharpenView(frame: setAdjustmentView.bounds)
        case .prewittView:
            sView = PrewittView(frame: setAdjustmentView.bounds)
        case .edgeDetectionView:
            sView = EdgeDetectionView(frame: setAdjustmentView.bounds)
        case .morphologyView:
            sView = MorphologyView(frame: setAdjustmentView.bounds)
        case .posterizeView:
            sView = PosterizeView(frame: setAdjustmentView.bounds)
        }
        
        setAdjustmentView.addSubview(sView)
        sView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            sView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            sView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            sView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    // MARK: - historyCollectionView setup
    func setHistoryCollectionView() {
        historyCollectionViewFlowLayout = (historyCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        historyCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        historyCollectionViewFlowLayout.itemSize = CGSize(width: 250, height: 200)
        historyCollectionViewFlowLayout.minimumLineSpacing = 30
    }
    
    private func removeFromView() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if self.sView != nil {
                self.sView.removeFromSuperview()
                self.sView = nil
            }
        }
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
        print("Selected: ", adjustments[indexPath.row].rawValue)
        selectedAdjustment = adjustments[indexPath.row]
        let size = restyleSettingsView(adjustment: selectedAdjustment)
        self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: size)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdjustmentCell", for: indexPath) as? AdjustmentCell {
            
            cell.configureCell(adjustment: adjustments[indexPath.row].rawValue)
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
        if !histogramView.isHidden {
            drawHistogram(image: imageScrollView.baseImage.image!)
        }
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

