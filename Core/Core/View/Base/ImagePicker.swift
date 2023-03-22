//
//  ImagePicker.swift
//  Core
//
//  Created by  Stepanok Ivan on 28.11.2022.
//

import PhotosUI
import SwiftUI

public struct ImagePickerView: UIViewControllerRepresentable {
    
    public init(image: Binding<UIImage?>) {
        self._selectedImage = image
    }
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePickerView
        
        public init(picker: ImagePickerView) {
            self.picker = picker
        }
        
        public func imagePickerController(_ picker: UIImagePickerController,
                                          didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
            self.picker.selectedImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.jpeg"]
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
