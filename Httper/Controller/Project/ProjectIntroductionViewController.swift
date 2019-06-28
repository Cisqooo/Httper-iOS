//
//  ProjectIntroductionViewController.swift
//  Httper
//
//  Created by Meng Li on 17/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit

class ProjectIntroductionViewController: BaseViewController<ProjectIntroductionViewModel> {

    private lazy var introductionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.becomeFirstResponder()
        return textView
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.save()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        navigationItem.rightBarButtonItem = saveBarButtonItem
        view.addSubview(introductionTextView)
        createConstraints()
        
        viewModel.title ~> rx.title ~ disposeBag
        viewModel.isValidate ~> saveBarButtonItem.rx.isEnabled ~ disposeBag
        viewModel.introduction <~> introductionTextView.rx.text ~ disposeBag
    }
    
    private func createConstraints() {
        introductionTextView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeArea.top)
        }
    }

}