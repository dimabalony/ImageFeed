//
//  ImageDetailViewController.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import UIKit

protocol ImageDetailView: AnyObject {
    func populateImage(_ image: UIImage)
}

class ImageDetailViewController: UIViewController {
    
    let presenter: ImageDetailPresenterProtocol
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(presenter: ImageDetailPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        makeConstraints()
        
        activityIndicator.startAnimating()
        
        presenter.viewDidLoad()
    }
}

private extension ImageDetailViewController {
    func setupView() {
        view.backgroundColor = .white
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeButton)
        view.addSubview(activityIndicator)
        view.addSubview(imageView)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

private extension ImageDetailViewController {
    @objc func closeButtonTapped() {
        presenter.closeButtonTapped()
    }
}

extension ImageDetailViewController: ImageDetailView {
    func populateImage(_ image: UIImage) {
        activityIndicator.startAnimating()
        
        let ratio = CGFloat(image.size.width) / CGFloat(image.size.height)
        let width = view.bounds.width - 30
        let height = width / ratio
        imageView.image = image
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
