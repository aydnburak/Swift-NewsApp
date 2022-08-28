//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Burak on 28.08.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.width - 170, height: 70)
        
        subTitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.width - 170, height: contentView.frame.height / 2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 150, y: 5, width: 150, height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.description
        
        if let data = viewModel.url {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.urlToImage {
            URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
                
                guard let data = data, error == nil else {
                    return
                }
                viewModel.url = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
    
}

class NewsTableViewCellViewModel {
    let title: String
    let description: String?
    var url: Data? = nil
    let urlToImage: URL?
    
    init(
        title: String,
        description: String?,
        urlToImage: URL?
    ){
        self.title = title
        self.description = description
        self.urlToImage = urlToImage
    }
}
