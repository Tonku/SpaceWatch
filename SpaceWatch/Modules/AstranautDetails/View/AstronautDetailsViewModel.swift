//
//  AstronautDetailsViewModel.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

protocol AstronautDetailsViewModelProtocol: AnyObject {
    var astronaut: AstronautDetails { get }
    var name: String { get }
    var nationality: String { get }
    var profileImage: URL { get }
    var bio: String { get }
    var dateOfBirth: String { get }
    var uiImage: UIImage? { get }
    var imageRefreshCallback: (() -> Void)? { get set }
    
}

class AstronautDetailsViewModel: AstronautDetailsViewModelProtocol {
    var imageRefreshCallback: (() -> Void)?
    private var imageCache: UIImage?
    
    var uiImage: UIImage? {
        if nil != imageCache {
            return imageCache
        }
        ImageDownloader().downloadImage(from: profileImage) { [weak self] image in
            self?.imageCache = image
            if nil != image {
                DispatchQueue.main.async {
                    self?.imageRefreshCallback?()
                }
            }
        }
        return UIImage(named: "profile_image")!
    }
    
    let astronaut: AstronautDetails
    
    var name: String {
        astronaut.name
    }
    
    var nationality: String {
        astronaut.nationality
    }
    
    var profileImage: URL {
        URL(string: astronaut.profileImage)!
    }
    
    var bio: String {
        astronaut.bio
    }
    
    var dateOfBirth: String {
        "Born: " + (astronaut.dateOfBirth.convertToFormattedDate() ?? "Unknown")
    }
    
    init(astronaut: AstronautDetails) {
        self.astronaut = astronaut
    }
}

class ImageDownloader {
    private let urlSession: any URLSessionProtocol
    
    init(urlSession: any URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        
        task.resume()
    }
}
