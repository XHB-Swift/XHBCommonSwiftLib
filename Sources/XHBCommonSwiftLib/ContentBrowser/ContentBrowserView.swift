//
//  ContentBrowserView.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/3.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#if os(iOS)

import UIKit

public protocol ContentBrowserPageData {
    
    associatedtype C
    
    var content: C { get set }
    var shouldCleanContent: Bool { get set }
}

open class ContentBrowserViewCell<P: ContentBrowserPageData>: UICollectionViewCell {
    
    open class var cellIdentifier: String {
        return String(describing: self)
    }
    
    private(set) var pageData: P?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func update(_ page: P) {
        self.pageData = page
    }
}

open class ContentBrowserFlowlayout: UICollectionViewFlowLayout {
    
    open var pageMargin: CGFloat = 20
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
        scrollDirection = .horizontal
    }
    
    open override func prepare() {
        super.prepare()
        
        guard let pageSize = collectionView?.size else { return }
        itemSize = pageSize
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let copyAttrs = super.layoutAttributesForElements(in: rect)
        guard let collection = collectionView else { return copyAttrs }
        switch scrollDirection {
        case .horizontal:
            let halfWidth = collection.width / 2.0
            let centerX = collection.contentOffset.x + halfWidth
            
            copyAttrs?.forEach({ attribute in
                let x = attribute.center.x + (attribute.center.x - centerX) / halfWidth * pageMargin / 2
                attribute.center = CGPoint(x: x, y: attribute.center.y)
            })
            break
        case .vertical:
            let halfHeight = collection.height / 2.0
            let centerY = collection.contentOffset.y + halfHeight
            
            copyAttrs?.forEach({ attribute in
                let y = attribute.center.y + (attribute.center.y - centerY) / halfHeight * pageMargin / 2
                attribute.center = CGPoint(x: attribute.center.x, y: y)
            })
            break
        @unknown default:
            break
        }
        
        return copyAttrs
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

open class ContentBrowserCollectionView: UICollectionView {
    
    open var centerCell: UICollectionViewCell? {
        guard var cell = visibleCells.first,
              let scrollDirection = flowlayout?.scrollDirection else { return nil }
        switch scrollDirection {
        case .horizontal:
            let pageCenterX = contentOffset.x + width / 2.0
            for i in 1..<visibleCells.count {
                let icell = visibleCells[i]
                if abs(icell.centerX - pageCenterX) < abs(cell.centerX - pageCenterX) {
                    cell = icell
                }
            }
            break
        case .vertical:
            let pageCenterY = contentOffset.y + height / 2.0
            for i in 1..<visibleCells.count {
                let icell = visibleCells[i]
                if abs(icell.centerY - pageCenterY) < abs(cell.centerY - pageCenterY) {
                    cell = icell
                }
            }
            break
        @unknown default:
            break
        }
        
        return cell
    }
    private(set) var flowlayout: ContentBrowserFlowlayout?
    private var cellIdentifiers = Set<String>()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(frame: CGRect) {
        let layout = ContentBrowserFlowlayout()
        super.init(frame: frame, collectionViewLayout: layout)
        flowlayout = layout
    }
    
    open func scroll(to page: Int) {
        guard let layout = flowlayout else { return }
        switch layout.scrollDirection {
        case .horizontal:
            contentOffset = CGPoint(x: width * CGFloat(page), y: 0)
            break
        case .vertical:
            contentOffset = CGPoint(x: 0, y: height * CGFloat(page))
            break
        @unknown default:
            break
        }
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        isScrollEnabled = !(view?.isKind(of: UISlider.self) ?? false)
        return view
    }
    
    open func reuseIdentifier(for cellClass: AnyClass) -> String {
        let identifier = String(describing: cellClass)
        if !cellIdentifiers.contains(identifier) {
            self .register(cellClass, forCellWithReuseIdentifier: identifier)
        }
        return identifier
    }
    
}

open class ContentBrowserViewModel<P: ContentBrowserPageData>: NSObject, UICollectionViewDataSource {
    
    open weak var collectionView: ContentBrowserCollectionView? {
        didSet {
            collectionView?.register(ContentBrowserViewCell<P>.self,
                                     forCellWithReuseIdentifier: ContentBrowserViewCell<P>.cellIdentifier)
            collectionView?.register(ContentBrowserViewCell<P>.self, forCellWithReuseIdentifier: "ContentBrowserViewErrorCell")
        }
    }
    
    open var shouldInfinitelyCarousel = false {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    private(set) var realContentCount = 0
    
    private var contents = Array<P>()
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count * (shouldInfinitelyCarousel ? realContentCount : 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let content = content(at: indexPath.item),
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentBrowserViewCell<P>.cellIdentifier, for: indexPath) as? ContentBrowserViewCell<P> {
            cell.update(content)
            return cell
        }else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ContentBrowserViewErrorCell", for: indexPath)
        }
        
    }
    
    open func content(at index: Int) -> P? {
        guard let collection = collectionView else { return nil }
        let numnberOfItems = collectionView(collection, numberOfItemsInSection: 0)
        let idx = shouldInfinitelyCarousel ? (index % realContentCount) : index
        if idx < numnberOfItems {
            return contents[idx]
        }else {
            return nil
        }
    }
    
    open func append(_ content: P) {
        append([content])
    }
    
    open func append(_ contentArr: [P]) {
        if contentArr.isEmpty { return }
        let items = (realContentCount..<realContentCount + contentArr.count).map { IndexPath(item: $0, section: 0) }
        contents.append(contentsOf: contentArr)
        realContentCount = contents.count
        collectionView?.insertItems(at: items)
    }
    
    open func scroll(to page: Int) {
        guard let scrollDirection = collectionView?.flowlayout?.scrollDirection else { return }
        switch scrollDirection {
        case .horizontal:
            collectionView?.contentOffset = CGPoint(x: (collectionView?.width ?? 0) * CGFloat(page), y: 0)
            break
        case .vertical:
            collectionView?.contentOffset = CGPoint(x: 0, y: (collectionView?.height ?? 0) * CGFloat(page))
            break
        @unknown default:
            break
        }
    }
}

