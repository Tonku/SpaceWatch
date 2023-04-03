//
//  AstronautListViewController.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

class AstronautListViewController: UIViewController, AstronautListViewProtocol {
    var presenter: AstronautListPresenterProtols?
    var astronauts: [AatronautCellViewModelProtocol]?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AstronautTableViewCell.self, forCellReuseIdentifier: AstronautTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The server is busy, Please try again later."
        label.textColor = .red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.textColor = .gray
        return label
    }()
    
    private lazy var loadingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loadingIndicator, loadingLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortButtonTapped))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        presenter?.viewDidLoad()
        showLoading()
        setupNavigationBar()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        view.addSubview(loadingStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Astronauts"
        navigationController?.navigationBar.prefersLargeTitles = true
        updateSortButtonVisibility()
    }
    
    func displayAstronauts(astronauts: [AatronautCellViewModelProtocol]) {
        self.astronauts = astronauts
        tableView.reloadData()
        errorLabel.isHidden = true
        hideLoading()
        updateSortButtonVisibility()
    }
    
    func showError(error: Error) {
        errorLabel.isHidden = false
        hideLoading()
        updateSortButtonVisibility()
    }
    
    private func showLoading() {
        loadingStackView.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading() {
        loadingStackView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    @objc private func sortButtonTapped() {
        presenter?.userTappedToSortItems(astronautsVM: astronauts ?? [])
    }
    
    private func updateSortButtonVisibility() {
        if let astronauts = astronauts, !astronauts.isEmpty, errorLabel.isHidden {
            navigationItem.rightBarButtonItem = sortButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}

extension AstronautListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return astronauts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AstronautTableViewCell.identifier, for: indexPath) as? AstronautTableViewCell, let astronauts = astronauts else {
            return UITableViewCell()
        }
        let viewModel = astronauts[indexPath.row]
        cell.configureCell(cellViewModel: astronauts[indexPath.row])
        viewModel.imageRefreshCallback = {
            cell.configureCell(cellViewModel: viewModel)
        }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}

extension AstronautListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let astronauts = astronauts else {
            return
        }
        presenter?.didSelectAstronaut(astronaut: astronauts[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
