//
//  MainView.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import UIKit
import CRRefresh

protocol SongItemInterface: SongViewCellInterface {}

protocol MainViewDelegate: AnyObject {
    // Tabel
    func MainView(_ view: MainView, _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func RefreshLoad()
}

protocol MainViewDataSource: AnyObject {
    // Tabel
    func MainView(_ tableView: UITableView, view: MainView, numberOfRowsInSection section: Int) -> Int
    func MainView(_ view: MainView, cellForRowAt indexPath: IndexPath) -> SongItemInterface
}

class MainView: UIView {
    
    @IBOutlet weak var tblListSongs: UITableView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var vwNoListSongs: UIView!
    @IBOutlet weak var scrlView: UIScrollView!
    
    weak var delegate: MainViewDelegate?
    weak var dataSource: MainViewDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func reloadTableData() {
        tblListSongs.reloadData()
    }
    
    func refreshStop() {
        tblListSongs.cr.endHeaderRefresh()
        scrlView.cr.endHeaderRefresh()
    }
    
    func refreshStart() {
        tblListSongs.cr.beginHeaderRefresh()
    }
}

extension MainView {
    private func setupLayout() {
        setupLayoutConstraint()
        registerCell()
        registerListener()
        
        tblListSongs.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.actionRefreshListener()
        }
        
        scrlView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.actionRefreshListener()
        }
    }
    
    private func setupLayoutConstraint() {
        self.layoutIfNeeded()
    }
    
    private func registerCell() {
        // Tabel
        let songViewCell = UINib(nibName: "SongViewCell", bundle: nil)
        tblListSongs.register(songViewCell, forCellReuseIdentifier: "SongViewCell")
        tblListSongs.delegate = self
        tblListSongs.dataSource = self
        tblListSongs.separatorInset = .zero
        tblListSongs.directionalLayoutMargins = .zero
        tblListSongs.layoutMargins = .zero
    }
    
    private func registerListener() {
        //btn.addTarget(self, action: #selector(actionUpdateListener(_:)), for: .touchUpInside)
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.MainView(self, tableView, didSelectRowAt: indexPath)
    }
    
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.MainView(tableView, view: self, numberOfRowsInSection: section) ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongViewCell", for: indexPath) as? SongViewCell
        else { return UITableViewCell() }
        
        cell.interface = dataSource?.MainView(self, cellForRowAt: indexPath)
        return cell
    }
}

extension MainView {
    @objc private func actionRefreshListener() {
        delegate?.RefreshLoad()
    }
}
