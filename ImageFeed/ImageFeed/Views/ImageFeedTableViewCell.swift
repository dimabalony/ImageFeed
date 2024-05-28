//
//  ImageFeedTableViewCell.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 18.05.24.
//

import UIKit

final class ImageFeedTableViewCell: UITableViewCell {
    
    private let authorsNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let containerPhotoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shadowPhotoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.isHidden = true
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var photoImageViewHeightConstraint: NSLayoutConstraint?
    var preferredWidth: CGFloat?
    
    private var cancelImageFetching: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        makeConstraints()
    }
    
    func setupModel(_ model: ImageFeedItem, preferredWidth: CGFloat) {
        authorsNameLabel.text = model.authorsName
        
        let ratio = CGFloat(model.width) / CGFloat(model.height)
        let newWidth = preferredWidth - 30
        let newHeight = newWidth / ratio
        photoImageViewHeightConstraint?.constant = newHeight
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        shadowPhotoView.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 20).cgPath
        activityIndicator.startAnimating()
        
        model.imageProvider.fetchImage(for: model.previewURL) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(image):
                self.photoImageView.image = image
                self.activityIndicator.stopAnimating()
                self.shadowPhotoView.isHidden = false
            case let .failure(error):
                print(error.localizedDescription)
                // MARK: Handle Error
            }
        }
        
        cancelImageFetching = {
            model.imageProvider.cancelPreparingImage(for: model.previewURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancelImageFetching?()
        photoImageView.image = nil
        shadowPhotoView.isHidden = true
    }
}

private extension ImageFeedTableViewCell {
    func setupView() {
        contentView.addSubview(authorsNameLabel)
        contentView.addSubview(containerPhotoView)
        containerPhotoView.addSubview(shadowPhotoView)
        containerPhotoView.addSubview(activityIndicator)
        containerPhotoView.addSubview(photoImageView)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            authorsNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            authorsNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            authorsNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            
            containerPhotoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerPhotoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17),
            containerPhotoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerPhotoView.topAnchor.constraint(equalTo: authorsNameLabel.bottomAnchor, constant: 13),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerPhotoView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerPhotoView.centerYAnchor),
            
            shadowPhotoView.leadingAnchor.constraint(equalTo: containerPhotoView.leadingAnchor),
            shadowPhotoView.bottomAnchor.constraint(equalTo: containerPhotoView.bottomAnchor),
            shadowPhotoView.trailingAnchor.constraint(equalTo: containerPhotoView.trailingAnchor),
            shadowPhotoView.topAnchor.constraint(equalTo: containerPhotoView.topAnchor),
            
            photoImageView.leadingAnchor.constraint(equalTo: containerPhotoView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: containerPhotoView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: containerPhotoView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: containerPhotoView.topAnchor),
        ])
        
        photoImageViewHeightConstraint = containerPhotoView.heightAnchor.constraint(equalToConstant: 300)
        photoImageViewHeightConstraint?.priority = .init(999)
        photoImageViewHeightConstraint?.isActive = true
    }
}

extension ImageFeedTableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
