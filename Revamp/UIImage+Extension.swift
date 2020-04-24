//
//  UIImage+Extension.swift
//  Revamp
//
//  Created by Andrew on 4/24/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    
    // MARK: - Histogram using vImage
    func histogram() -> (alpha: [UInt], red: [UInt], green: [UInt], blue: [UInt])? {
        guard let imageRef = self.cgImage else { return nil }
        guard let imageProvider = imageRef.dataProvider else { return nil }
        let bitmapData = imageProvider.data
        
        var imageBuffer = vImage_Buffer(data: UnsafeMutablePointer(mutating: CFDataGetBytePtr(bitmapData)), height: UInt(imageRef.height), width: UInt(imageRef.width), rowBytes: imageRef.bytesPerRow)
        
        let alpha = [UInt](repeating: 0, count: 256)
        let red = [UInt](repeating: 0, count: 256)
        let green = [UInt](repeating: 0, count: 256)
        let blue = [UInt](repeating: 0, count: 256)
        
        let alphaPtr = UnsafeMutablePointer<vImagePixelCount>(mutating: alpha)
        let redPtr = UnsafeMutablePointer<vImagePixelCount>(mutating: red)
        let greenPtr = UnsafeMutablePointer<vImagePixelCount>(mutating: green)
        let bluePtr = UnsafeMutablePointer<vImagePixelCount>(mutating: blue)
        
        let ARGB: [UnsafeMutablePointer<vImagePixelCount>?] = [alphaPtr, redPtr, greenPtr, bluePtr]
        let histogram = UnsafeMutablePointer<UnsafeMutablePointer<vImagePixelCount>?>(mutating: ARGB)
        
        vImageHistogramCalculation_ARGB8888(&imageBuffer, histogram, UInt32(kvImageNoFlags))
        
        return (alpha, red, green, blue)
    }
    
    // MARK: Morphology functions
    
    func MaxFilter(width: Int, height: Int) -> UIImage?
    {
        var outImage : UIImage?
        let oddWidth = UInt(width % 2 == 0 ? width + 1 : width)
        let oddHeight = UInt(height % 2 == 0 ? height + 1 : height)

        guard let imageRef = self.cgImage else { return nil }
        guard let imageProvider = imageRef.dataProvider else { return nil }
        let bitmapData = imageProvider.data
        
        var inBuffer = vImage_Buffer(data: UnsafeMutablePointer(mutating: CFDataGetBytePtr(bitmapData)), height: UInt(imageRef.height), width: UInt(imageRef.width), rowBytes: imageRef.bytesPerRow)

        guard let pixelBuffer = malloc(imageRef.bytesPerRow * imageRef.height) else { return nil }

        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(imageRef.height)), width: UInt(1 * Float(imageRef.width)), rowBytes: imageRef.bytesPerRow)

        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)

        var error = vImageMax_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, 0, 0, oddHeight, oddWidth, UInt32(kvImageNoFlags))

        
        
        var format = vImage_CGImageFormat(
        bitsPerComponent: 8,
        bitsPerPixel: 32,
        colorSpace: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
        renderingIntent: .defaultIntent)
        
        do {
            try outImage = UIImage(cgImage: outBuffer.createCGImage(format: format!))
        } catch {
            
        }
         
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
        
        free(imageBuffers.pixelBuffer)

        return outImage!
    }
}
//    func SIMinFilter(width width: Int, height: Int) -> UIImage
//    {
//        let oddWidth = UInt(width % 2 == 0 ? width + 1 : width)
//        let oddHeight = UInt(height % 2 == 0 ? height + 1 : height)
//
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageMin_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, 0, 0, oddHeight, oddWidth, UInt32(kvImageNoFlags))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIDilateFilter(kernel kernel: [UInt8]) -> UIImage
//    {
//        precondition(kernel.count == 9 || kernel.count == 25 || kernel.count == 49, "Kernel size must be 3x3, 5x5 or 7x7.")
//        let kernelSide = UInt32(sqrt(Float(kernel.count)))
//
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageDilate_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, 0, 0, kernel, UInt(kernelSide), UInt(kernelSide), UInt32(kvImageNoFlags))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIErodeFilter(kernel kernel: [UInt8]) -> UIImage
//    {
//        precondition(kernel.count == 9 || kernel.count == 25 || kernel.count == 49, "Kernel size must be 3x3, 5x5 or 7x7.")
//        let kernelSide = UInt32(sqrt(Float(kernel.count)))
//
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageErode_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, 0, 0, kernel, UInt(kernelSide), UInt(kernelSide), UInt32(kvImageNoFlags))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    // MARK: High Level Geometry Functions
//
//    func SIScale(scaleX scaleX: Float, scaleY: Float) -> UIImage
//    {
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(min(scaleY, 1) * Float(CGImageGetHeight(imageRef))), width: UInt(min(scaleX, 1) * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageScale_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, UInt32(kvImageBackgroundColorFill))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIRotate(angle angle: Float, backgroundColor: UIColor = UIColor.blackColor()) -> UIImage
//    {
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var backgroundColor : Array<UInt8> = backgroundColor.getRGB()
//
//        var error = vImageRotate_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, angle,  &backgroundColor, UInt32(kvImageBackgroundColorFill))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIRotateNinety(rotation: RotateNinety, backgroundColor: UIColor = UIColor.blackColor()) -> UIImage
//    {
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var backgroundColor : Array<UInt8> = backgroundColor.getRGB()
//
//        var error = vImageRotate90_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, rotation.rawValue,  &backgroundColor, UInt32(kvImageBackgroundColorFill))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIHorizontalReflect() -> UIImage
//    {
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageHorizontalReflect_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, UInt32(kvImageNoFlags))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIVerticalReflect() -> UIImage
//    {
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageVerticalReflect_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, UInt32(kvImageNoFlags))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    // MARK: Convolution
//
//    func SIBoxBlur(width width: Int, height: Int, backgroundColor: UIColor = UIColor.blackColor()) -> UIImage
//    {
//        let oddWidth = UInt32(width % 2 == 0 ? width + 1 : width)
//        let oddHeight = UInt32(height % 2 == 0 ? height + 1 : height)
//
//        var backgroundColor : Array<UInt8> = backgroundColor.getRGB()
//
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageBoxConvolve_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, 0, 0, oddHeight, oddWidth, &backgroundColor, UInt32(kvImageBackgroundColorFill))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIFastBlur(width width: Int, height: Int, backgroundColor: UIColor = UIColor.blackColor()) -> UIImage
//    {
//        let oddWidth = UInt32(width % 2 == 0 ? width + 1 : width)
//        let oddHeight = UInt32(height % 2 == 0 ? height + 1 : height)
//
//        var backgroundColor : Array<UInt8> = backgroundColor.getRGB()
//
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        var error = vImageTentConvolve_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, 0, 0, oddHeight, oddWidth, &backgroundColor, UInt32(kvImageBackgroundColorFill))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    func SIConvolutionFilter(kernel kernel: [Int16], divisor: Int, backgroundColor: UIColor = UIColor.blackColor()) -> UIImage
//    {
//        precondition(kernel.count == 9 || kernel.count == 25 || kernel.count == 49, "Kernel size must be 3x3, 5x5 or 7x7.")
//        let kernelSide = UInt32(sqrt(Float(kernel.count)))
//
//        var backgroundColor : Array<UInt8> = backgroundColor.getRGB()
//
//        let imageRef = self.CGImage
//
//        let inProvider = CGImageGetDataProvider(imageRef)
//        let inBitmapData = CGDataProviderCopyData(inProvider)
//
//        let inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        let pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef))
//
//        let outBuffer = vImage_Buffer(data: pixelBuffer, height: UInt(1 * Float(CGImageGetHeight(imageRef))), width: UInt(1 * Float(CGImageGetWidth(imageRef))), rowBytes: CGImageGetBytesPerRow(imageRef))
//
//        var imageBuffers = SIImageBuffers(inBuffer: inBuffer, outBuffer: outBuffer, pixelBuffer: pixelBuffer)
//
//        _ = vImageConvolve_ARGB8888(&imageBuffers.inBuffer, &imageBuffers.outBuffer, nil, 0, 0, kernel, kernelSide, kernelSide, Int32(divisor), &backgroundColor, UInt32(kvImageBackgroundColorFill))
//
//        let outImage = UIImage(fromvImageOutBuffer: imageBuffers.outBuffer, scale: self.scale, orientation: .Up)
//
//        free(imageBuffers.pixelBuffer)
//
//        return outImage!
//    }
//
//    convenience init?(fromvImageOutBuffer outBuffer:vImage_Buffer, scale:CGFloat, orientation: UIImageOrientation)
//    {
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//
//        let context = CGBitmapContextCreate(outBuffer.data, Int(outBuffer.width), Int(outBuffer.height), 8, outBuffer.rowBytes, colorSpace, CGImageAlphaInfo.NoneSkipFirst.rawValue )
//
//        let outCGimage = CGBitmapContextCreateImage(context)
//
//        self.init(CGImage: outCGimage!, scale:scale, orientation:orientation)
//    }
//
//
//}
//
//
    
