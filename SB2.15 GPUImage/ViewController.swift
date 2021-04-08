//
//  ViewController.swift
//  SB2.15 GPUImage
//
//  Created by Артём on 3/30/21.
//

import UIKit
import EVGPUImage2
//import GPUImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let filtersArray = ["No Filter", "Color Adjustments", "Mixed Color Adjustments", "Visual Effects", "Combo Visual Effects", "Custom"]
    var selectedFilter = "Default"
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mediaZoneView: UIView!
    
    let imagePickerController = UIImagePickerController()
    var movieURL: URL?
    
    var pictureInput: PictureInput!
    var movieInput: MovieInput!
    
    var output: RenderView!

    var filter: SaturationAdjustment!
    var myfilter: Pixellate!

    override func viewDidLoad() {
        super.viewDidLoad()
        getInputs()
        output = RenderView(frame: mediaZoneView.bounds)
        mediaZoneView.addSubview(output)
        applyFilter()
        
    }
    
    func getInputs(){
        pictureInput = PictureInput(image:UIImage(named:"nat")!)
        let bundleURL = Bundle.main.resourceURL!
        movieURL = URL(string:"train.mp4", relativeTo:bundleURL)!
    }
    
    func applyFilter(){
        switch selectedFilter {
        case "No Filter":
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                pictureInput --> output
                pictureInput.processImage()
            case 1:
                do {
                    movieInput = try MovieInput(url: movieURL!, playAtActualSpeed:true, loop: false)
                    movieInput --> output
                    movieInput.runBenchmark = true
                    movieInput.start()
                } catch {
                    print("Couldn't process movie with error: \(error)")
                }
            default:
                break
            }
        case "Color Adjustments":
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                let filter = ColorInversion()
                pictureInput --> filter --> output
                pictureInput.processImage()
            case 1:
                do {
                    movieInput = try MovieInput(url: movieURL!, playAtActualSpeed:true, loop: false)
                    let filter = ColorInversion()
                    movieInput --> filter --> output
                    movieInput.runBenchmark = true
                    movieInput.start()
                } catch {
                    print("Couldn't process movie with error: \(error)")
                }
            default:
                break
            }
        case "Mixed Color Adjustments":
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                let filter = SaturationAdjustment()
                let filter2 = ColorInversion()
                let filter3 = ColorMatrixFilter()
                
                filter.saturation = 10.0
                pictureInput --> filter --> filter2 --> filter3 --> output
                pictureInput.processImage()
            case 1:
                do {
                    movieInput = try MovieInput(url: movieURL!, playAtActualSpeed:true, loop: false)
                    let filter = SaturationAdjustment()
                    let filter2 = GammaAdjustment()
                    filter2.gamma = 0.5
                    let filter3 = ColorMatrixFilter()
                    
                    movieInput --> filter --> filter2 --> filter3 --> output
                    movieInput.runBenchmark = true
                    movieInput.start()
                } catch {
                    print("Couldn't process movie with error: \(error)")
                }
            default:
                break
            }
        case "Visual Effects":
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                let filter = Pixellate()
                pictureInput --> filter --> output
                pictureInput.processImage()
            case 1:
                do {
                    movieInput = try MovieInput(url: movieURL!, playAtActualSpeed:true, loop: false)
                    let filter = Pixellate()
                    movieInput --> filter --> output
                    movieInput.runBenchmark = true
                    movieInput.start()
                } catch {
                    print("Couldn't process movie with error: \(error)")
                }
            default:
                break
            }
        case "Combo Visual Effects":
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                let filter = SphereRefraction()
                let filter2 = KuwaharaFilter()
                
                pictureInput --> filter --> filter2  --> output
                pictureInput.processImage()
            case 1:
                do {
                    movieInput = try MovieInput(url: movieURL!, playAtActualSpeed:true, loop: false)
                    let filter = SphereRefraction()
                    let filter2 = KuwaharaFilter()
                    movieInput --> filter --> filter2  --> output
                    movieInput.runBenchmark = true
                    movieInput.start()
                } catch {
                    print("Couldn't process movie with error: \(error)")
                }
            default:
                break
            }
        case "Custom":
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                let myFilter = LookupFilter()
                myFilter.lookupImage = PictureInput(image: UIImage(named: "myfilter")!)
                pictureInput --> myFilter --> output
                pictureInput.processImage()
            case 1:
                do {
                    movieInput = try MovieInput(url: movieURL!, playAtActualSpeed:true, loop: false)
                    let myFilter = LookupFilter()
                    myFilter.lookupImage = PictureInput(image: UIImage(named: "myfilter")!)
                    movieInput --> myFilter --> output
                    movieInput.runBenchmark = true
                    movieInput.start()
                } catch {
                    print("Couldn't process movie with error: \(error)")
                }
                
            default:
                break
            }
        default:
            pictureInput --> output
            pictureInput.processImage()
        }
    }
    
    
    @IBAction func addMedia(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        movieURL = info[.mediaURL] as? URL
        print(movieURL ?? "niiil")
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlPressed(_ sender: Any) {
        if mediaZoneView.contains(output){ output.removeFromSuperview() }
        output = RenderView(frame: mediaZoneView.bounds)
        mediaZoneView.addSubview(output)
        applyFilter()
        }
        
        
    //        func applyFilter(){
    //
    //            switch segmentedControl.selectedSegmentIndex {
    //            case 0:
    //                print("photo")
    //                pictureInput = PictureInput(image:UIImage(named:"nat")!)
    //
    //                filter = SaturationAdjustment()
    //                filter.saturation = 10.0
    //
    ////                pictureInput --> filter --> output
    ////                pictureInput.processImage()
    //                chooseFilter()
    //            case 1:
    //                print("video")
    //                let bundleURL = Bundle.main.resourceURL!
    //                let movieURL = URL(string:"train.mp4", relativeTo:bundleURL)!
    //                print(movieURL)
    //
    //                do {
    //                    movieInput = try MovieInput(url: movieURL, playAtActualSpeed:true, loop: false)
    ////                    filter = SaturationAdjustment()
    ////                    filter.saturation = 10.0
    //                    chooseFilter()
    //                } catch {
    //                    print("Couldn't process movie with error: \(error)")
    //                }
    //
    //            default:
    //                break
    //            }
    //        }
    

    

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .cyan
        cell.filterName.text = filtersArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell{
            cell.showIcon()
        }
        selectedFilter = filtersArray[indexPath.row]
        if mediaZoneView.contains(output){ output.removeFromSuperview() }
        output = RenderView(frame: mediaZoneView.bounds)
        mediaZoneView.addSubview(output)
        applyFilter()
        print(selectedFilter)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell{
            cell.hideIcon()
        }
    }
    
    
}

