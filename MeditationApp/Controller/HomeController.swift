//
//  HomeController.swift
//  MeditationApp
//
//  Created by Hardik on 11/01/22.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblView.register(UINib(nibName: String(describing: ViewAllSectionHeaderView.self), bundle: Bundle.main),
                                forHeaderFooterViewReuseIdentifier: String(describing: ViewAllSectionHeaderView.self))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension HomeController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HomeCell {
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ViewAllSectionHeaderView.self)) as? ViewAllSectionHeaderView ?? ViewAllSectionHeaderView()
        switch section {
        case 0:
            sectionHeaderView.configure(title: "Popular")
        case 1:
            sectionHeaderView.configure(title: "New")
        default:
            sectionHeaderView.configure(title: "")
        }
        sectionHeaderView.btnViewAll.tag = section
        sectionHeaderView.btnViewAll.addTarget(self, action: #selector(headerTapped(button:)), for: .touchUpInside)
        return sectionHeaderView
                
    }
    
    @objc func headerTapped(button: UIButton) {
        switch button.tag {
        case 0:
            navigateToSeeAll(title: "Popular")
        default:
            break
        }
        
    }
    
    func navigateToSeeAll(title: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LisitingViewController") as? LisitingViewController {
            nextViewController.navtitle = title
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
    }
}

class HomeCell: UITableViewCell {
    
    
    @IBOutlet weak var clVIew: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clVIew.dataSource = self
        clVIew.delegate = self
        clVIew.collectionViewLayout = AdAudioMaterialFlowLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

extension HomeCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as? UICollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 293, height: 150)
    }
}

final class AdAudioMaterialFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.sectionInset = UIEdgeInsets(top: 5.0, left: 24.0, bottom: 24.0, right: 24.0)
        self.itemSize = CGSize(width: UIScreen.main.bounds.width/2.0 - 40, height: UIScreen.main.bounds.width/2.0 + 20)
        self.minimumInteritemSpacing = 20.0
        self.minimumLineSpacing = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ViewAllSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func configure(title: String?) {
        sectionTitleLabel.text = title
    }
}
