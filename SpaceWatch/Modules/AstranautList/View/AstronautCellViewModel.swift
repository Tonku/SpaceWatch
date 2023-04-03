//
//  AstronautCellViewModel.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

protocol AatronautCellViewModelProtocol: AnyObject {
    var astronaut: Astronaut { get }
    var id: Int { get }
    var name: String { get }
    var nationality: String { get }
    var profileImageThumbnail: URL { get }
    var uiImage: UIImage? { get }
    var imageRefreshCallback: (() -> Void)? { get set }
}

class AstronautCellViewModel: AatronautCellViewModelProtocol {
    var imageRefreshCallback: (() -> Void)?
    private var imageCache: UIImage?
    
    var uiImage: UIImage? {
        if nil != imageCache {
            return imageCache
        }
        ImageDownloader().downloadImage(from: profileImageThumbnail) { [weak self] image in
            self?.imageCache = image
            if nil != image {
                DispatchQueue.main.async {
                    self?.imageRefreshCallback?()
                }
            }
        }
        return UIImage(named: "profile_image")!
    }
    let astronaut: Astronaut
    var id: Int {
        astronaut.id
    }
    var name: String {
        astronaut.name
    }
    var nationality: String {
        astronaut.nationality
    }
    var profileImageThumbnail: URL {
        URL(string: astronaut.profileImageThumbnail)!
    }
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
    }
}

