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
    
    // MARK: - Adjustment Views
    private var thresholdView: ThresholdView!
    private var contrastView: ContrastView!
    private var blurView: BlurView!
    private var sobelView: SobelView!
    private var cannyView: CannyView!
    private var maskView: MaskView!
    private var sharpenView: SharpenView!
    private var prewittView: PrewittView!
    private var edgeDetectionView: EdgeDetectionView!
    private var morphologyView: MorphologyView!
    
    //MARK: - Variables
    private var imagePicker: ImagePicker!
    private var imageScrollView: ImageScrollView!
    private var historyCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    private var permissions: [SPPermission] = [.camera, .photoLibrary]
    private var historyImages: [HistoryImage] = []
    private var selectedAdjustment: String!
    private var adjustments: [String] = ["Grayscale", "Equalize Histogram", "Threshold Binarized", "Threshold Grayscale", "Enhance Contrast", "Invert", "Adaptive Threshold", "Blur", "Gaussian blur", "Median filter", "Otsu Threshold", "Posterize", "Watershed", "Sobel", "Laplacian", "Canny", "Mask 3x3", "Sharpen", "Prewitt", "Edge Detection", "Morphology", "Thinning"]
    
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
        case adjustments[0]:
            imageScrollView.set(image: OpenCVWrapper.toGrayscale(imageScrollView.baseImage.image!))
        case adjustments[1]:
            imageScrollView.set(image: OpenCVWrapper.histogramEqualization(imageScrollView.baseImage.image!))
        case adjustments[2]:
            imageScrollView.set(image: OpenCVWrapper.threshold(imageScrollView.baseImage.image!, level: thresholdView.threshold))
            thresholdView.removeFromSuperview()
            thresholdView = nil
        case adjustments[3]:
            imageScrollView.set(image: OpenCVWrapper.grayscaleThreshold(imageScrollView.baseImage.image!, level: thresholdView.threshold))
            thresholdView.removeFromSuperview()
            thresholdView = nil
        case adjustments[4]:
            imageScrollView.set(image: OpenCVWrapper.contrastEnhancement(imageScrollView.baseImage.image!, r1: Int32(contrastView.fromMin), r2: Int32(contrastView.fromMax), s1: Int32(contrastView.toMin), s2: Int32(contrastView.toMax)))
            contrastView.removeFromSuperview()
            contrastView = nil
        case adjustments[5]:
            imageScrollView.set(image: OpenCVWrapper.invert(imageScrollView.baseImage.image!))
        case adjustments[6]:
            imageScrollView.set(image: OpenCVWrapper.adaptiveThreshold(imageScrollView.baseImage.image!, level: thresholdView.threshold))
            thresholdView.removeFromSuperview()
            thresholdView = nil
        case adjustments[7]:
            imageScrollView.set(image: OpenCVWrapper.blur(imageScrollView.baseImage.image!, level: Int32(blurView.blurLevel)))
            blurView.removeFromSuperview()
            blurView = nil
        case adjustments[8]:
            imageScrollView.set(image: OpenCVWrapper.gaussianBlur(imageScrollView.baseImage.image!, level: Int32(blurView.blurLevel)))
            blurView.removeFromSuperview()
            blurView = nil
        case adjustments[9]:
            imageScrollView.set(image: OpenCVWrapper.medianFilter(imageScrollView.baseImage.image!, level: Int32(blurView.blurLevel)))
            blurView.removeFromSuperview()
            blurView = nil
        case adjustments[10]:
            imageScrollView.set(image: OpenCVWrapper.otsuThreshold(imageScrollView.baseImage.image!, level: thresholdView.threshold))
            thresholdView.removeFromSuperview()
            thresholdView = nil
        case adjustments[11]:
            imageScrollView.set(image: OpenCVWrapper.posterize(imageScrollView.baseImage.image!, level: 3))
        case adjustments[12]:
            imageScrollView.set(image: OpenCVWrapper.watershed(imageScrollView.baseImage.image!))
        case adjustments[13]:
            imageScrollView.set(image: OpenCVWrapper.sobel(imageScrollView.baseImage.image!, type: Int32(sobelView.type), border: Int32(sobelView.border)))
            sobelView.removeFromSuperview()
            sobelView = nil
        case adjustments[14]:
            imageScrollView.set(image: OpenCVWrapper.laplacian(imageScrollView.baseImage.image!))
        case adjustments[15]:
            imageScrollView.set(image: OpenCVWrapper.canny(imageScrollView.baseImage.image!, lower: Int32(cannyView.lowerBound), upper: Int32(cannyView.upperBound)))
            cannyView.removeFromSuperview()
            cannyView = nil
        case adjustments[16]:
            imageScrollView.set(image: OpenCVWrapper.mask3x3(imageScrollView.baseImage.image!, mask: maskView.kernel, divisor: Int32(maskView.divisor)))
            maskView.removeFromSuperview()
            maskView = nil
        case adjustments[17]:
            imageScrollView.set(image: OpenCVWrapper.sharpen(imageScrollView.baseImage.image!, type: Int32(sharpenView.type), border: Int32(sharpenView.border)))
            sharpenView.removeFromSuperview()
            sharpenView = nil
        case adjustments[18]:
            imageScrollView.set(image: OpenCVWrapper.prewitt(imageScrollView.baseImage.image!, type: Int32(prewittView.type), border: Int32(prewittView.border)))
            prewittView.removeFromSuperview()
            prewittView = nil
        case adjustments[19]:
            imageScrollView.set(image: OpenCVWrapper.edgeDetection(imageScrollView.baseImage.image!, type: Int32(edgeDetectionView.type), border: Int32(edgeDetectionView.border)))
            edgeDetectionView.removeFromSuperview()
            edgeDetectionView = nil
        case adjustments[20]:
            imageScrollView.set(image: OpenCVWrapper.morphology(imageScrollView.baseImage.image!, operation: Int32(morphologyView.operation), element: Int32(morphologyView.element), n: Int32(morphologyView.iterations), border: Int32(morphologyView.border)))
            morphologyView.removeFromSuperview()
            morphologyView = nil
        case adjustments[21]:
            imageScrollView.set(image: OpenCVWrapper.thinning(imageScrollView.baseImage.image!))
        default:
            self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
            return
        }
        
        historyImages.append(HistoryImage(name: selectedAdjustment, image: imageScrollView.baseImage.image!))
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
        print(historyImages.count)
    }
    
    @IBAction func cancelAdjustmentBtnTapped(_ sender: UIButton) {
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: 0)
    }
    
    // MARK: - Custom Views setup
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
    
    func setupThresholdView() {
        thresholdView = ThresholdView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(thresholdView)
        thresholdView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thresholdView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            thresholdView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            thresholdView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            thresholdView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupContrastView() {
        contrastView = ContrastView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(contrastView)
        contrastView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contrastView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            contrastView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            contrastView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            contrastView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupBlurView() {
        blurView = BlurView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            blurView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            blurView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            blurView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupSobelView() {
        sobelView = SobelView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(sobelView)
        sobelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sobelView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            sobelView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            sobelView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            sobelView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupCannyView() {
        cannyView = CannyView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(cannyView)
        cannyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cannyView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            cannyView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            cannyView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            cannyView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupMaskView() {
        maskView = MaskView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(maskView)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            maskView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            maskView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            maskView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupSharpenView() {
        sharpenView = SharpenView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(sharpenView)
        sharpenView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sharpenView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            sharpenView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            sharpenView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            sharpenView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupPrewittView() {
        prewittView = PrewittView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(prewittView)
        prewittView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            prewittView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            prewittView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            prewittView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            prewittView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupEdgeView() {
        edgeDetectionView = EdgeDetectionView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(edgeDetectionView)
        edgeDetectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            edgeDetectionView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            edgeDetectionView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            edgeDetectionView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            edgeDetectionView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
        ])
    }
    
    func setupMorphView() {
        morphologyView = MorphologyView(frame: setAdjustmentView.bounds)
        setAdjustmentView.addSubview(morphologyView)
        morphologyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            morphologyView.topAnchor.constraint(equalTo: setAdjustmentView.topAnchor, constant: 5),
            morphologyView.bottomAnchor.constraint(equalTo: applyAdjustmentBtn.topAnchor, constant: -10),
            morphologyView.trailingAnchor.constraint(equalTo: setAdjustmentView.trailingAnchor, constant: 0),
            morphologyView.leadingAnchor.constraint(equalTo: setAdjustmentView.leadingAnchor, constant: 0)
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
    
    func adaptSetAdjustmentView(adjustment: String) -> Int {
        let size = 61
        switch adjustment {
        case adjustments[0]:
            return size
        case adjustments[1]:
            return size
        case adjustments[2]:
            setupThresholdView()
            return 300
        case adjustments[3]:
            setupThresholdView()
            return 300
        case adjustments[4]:
            setupContrastView()
            return 300
        case adjustments[6]:
            setupThresholdView()
            return 300
        case adjustments[7]:
            setupBlurView()
            return 300
        case adjustments[8]:
            setupBlurView()
            return 300
        case adjustments[9]:
            setupBlurView()
            return 300
        case adjustments[10]:
            setupThresholdView()
            return 300
        case adjustments[13]:
            setupSobelView()
            return 300
        case adjustments[15]:
            setupCannyView()
            return 300
        case adjustments[16]:
            setupMaskView()
            return 300
        case adjustments[17]:
            setupSharpenView()
            return 300
        case adjustments[18]:
            setupPrewittView()
            return 300
        case adjustments[19]:
            setupEdgeView()
            return 300
        case adjustments[20]:
            setupMorphView()
            return 300
        default:
            return size
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
        return OpenCVWrapper.toGrayscale(image)
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
        selectedAdjustment = adjustments[indexPath.row]
        let size = adaptSetAdjustmentView(adjustment: selectedAdjustment)
        self.animate(view: adjustmentsView, constraint: adjustmentsViewHeight, to: 0)
        self.animate(view: setAdjustmentView, constraint: setAdjustmentViewHeight, to: size)
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

