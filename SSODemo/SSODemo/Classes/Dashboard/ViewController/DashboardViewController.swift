//
//  DashboardViewController.swift
//  SSODemo
//
//  Created by wfh on 07/01/19.
//  Copyright © 2019 Harsha. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class DashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
        }
    }
    
    var givenName: String?
    var familyName: String?
    var profileAvatarImageURL: URL?
    
    @IBOutlet weak var avatarBackGroundView: UIView! {
        didSet {
            avatarBackGroundView.layer.cornerRadius = avatarBackGroundView.frame.size.width/2
            avatarBackGroundView.clipsToBounds = true
            avatarBackGroundView.layer.borderColor = UIColor.black.cgColor
            avatarBackGroundView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var viewModel : DashboardViewControllerViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        viewModel = DashboardViewControllerViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        reigisterNibs()
    }
    
    func updateView() {
        if let url = profileAvatarImageURL {
            downloadGoogleAvatar(from: url)
        } else {
            avatarImageView.image = UIImage.init(named: "ImageToShare")
        }
        titleLabel.text = String(format: "Welcome Aboard ! \n \n %@ %@", arguments: [givenName ?? "IRON", familyName ?? "MAN"])
        tableView.tableFooterView = UIView()
        
        let backButton: UIBarButtonItem = UIBarButtonItem.init(title: "Log Out", style: .plain, target: self, action: #selector(self.onClickLogOutButton(_:)))
        self.navigationItem.rightBarButtonItem = backButton
    }
    
    @objc func onClickLogOutButton (_ sender:UIBarButtonItem) {
        GIDSignIn.sharedInstance()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func reigisterNibs() {
        tableView.register(UINib.init(nibName: cellID.UIComponentsTableViewCellID, bundle: nil), forCellReuseIdentifier: cellID.UIComponentsTableViewCellID)
    }

    deinit {
        NSLog("DashboardViewController: Dinit")
    }
}

//MARK: Image Downloader
extension DashboardViewController {
    func imageDownloader(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadGoogleAvatar(from url: URL) {
        imageDownloader(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.avatarImageView.image = UIImage(data: data)
            }
        }
    }
}

//MARK: UITableViewDelegate &UITableViewDataSource
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowsInSection = viewModel?.dummyModelData().count {
            return rowsInSection
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UIComponentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID.UIComponentsTableViewCellID, for: indexPath) as? UIComponentsTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = viewModel?.dummyModelData()[indexPath.row].componentName
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: Constants.StoryBoardID.dashboardDetailsStoryboard, bundle: nil)
        switch indexPath.row {
        case cellID.cellTag.carthageWithLottieAnimation.rawValue:
            let vc = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllerID.carthageWithLottieAnimationViewController)
            self.navigationController?.pushViewController(vc, animated: true)
        case cellID.cellTag.coredataWithImagePicker.rawValue:
            let vc = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllerID.coreDataWtihImagePickerViewController)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case cellID.cellTag.shareActivityControlelr.rawValue:
            let vc = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllerID.shareActivityViewController)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
