//
//  PageDetailViewController.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-06.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

class DetailViewController: UIViewController {

    var project: Project?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!

    var webViewIsObserving = false

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        updateUI()
    }

    func updateUI(){
        guard let project = project else { return }
        self.title = project.name
        if let url = URL(string: project.user.avatarUrl) {
            imageView.sd_setImage(with: url)
        }

        nameLabel.text = project.user.userName
        descriptionLabel.text = project.user.userName
        starLabel.text = "\(project.starsCount) Stars"
        forkLabel.text = "\(project.forksCount) Forks"
        loadWebView(project.readmeUrlString)
    }

    func addWebViewObserver(){
        webViewIsObserving = true
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    func removeWebViewObserver(){
        webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
        webViewIsObserving = false
    }

    func loadWebView(_ urlString: String){
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    func updateContentViewHeight(_ height: CGFloat) {
        webViewHeight.constant = height
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }

        if keyPath == "contentSize" {
            updateContentViewHeight(webView.scrollView.contentSize.height)
        }
    }

    deinit {
        removeWebViewObserver()
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateContentViewHeight(webView.scrollView.contentSize.height)
        if (!webViewIsObserving) {
            addWebViewObserver()
        }
    }
}