public protocol ContentBrowserViewDelegate: AnyObject {
    
    func didClickEmptyArea<P: ContentBrowserPageData>(in view: ContentBrowserView<P>)
}

open class ContentBrowserView<P: ContentBrowserPageData>: UIView, UICollectionViewDelegate {
    
    private(set) var collectionView: ContentBrowserCollectionView?
    
    open var viewModel: ContentBrowserViewModel<P>? {
        didSet {
            viewModel?.collectionView = collectionView
            collectionView?.dataSource = viewModel
        }
    }
    
    open weak var delegate: ContentBrowserViewDelegate?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        let collection = ContentBrowserCollectionView(frame: bounds)
        collection.flowlayout?.itemSize = bounds.size
        collection.flowlayout?.scrollDirection = .horizontal
        collection.backgroundColor = .black
        collection.delegate = self;
        collection.isPagingEnabled = true
        collection.decelerationRate = .fast
        collection.alwaysBounceVertical = false
        collection.alwaysBounceHorizontal = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collection)
        collectionView = collection
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView?.frame = bounds
        collectionView?.flowlayout?.itemSize = bounds.size
    }
    
    open func scroll(to page: Int) {
        viewModel?.scroll(to: page - 1)
    }
    
    public override func responds(value: Any?, from sender: UIResponder, event name: String) {
        if name == .clickEmptyArea {
            delegate?.didClickEmptyArea(in: self)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let dataSource = viewModel,
              dataSource.shouldInfinitelyCarousel,
              let collection = collectionView ,
              let scrollDirection = collection.flowlayout?.scrollDirection else { return }
        
        let numberOfItems = dataSource.collectionView(collection, numberOfItemsInSection: 0)
        let offset: CGFloat
        var page: Int
        switch scrollDirection {
        case .horizontal:
            offset = scrollView.contentOffset.x
            page = Int(offset / width)
            break
        case .vertical:
            offset = scrollView.contentOffset.y
            page = Int(offset / height)
            break
        @unknown default:
            return
        }
        
        if page == 0 {
            page = dataSource.realContentCount
            dataSource.scroll(to: page)
        } else if page == numberOfItems {
            page = dataSource.realContentCount - 1
            dataSource.scroll(to: page)
        }
    }
}

extension String {
    
    public static let clickEmptyArea = "ContentBrowserViewCell.click.empty"
    public static let clickContentArea = "ContentBrowserViewCell.click.content"
}

