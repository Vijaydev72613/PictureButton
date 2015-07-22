//
//  ImagePickerHandler.swift
//  CampusJob
//
//  Created by Vijay on 4/7/15.
//  Copyright (c) 2015 Camus Job. All rights reserved.
//

import UIKit
import MobileCoreServices

// MARK: - Protocol -

protocol ImagePickerHandlerDelegate {
	
	func imagePickerHandlerDidPickedImage(image: UIImage?)
	
}

// MARK: - Class -

class ImagePickerHandler: UIImagePickerController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// MARK: - Properties -
	
	private var imagePickerDelegate: ImagePickerHandlerDelegate?
	private var referenceController: UIViewController?
	var imageCropView : ImagePickerCropView?
	
	// MARK: - Initialization -
	
	class func imagePicker(delegate: ImagePickerHandlerDelegate, referenceController: UIViewController) -> ImagePickerHandler{
		let imagePickerHandler = ImagePickerHandler()
		imagePickerHandler.imagePicker(delegate, referenceController: referenceController)
		return imagePickerHandler
	}
	
	func imagePicker(delegate: ImagePickerHandlerDelegate, referenceController: UIViewController) -> ImagePickerHandler {
		self.imagePickerDelegate = delegate
		self.referenceController = referenceController
		return self
	}
	
	// MARK: - UIImagePickerControllerDelegate -
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			if imageCropView == nil {
				imageCropView = NSBundle.mainBundle().loadNibNamed("ImagePickerCropView", owner: self, options: nil).first! as? ImagePickerCropView
			}
			
			imageCropView!.frame = view.frame
			imageCropView!.imageView.image = image
			imageCropView!.alpha = 0
			imageCropView!.delegate = self
			view.addSubview(imageCropView!)
			
			UIView.animateWithDuration(0.35, animations: { () -> Void in
				self.imageCropView!.alpha = 1.0
			})
		}
		

	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		referenceController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - UIActionSheetDelegate -
	
	func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		
		if buttonIndex == 1 {
			showImagePicker(.PhotoLibrary)
		}
		else if buttonIndex == 2 {
			showImagePicker(.Camera)
		}
		else if buttonIndex == 3 {
			imagePickerDelegate?.imagePickerHandlerDidPickedImage(nil)
		}
	}
	
	// MARK: - Convenience -
	
	func showInView(hasRemoveOption : Bool = true) {
		
		var actionSheet : UIActionSheet?
		if hasRemoveOption == true {
			actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo Library", "Camera", "Remove")
		}
		else {
			actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo Library", "Camera")
		}
		
		actionSheet!.showInView(referenceController?.view)
	}
	
	func showImagePicker(type : UIImagePickerControllerSourceType ,mediaTypes : [AnyObject] = [kUTTypeImage]) {
	
		sourceType = type
		delegate = self
		if type == .Camera {
			cameraDevice = .Front
			cameraFlashMode = .Auto
		}
		else {
			
		}

		self.mediaTypes = mediaTypes
		referenceController?.presentViewController(self, animated: true, completion: nil)
	}
	
}

// MARK: - Extensions -

// MARK: - ImagePickerCropViewDelegate -

extension ImagePickerHandler : ImagePickerCropViewDelegate {
	
	func imagePickerCropViewChooseImage(sender: ImagePickerCropView, image: UIImage) {
		imagePickerDelegate?.imagePickerHandlerDidPickedImage(image)
		referenceController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerCropViewCancel(sender: ImagePickerCropView) {
		referenceController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
}















