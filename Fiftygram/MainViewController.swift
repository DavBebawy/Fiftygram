//  Created by Bebawy, David.

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    // MARK: - Stored Properties
    let context = CIContext()
    var originalImage = UIImage()
    var editedImage = UIImage()

    // MARK: - Lifecycle functions
    override func viewWillAppear(_ animated: Bool) {
        disableSaveAndResetButtons()
    }

    // MARK: - Functions

    /// Function to handle the tapping of the choose photo bar button
    @IBAction func choosePhotoBarButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary

            navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    /// Function to handle the tapping of the sepia button
    @IBAction func sepiaButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CISepiaTone")
    }

    /// Function to handle the tapping of the noir button
    @IBAction func noirButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectNoir")
    }

    /// Function to handle the tapping of the vintage button
    @IBAction func vintageButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectProcess")
    }

    /// Function to handle the tapping of the chrome button
    @IBAction func chromeButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectChrome")
    }

    /// Function to handle the tapping of the fade button
    @IBAction func fadeButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectFade")
    }

    /// Function to handle the tapping of the instant button
    @IBAction func instantButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectInstant")
    }

    /// Function to handle the tapping of the invert button
    @IBAction func invertButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIColorInvert")
    }

    /// Function to handle the tapping of the mono button
    @IBAction func monoButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectMono")
    }

    /// Function to handle the tapping of the process button
    @IBAction func processButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectProcess")
    }

    /// Function to handle the tapping of the transfer button
    @IBAction func transferButtonTapped(_ sender: Any) {
        applyFilter(filterKey: "CIPhotoEffectTransfer")
    }

    /// Function to handle the tapping of the save button
    @IBAction func saveButtonTapped(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(editedImage, displaySuccessfullySavedAlertController(), nil, nil)
    }

    /// Function to handle the tapping of the reset button
    @IBAction func resetButtonTapped(_ sender: Any) {
        // Setting the image view's image back to the original image
        imageView.image = originalImage

        // Disbaling the save and reset buttons
        disableSaveAndResetButtons()
    }

    /// Function to apply the selected filter to the original image
    /// - Parameter filterKey: The key for the CIFilter based on the user's filter selection
    private func applyFilter(filterKey: String) {
        guard let filter = CIFilter(name: filterKey) else {
            return
        }

        filter.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
        displayFilteredImage(withFilter: filter)
    }

    /// Function to display the selected filter on the image view to be visible to the user
    /// - Parameter filter: The CIFilter which reflects the filter that the user selected
    private func displayFilteredImage(withFilter filter: CIFilter) {
        guard let outputImage = filter.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }

        editedImage = UIImage(cgImage: outputCGImage)
        imageView.image = editedImage

        enableSaveAndResetButtons()
    }

    /// Function to enable the save and reset buttons both functionally and visually to the user
    private func enableSaveAndResetButtons() {
        // Enable the save button
        self.saveButton.isEnabled = true
        self.saveButton.alpha = 1

        // Enable the reset button
        self.resetButton.isEnabled = true
        self.resetButton.alpha = 1
    }

    /// Function to disable the save and reset buttons both functionally and visually to the user
    private func disableSaveAndResetButtons() {
        // Disable the save button
        self.saveButton.isEnabled = false
        self.saveButton.alpha = 0.5

        // Disable the reset button
        self.resetButton.isEnabled = false
        self.resetButton.alpha = 0.5
    }

    private func displaySuccessfullySavedAlertController() {
        // Create an alert controller
        let savedAlertController = UIAlertController(title: "Saved!", message: "Image has been saved to your photos", preferredStyle: .alert)
         //Add OK alert action to the alert controller
        savedAlertController.addAction(UIAlertAction(title: "OK", style: .default))

         // Present the alert controller
        present(savedAlertController, animated: true, completion: nil)
    }

}
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the presented UIAlertController
        navigationController?.dismiss(animated: true, completion: nil)

        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        // Setting the selected image to the image displayed on the imageview
        imageView.image = selectedImage
        // Storing the selected image in the originalImage stored property
        originalImage = selectedImage
    }
}