//MARK: 按通用封装

open class ContentBrowserViewImageCell<P: ContentBrowserPageData>: ContentBrowserViewCell<P>,
                                                                   UIScrollViewDelegate,
                                                                   UIGestureRecognizerDelegate where P.C == URLType {
    
    private var imageView: UIImageView?
    private var scrollView: UIScrollView?
    private var currentLocation = CGPoint.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        setupSubviews()
        setupGestures()
    }
    
    private func setupSubviews() {
        let scroll = UIScrollView(frame: bounds)
        scroll.delegate = self
        scroll.minimumZoomScale = 0.5
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.decelerationRate = .fast
        scroll.alwaysBounceVertical = false
        scroll.alwaysBounceHorizontal = false
        if #available(iOS 11.0, *) {
            scroll.contentInsetAdjustmentBehavior = .never
        }
        contentView.addSubview(scroll)
        scrollView = scroll
        let imgView = UIImageView(frame: bounds)
        imgView.isUserInteractionEnabled = true
        imgView.layer.shouldRasterize = true
        imgView.contentMode = .scaleAspectFill
        scroll.addSubview(imgView)
        imageView = imgView
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView?.frame = contentView.bounds
        imageView?.center = CGPoint(x: contentView.width/2 , y: contentView.height/2)
    }
    
    private func setupGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        singleTap.numberOfTapsRequired = 1
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        
        singleTap.require(toFail: doubleTap)
        singleTap.require(toFail: pan)
        doubleTap.require(toFail: pan)
        
        contentView.addGestureRecognizer(singleTap)
        contentView.addGestureRecognizer(doubleTap)
        imageView?.addGestureRecognizer(pan)
    }
    
    @objc private func singleTapAction(_ sender: UITapGestureRecognizer) {
        guard let imgView = imageView else { return }
        let touchedPoint = sender.location(in: contentView)
        let clickEvent: String = !imgView.frame.contains(touchedPoint) ? .clickEmptyArea : .clickContentArea
        next?.responds(value: nil, from: self, event: clickEvent)
    }
    
    @objc private func doubleTapAction(_ sender: UITapGestureRecognizer) {
        guard let scroll = scrollView else { return }
        let point = sender.location(in: contentView)
        if scroll.zoomScale >= scroll.maximumZoomScale {
            scroll.setZoomScale(1, animated: true)
        }else {
            let maxScale = scroll.maximumZoomScale
            let s_width = scroll.width / maxScale
            let s_height = scroll.height / maxScale
            scroll.zoom(to: CGRect(origin: CGPoint(x: point.x - s_width/2, y: point.y - s_height/2),
                                   size: CGSize(width: s_width, height: s_height)),
                        animated: true)
        }
    }
    
    @objc private func panAction(_ sender: UIPanGestureRecognizer) {
//        guard let imgView = imageView,
//              (imgView.frame.isEmpty || imgView.image != nil) else { return }
//        let location = sender.location(in: contentView)
//        let point = sender.translation(in: contentView)
//        let velocity = sender.velocity(in: contentView)
//        
//        switch sender.state {
//        case .began:
//            currentLocation = location
//            break
//        case .changed:
//            let isRightSlide = (currentLocation.x > contentView.width / 2)
//            let denominator = isRightSlide ? contentView.height : contentView.width
//            let angel = (isRightSlide ? 1 : -1) * CGFloat.pi/2 * (point.y / denominator)
//            let transformAngel = CGAffineTransform(rotationAngle: angel)
//            let transformTranslation = CGAffineTransform(translationX: 0, y: point.y)
//            let transformConcat = transformAngel.concatenating(transformTranslation)
//            imageView?.transform = transformConcat
//            break
//        case .cancelled, .ended:
//            if abs(point.y) > 200 || abs(velocity.y) > 500 {
//                rotationCompletionAnimation(from: point)
//            }else {
//                cancelAnimation()
//            }
//            break
//        default:
//            break
//        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scroll = scrollView, let panGest = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        if scroll.contentSize.height > scroll.height { return false }
        
        let velocity = panGest.velocity(in: contentView)
        return !(abs(velocity.x) > abs(velocity.y))
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard var imageFrame = imageView?.frame else { return }
        
        let scrollFrame = scrollView.frame
        if imageFrame.height > scrollFrame.height {
            imageFrame.origin.y = 0
        }else {
            imageFrame.origin.y = (scrollFrame.height - imageFrame.height) / 2
        }
        if imageFrame.width > scrollFrame.width {
            imageFrame.origin.x = 0
        }else {
            imageFrame.origin.x = (scrollFrame.width - imageFrame.width) / 2
        }
        imageView?.frame = imageFrame
    }
    
    public override func update(_ page: P) {
        imageView?.setImage(with: page.content) {[weak self] result in
            switch result {
            case .success(let image):
                self?.updateImageViewFrame(image)
                break
            case .failure(_):
                self?.imageView?.frame = self?.contentView.bounds ?? .zero
                break
            }
        }
    }
    
    open override func prepareForReuse() {
        if pageData?.shouldCleanContent == true {
            imageView?.image = nil
        }
        super.prepareForReuse()
    }
    
    private func updateImageViewFrame(_ image: UIImage) {
        let imageSize = image.size
        let simageWidth = contentView.width
        let simageHeight = contentView.width * (imageSize.height / imageSize.width)
        imageView?.size = CGSize(width: simageWidth, height: simageHeight)
        if simageHeight <= contentView.height {
            imageView?.center = CGPoint(x: contentView.width/2, y: contentView.height/2)
        }else {
            imageView?.center = CGPoint(x: contentView.width/2, y: simageHeight/2)
        }
        
        if simageWidth / simageHeight > 2 {
            scrollView?.maximumZoomScale = contentView.height / simageHeight
        }
        scrollView?.contentSize = imageView?.size ?? .zero
        
        let screenScale = UIScreen.main.scale
        if screenScale == 0 { return }
        
        let widthScale = imageSize.width / screenScale / simageWidth
        scrollView?.zoomScale = 1
        scrollView?.minimumZoomScale = 1
        scrollView?.maximumZoomScale = max(widthScale, 1) * 1.5
    }
    
    private func rotationCompletionAnimation(from point: CGPoint) {
        
        let throwToTop = point.y < 0
        let fromLeft = currentLocation.x < contentView.width / 2
        
        let angel = (fromLeft && throwToTop ? 1 : -1) * CGFloat.pi_2
        let translateY = (fromLeft && throwToTop ? -1 : 1) * contentView.height
        
        let angel0 = (fromLeft ? -1 : 1) * (point.y / contentView.height)
        
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = angel0
        rotateAnim.toValue = angel
        let translateAnim = CABasicAnimation(keyPath: "transform.translation.y")
        translateAnim.fromValue = point.y
        translateAnim.toValue = translateY
        let animGroup = CAAnimationGroup()
        animGroup.duration = 0.6
        animGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        animGroup.animations = [rotateAnim, translateAnim]
        imageView?.layer.add(animGroup, forKey: "animGroup")
        
        let transformConcat = CGAffineTransform(rotationAngle: angel).concatenating(CGAffineTransform(translationX: 0, y: translateY))
        imageView?.transform = transformConcat
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.contentView.backgroundColor = .clear
        }, completion: { [weak self] finished in
            guard let strongSelf = self else { return }
            strongSelf.next?.responds(value: nil, from: strongSelf, event: .clickEmptyArea)
        })
    }
    
    private func cancelAnimation() {
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.imageView?.transform = .identity
            self?.superview?.superview?.backgroundColor = .black
        }, completion: nil)
    }
}

open class ContentBrowserImageViewModel<P: ContentBrowserPageData>: ContentBrowserViewModel<P> where P.C == URLType {
    
    open override var collectionView: ContentBrowserCollectionView? {
        didSet {
            collectionView?.register(ContentBrowserViewImageCell<P>.self, forCellWithReuseIdentifier: ContentBrowserViewImageCell<P>.cellIdentifier)
            collectionView?.register(ContentBrowserViewImageCell<P>.self, forCellWithReuseIdentifier: "ContentBrowserViewImageErrorCell")
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let content = content(at: indexPath.item),
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentBrowserViewImageCell<P>.cellIdentifier,
                                                         for: indexPath) as? ContentBrowserViewCell<P> {
            cell.update(content)
            return cell
        }else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ContentBrowserViewImageErrorCell", for: indexPath)
        }
    }
}

#endif
