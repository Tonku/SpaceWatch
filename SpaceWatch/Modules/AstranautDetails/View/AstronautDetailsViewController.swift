//
//  AstronautDetailsViewController.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit


class AstronautDetailViewController: UIViewController, AstronautDetailsViewProtocol {
    
    var presenter: AstronautDetailsPresenterProtocol?
    
    private let cellIdentifier = "kAstronautDetailCell"
    
    private var astronautDetails: AstronautDetailsViewModelProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingStackView: UIStackView!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private lazy var errorLeabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Something went wrong, Please try again later."
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
       
        showLoading()
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter?.viewDidLoad()
    }
    
    
    
    private func showLoading() {
        loadingStackView.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading() {
        loadingStackView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    // MARK: - AstronautDetailsViewProtocol
    
    func displayAstronautDetail(astronautDetails: AstronautDetailsViewModelProtocol) {
        self.astronautDetails = astronautDetails
        navigationItem.title = astronautDetails.name
        errorLabel.isHidden = true
        hideLoading()
        tableView.reloadData()
    }
    
    func showError(error: Error) {
        errorLabel.isHidden = false
        hideLoading()
    }
    
    deinit {
        print("Deallocated AstronautDetailViewController")
    }
}

extension AstronautDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return astronautDetails == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AstronautDetailsTableViewCell
        
        if let details = astronautDetails {
            cell.nationalityLabel.text = details.nationality
            cell.dateOfBirthLabel.text = details.dateOfBirth
            cell.bioLabel.text = details.bio
            cell.profileImageView?.image = details.uiImage
            details.imageRefreshCallback =  { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        return cell
    }
}

extension AstronautDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

class AstronautDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

}
