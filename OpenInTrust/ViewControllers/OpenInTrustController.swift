// Copyright SIX DAY LLC. All rights reserved.

import UIKit
import MobileCoreServices

class OpenInTrustController: UIViewController {

    lazy var viewModel: OpenInTrustViewModel = {
        let viewModel = OpenInTrustViewModel(context: self.extensionContext ?? NSExtensionContext())
        return viewModel
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        run()
    }

    func run() {
        guard let context = extensionContext else {
            showError(.invalidContext)
            return
        }
        // setup view model
        viewModel = OpenInTrustViewModel(context: context)
        guard let provider = viewModel.findItemProvider() else {
            return showError(.invalidProvider)
        }

        viewModel.loadItem(provider: provider) { [unowned self] (result) in
            switch result {
            case .success(let url):
                self.openInTrust(url: url)
            case .failure(let error):
                self.showError(error)
            }
        }
    }

    func done() {
        self.viewModel.context.completeRequest(returningItems: nil, completionHandler: nil)
    }

    func cancel(_ error: OpenInTrustError) {
        self.viewModel.context.cancelRequest(withError: error)
    }

    private func openInTrust(url: URL) {
        let alert = UIAlertController(title: viewModel.confirmAlertTitle, message: String(format: viewModel.confirmAlertMessage, url.absoluteString), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.viewModel.alertOK, style: .default, handler: { [unowned self] _ in
            let builder = SchemeBuilder(target: url)
            self.openUrl(builder.build())
            self.done()
        }))
        alert.addAction(UIAlertAction(title: self.viewModel.alertCancel, style: .cancel, handler: { [unowned self] _ in
            self.done()
        }))
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.frame
        present(alert, animated: true, completion: nil)
    }

    private func openUrl(_ url: URL) {
        var responder = self as UIResponder?
        while let r = responder {
            let sel = NSSelectorFromString("openURL:")
            if r.responds(to: sel) {
                r.perform(sel, with: url)
            }
            responder = r.next
        }
    }

    private func showError(_ error: OpenInTrustError) {
        let alert = UIAlertController(title: viewModel.errorAlertTitle, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.alertOK, style: .default, handler: { [unowned self] _ in
            self.cancel(error)
        }))
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.frame
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
