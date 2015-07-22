//
//  ImagePickerCropView.swift
//  MiddleTon
//
//  Created by Vijay on 6/2/15.
//  Copyright (c) 2015 MT. All rights reserved.
//

import UIKit

// MARK: - Protocol 

protocol ImagePickerCropViewDelegate {
	func imagePickerCropViewChooseImage(sender : ImagePickerCropView, image : UIImage)
	func imagePickerCropViewCancel(sender : ImagePickerCropView)
}

// MARK: - Class -

class ImagePickerCropView: UIView {

	// MARK: - Outlets -
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cropView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	// MARK: - Properties -
	
	var delegate : ImagePickerCropViewDelegate?
	
	// MARK: - NSObject -
	
	override func awakeFromNib() {
		super.awakeFromNib()
		cropView.border.width = 1.0
		cropView.border.color = UIColor.whiteColor()
	}
	
	// MARK: - UIView -
	
	override func layoutSubviews() {
		super.layoutSubviews()
		scrollView.contentSize = imageView.image!.size
	}
	
	// MARK: - Actions -
	
	@IBAction func cancelPressed(sender: UIButton) {
		UIView.animateWithDuration(0.35, animations: { () -> Void in
			self.alpha = 0
		}) { (finished) -> Void in
			self.removeFromSuperview()
		}
		delegate?.imagePickerCropViewCancel(self)
	}
	
	@IBAction func choosePressed(sender: UIButton) {
		UIView.animateWithDuration(0.35, animations: { () -> Void in
			self.alpha = 0
			}) { (finished) -> Void in
				self.removeFromSuperview()
		}
		delegate?.imagePickerCropViewChooseImage(self, image: croppedImage())
	}
	
	// MARK: - Crop Image
	
	private func croppedImage() -> UIImage {
	
		UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, true, 1.0)
		scrollView.layer.renderInContext(UIGraphicsGetCurrentContext())
		var snapShot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		var image = imageView.image!
		var cropRect = cropView.frame
		
		var croppedCGImage = CGImageCreateWithImageInRect(snapShot.CGImage, cropRect)
		var croppedImage = UIImage(CGImage: croppedCGImage)!
		return croppedImage

	}

}

// MARK: - Extensions -

// MARK: - UIScrollViewDelegate -

extension ImagePickerCropView : UIScrollViewDelegate {
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}

	func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
		
	}

}













