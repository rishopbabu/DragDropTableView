//
//  ViewController.swift
//  DragDropTableView
//
//  Created by MAC-OBS-26 on 16/05/22.
//

import UIKit

class Sections {
    var sectionHeading: String?
    var sectionList: [String]?
    
    init(sectionHeading: String, sectionList: [String]) {
        self.sectionHeading = sectionHeading
        self.sectionList = sectionList
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDropDelegate, UITableViewDragDelegate {

    //MARK: - Properties
    private weak var dragdropTableView: UITableView!
    
    var sections = [Sections]()
    public var numbers1 = ["one","two","three","four","five"]
    public var numbers2 = ["six","seven","eight","nine","ten"]
//    public var numbers3 = ["eleven","twelve","thirteen","fourteen","fifteen"]
//    public var numbers4 = ["sixteen","seventeen","eighteen","nineteen","twenty"]
//    public var numbers5 = ["twentyone","twentytwo","twentythree","twentyfour","twentyfive"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections.append(Sections.init(sectionHeading: "LIVE 1", sectionList: numbers1))
        sections.append(Sections.init(sectionHeading: "LIVE 2", sectionList: numbers2))
//        sections.append(Sections.init(sectionTag: 3, sectionHeading: "LIVE 3", sectionList: numbers3))
//        sections.append(Sections.init(sectionTag: 4, sectionHeading: "LIVE 4", sectionList: numbers4))
//        sections.append(Sections.init(sectionTag: 5, sectionHeading: "LIVE 5", sectionList: numbers5))
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dragdropTableView.frame = view.bounds
    }
    
    //MARK: - Private Functions and SetUpConstraints
    
    private func setupTableView() -> UITableView {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        return tableView
    }
    
    private func setupViews() {
        let dragdropTableViewItem = setupTableView()
        dragdropTableViewItem.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        dragdropTableViewItem.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.dragdropTableView = dragdropTableViewItem
        view.addSubview(dragdropTableViewItem)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            dragdropTableView.topAnchor.constraint(equalTo: view.topAnchor),
            dragdropTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            dragdropTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 100.0),
            dragdropTableView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    

    //MARK: - TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //debugPrint(sections[0].sectionList?[0])
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.label1.text = sections[indexPath.section].sectionList?[indexPath.row]
        cell.label1.textColor = .black
        cell.userInteractionEnabledWhileDragging = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionHeading
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = .red
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        label.text = sections[section].sectionHeading
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    //MARK: - UITableViewDragDelegate
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let totRow = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == 0 || indexPath.row == totRow - 1 {
            return [UIDragItem]()
        }
        
        var str = String()
        str = (sections[indexPath.section].sectionList?[indexPath.row])!
        let provider = NSItemProvider(object: str as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: provider)
        debugPrint("Dragged...")
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return previewParameters(forItemAt: indexPath, tableView: tableView)
    }
    
    private func previewParameters(forItemAt indexPath: IndexPath, tableView: UITableView) -> UIDragPreviewParameters? {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: cell.frame)
        return previewParameters
    }
    
    //MARK: - UITableViewDropDelegate
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //moves the selected cell to the destination
        let moved = sections[sourceIndexPath.section].sectionList!.remove(at: sourceIndexPath.row)
        sections[destinationIndexPath.section].sectionList!.insert(moved, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        let totRow = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == 0 || indexPath.row == totRow - 1 {
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        
        if session.localDragSession != nil {
            if destinationIndexPath?.row == 0 {
                return UITableViewDropProposal(operation: .forbidden)
            }
        }
        
        if tableView.hasActiveDrag {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .forbidden)
    }
}