// MARK: Utilities
typealias SIImageBuffers = (inBuffer: vImage_Buffer, outBuffer: vImage_Buffer, pixelBuffer: UnsafeMutableRawPointer)

struct SIConvolutionKernels {
    // Sample kernels for use with SIConvolutionFilter. Use a divisor of 1

    static let edgeDetectionOne:[Int16]  = [-1,-1,-1, -1,8,-1, -1,-1,-1]
    static let edgeDetectionTwo:[Int16]  = [0,1,0, 1,-4,1, 0,1,0]
    static let edgeDetectionThree:[Int16]  = [-1,-1,-1, -1,8,-1, -1,-1,-1]
    static let sharpen:[Int16] = [0,-1,0, -1,5,-1, 0,-1,0]
}

enum RotateNinety: UInt8
{
    case Zero = 0
    case Ninety = 1
    case OneEighty = 2
    case TwoSeventy = 3
}

extension UIColor {
    func getRGB() -> [UInt8] {
        func zeroIfDodgy(value: Float) -> Float {
            return value.isNaN || value.isInfinite ? 0 : value
        }

        if self.cgColor.numberOfComponents == 4 {
            guard let colorRef = self.cgColor.components else { return [0, 0, 0, 0] }

            let redComponent = UInt8(255 * zeroIfDodgy(value: Float(colorRef[0])))
            let greenComponent = UInt8(255 * zeroIfDodgy(value: Float(colorRef[1])))
            let blueComponent = UInt8(255 * zeroIfDodgy(value: Float(colorRef[2])))
            let alphaComponent = UInt8(255 * zeroIfDodgy(value: Float(colorRef[3])))

            return [redComponent, greenComponent, blueComponent, alphaComponent]
            
        } else if self.cgColor.numberOfComponents == 2 {
            guard let colorRef = self.cgColor.components else { return [0, 0, 0, 0] }

            let greyComponent = UInt8(255 * zeroIfDodgy(value: Float(colorRef[0])))
            let alphaComponent = UInt8(255 * zeroIfDodgy(value: Float(colorRef[1])))

            return [greyComponent, greyComponent, greyComponent, alphaComponent]
        } else {
            return [0, 0, 0, 0]
        }
    }
}
