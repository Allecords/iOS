//
//  MyPageViewController.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: - UI Components
    private let tableView: UITableView = .init(frame: .zero, style: .plain)
    private let navigationBar = AllecordsNavigationBar(leftItems: [.crawling, .allecords], rightItems: [.search, .bell])
    // MARK: - Properties
    private let data = ["알림", "서비스 이용약관", "오픈소스 라이센스", "로그아웃", "회원탈퇴"]
    // MARK: - Initializer
    
    // MARK: - MyPageView LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(self.tableView)
        tableView.dataSource = self
        
        setViewAttribute()
        setViewHierachies()
        setViewConstraints()
	}
}

// MARK: - UI Configure
private extension MyPageViewController {
    
    func setViewAttribute() {
        setTableView()
    }
    
    func setTableView() {
        tableView.backgroundColor = .background
        tableView.delegate = self
        tableView.separatorStyle = .none // 셀 사이의 구분선 없애기
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setViewHierachies() {
        
    }
    
    func setViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
                ])
    }
    
}

// MARK: - UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: .none)
        cell.textLabel?.text = data[indexPath.row]
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = "켜짐"
        }
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            let titleLabel = UILabel(frame: CGRect(x: 16, y: -4, width: tableView.bounds.width - 30, height: 30))
            titleLabel.text = "설정"
            titleLabel.textColor = .black
            titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
            headerView.addSubview(titleLabel)
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
}
