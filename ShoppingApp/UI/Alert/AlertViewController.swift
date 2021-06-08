//
//  AlertViewController.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/14/21.
//

import UIKit

class AlertViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var actionStackView: UIStackView!
    
    @IBOutlet weak var mainBackgroundView: UIView!
    
    @IBOutlet weak var dimmerView: UIView!
    
    
    private let titleText: String?
    
    private let message: String?
    
    var actions = [(button: UIButton, closure: () -> Void)]()
    
    var hasBeenPresented = false
    
    init(title: String? = nil, message: String? = nil) {
        self.titleText = title
        self.message = message
        super.init(nibName: "AlertViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.titleText
        self.messageLabel.text = message
        
        self.titleLabel.font = UIConstants.standardFont(size: 17, style: .semiBold)
        self.messageLabel.font = UIConstants.standardFont(size: 17, style: .regular)
        
        self.mainBackgroundView.layer.cornerRadius = 12
        
        if self.titleText == nil {
            self.titleLabel.removeFromSuperview()
        }
        
        if self.message == nil {
            self.messageLabel.removeFromSuperview()
        }
        
        for action in self.actions {
            self.actionStackView.addArrangedSubview(action.button)
        }
        
        self.actionStackView.spacing = 6
        self.view.alpha = 0
        self.mainBackgroundView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.hasBeenPresented {
            self.hasBeenPresented = true
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.view.alpha = 1
                self.mainBackgroundView.transform = .identity
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.mainBackgroundView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.mainBackgroundView.alpha = 0
        })
    }

    func addAction(title: String, handler: @escaping () -> Void) {
        let button = UIButton(type: .system)
        button.styleAsRoundButton()
        button.setTitle(title, for: .normal)
        self.actions += [(button, handler)]
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if self.actionStackView?.arrangedSubviews.contains(button) == false {
            self.actionStackView?.addArrangedSubview(button)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.actions.first(where: {$0.button == sender})?.closure()
    }
}
