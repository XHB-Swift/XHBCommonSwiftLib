//
//  UIImageViewWebCache.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/6.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#if os(iOS)

import UIKit

private let lock = DispatchSemaphore(value: 1)
private let kBytesPerPixel = 4
private let kBitsPerComponent = 8

public typealias ImageLoadCompletion = (_ result: Result<UIImage, Error>) -> Void

public enum ImageScale {
    case auto
    case scale(s_width: CGFloat, s_height: CGFloat)
}

public struct ThumbnailConfig {
    let pointSize: CGSize
    let scale: ImageScale
    
    public static let noThumbnail = ThumbnailConfig(pointSize: .zero, scale: .auto)
}

public protocol URLType {
    
    var url: URL? { get }
}

extension String: URLType {
    
    public var url: URL? {
        return hasPrefix("file://") ? URL(fileURLWithPath: self) : URL(string: self)
    }
}

extension URL: URLType {
    
    public var url: URL? { return self }
}

extension UIImage {
    
    public convenience init?(url: URLType, to size: CGSize, scale: ImageScale = .auto) {
        guard let realUrl = url.url else { return nil }
        let imageSourceOptions = [kCGImageSourceShouldCache : false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(realUrl as CFURL, imageSourceOptions) else { return nil }
        let maxDimensionInPixels: CGFloat
        switch scale {
        case .auto:
            maxDimensionInPixels = max(size.width, size.height) / (max(size.width, size.height) / min(size.width, size.height))
        case .scale(let s_width, let s_height):
            maxDimensionInPixels = max(size.width, size.height) * (s_width / s_height)
        }
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceShouldCacheImmediately : true,
            kCGImageSourceThumbnailMaxPixelSize : maxDimensionInPixels,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        self.init(cgImage: downsampledImage)
    }
    
    open var decoded: UIImage? {
        if !shouldDecode {
            return self
        }
        var resultWithoutAplha: UIImage? = nil
        autoreleasepool { [weak self] in
            
            guard let imageRef = self?.cgImage,
                  let colorSpaceRef = imageRef.colorSpace else {
                resultWithoutAplha = self
                return
            }
            let width = imageRef.width
            let height = imageRef.height
            let bytesPerRow = kBytesPerPixel * width
            guard let context = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: kBitsPerComponent,
                                          bytesPerRow: bytesPerRow,
                                          space: colorSpaceRef,
                                          bitmapInfo: CGImageByteOrderInfo.order32Big.rawValue) else {
                resultWithoutAplha = self
                return
            }
            context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
            guard let decodedImageRef = context.makeImage() else {
                resultWithoutAplha = self
                return
            }
            resultWithoutAplha = UIImage(cgImage: decodedImageRef, scale: scale, orientation: imageOrientation)
        }
        return resultWithoutAplha
    }
    
    open var shouldDecode: Bool {
        if images != nil {
            return false
        }
        
        guard let alphaInfo = cgImage?.alphaInfo else { return true }
        return !(alphaInfo == .first ||
                 alphaInfo == .last ||
                 alphaInfo == .premultipliedFirst ||
                 alphaInfo == .premultipliedLast)
    }
    
    open class func fetchImage(with url: URLType,
                               thumbnail: ThumbnailConfig = .noThumbnail,
                               completion: ImageLoadCompletion? = nil) {
        guard let urlString = url.url?.absoluteString else { return }
        fetchCachedFile(with: urlString, dirName: "ImageCache") { result in
            switch result {
            case .success(let localUrl):
                DispatchQueue.global().async {
                    if let thumbnailImage = UIImage(url: localUrl, to: thumbnail.pointSize, scale: thumbnail.scale)?.decoded {
                        DispatchQueue.main.async {
                            completion?(.success(thumbnailImage))
                        }
                        return
                    }
                    if let image = UIImage(contentsOfFile: localUrl.relativePath)?.decoded {
                        DispatchQueue.main.async {
                            completion?(.success(image))
                        }
                        return
                    }
                }
            case .failure(let error):
                completion?(.failure(error))
                return
            }
        }
    }
    
    @available(iOS 13.0, *)
    open class func fetchAsyncImage(with url: URLType, thumbnail: ThumbnailConfig = .noThumbnail) async throws -> UIImage {
        return try await withTaskCancellationHandler(operation: {
            return try await withUnsafeThrowingContinuation({ continuation in
                fetchImage(with: url, thumbnail: thumbnail) { result in
                    switch result {
                    case .success(let img):
                        continuation.resume(returning: img)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            })
        }, onCancel: {
            
        })
    }
}

extension UIImageView {
    
    open func setImage(with url: URLType,
                       thumbnail: ThumbnailConfig = .noThumbnail,
                       completion: ImageLoadCompletion? = nil) {
        if #available(iOS 13, *) {
            Task {
                do {
                    let img = try await UIImage.fetchAsyncImage(with: url, thumbnail: thumbnail)
                    self.image = img
                    completion?(.success(img))
                } catch {
                    completion?(.failure(error))
                    print("error = \(error)")
                }
            }
        } else {
            UIImage.fetchImage(with: url, thumbnail: thumbnail) { [weak self] result in
                switch result {
                case .success(let img):
                    self?.image = img
                    break
                case .failure(let error):
                    print("error = \(error)")
                    break
                }
                completion?(result)
            }
        }
    }
}

#endif
