//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import LedgerPayment
import Ion

final class ExampleViewController: UIViewController {

    private lazy var receiptUpdateEventCollector: Collector<Receipt> = .init(source: Ledger.receiptUpdateEventSource)
    private lazy var purchaseEventCollector: Collector<PurchaseInfo> = .init(source: Ledger.purchaseEventSource)
    private lazy var productInfoCollector: Collector<Product> = .init(source: Ledger.productInfoSource)

    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var monthlyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Purchase monthly", for: .normal)
        button.addTarget(self, action: #selector(monthlyButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var yearlyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Purchase yearly", for: .normal)
        button.addTarget(self, action: #selector(yearlyButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(greetingLabel)
        view.addSubview(monthlyButton)
        view.addSubview(yearlyButton)
        view.backgroundColor = .white
        checkSubscriptionStatus()

        receiptUpdateEventCollector.subscribe { (receipt: Receipt) in
            print(receipt)
        }

        productInfoCollector.subscribe { (product: Product) in
            print(product)
        }

        purchaseEventCollector.subscribe { (info: PurchaseInfo) in
            self.showAlert(withTitle: "Success", message: info.identifier)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        greetingLabel.sizeToFit()
        greetingLabel.center = view.center

        monthlyButton.sizeToFit()
        monthlyButton.center = .init(x: view.bounds.midX, y: 0.75 * view.bounds.height)

        yearlyButton.sizeToFit()
        yearlyButton.center = .init(x: view.bounds.midX, y: 0.25 * view.bounds.height)
    }

    @objc private func monthlyButtonPressed() {
        Ledger.purchaseProduct(withIdentifier: Constants.monthlySubscriptionIdentifier) { (error: Error?) in
            if let error = error {
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }

    @objc private func yearlyButtonPressed() {
        Ledger.purchaseProduct(withIdentifier: Constants.yearlySubscriptionIdentifier) { (error: Error?) in
            if let error = error {
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }

    private func checkSubscriptionStatus() {
        greetingLabel.text = "isSubscribed: \(Ledger.isAnySubscriptionActive())"
        view.setNeedsLayout()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkSubscriptionStatus()
        }
    }

    private func showAlert(withTitle title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
}
