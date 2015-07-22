//
//  ProfilePictureButton.swift
//  Sol
//
//  Created by Vijay on 6/26/15.
//  Copyright (c) 2015 Sol. All rights reserved.
//

import UIKit

class ProfilePictureButton: UIButton {

	private var imagePickerHandler : ImagePickerHandler?
	var selectedPicture : UIImage?
	private var containingController : UIViewController?
	var imagepickerDelegate : ImagePickerHandlerDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		configure()
	}
	
	func setController(controller : UIViewController, delegate : ImagePickerHandlerDelegate?) {
		containingController = controller
		imagepickerDelegate = delegate
	}
	
	private func configure() {
		addTarget(self, action: Selector("buttonPressed"), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	func buttonPressed() {
		
		if let pickerDelegate = imagepickerDelegate {
			imagePickerHandler = ImagePickerHandler.imagePicker(pickerDelegate, referenceController: containingController!)
		}
		else {
			imagePickerHandler = ImagePickerHandler.imagePicker(self, referenceController: containingController!)
		}

		imagePickerHandler!.showInView(hasRemoveOption: false)
	}

}

extension ProfilePictureButton : ImagePickerHandlerDelegate {
	
	func imagePickerHandlerDidPickedImage(image: UIImage?) {

		selectedPicture = image
		
		if let profilePic = image {
			setImage(profilePic, forState: .Normal)
		}
		else {
			setImage(UIImage.profilePlaceholder(), forState: .Normal)
		}
	}
	
}














