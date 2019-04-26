//
//  ViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class ExpenditureViewController: UIViewController{
    
    @IBOutlet weak var ExpenditureTableView: UITableView!
    
    //  儲存輸入支出的錢
    var allExpenditureArray = [Expenditure]()
    var currentDateExpenditureArray = [Expenditure]()
    var typeArray = ["食", "衣", "住", "行", "育", "樂"]
    var typeDetailDic = ["食" : ["早餐", "午餐", "下午茶", "晚餐", "零食", "其他"],
                         "衣" : ["服飾", "鞋子", "其他"],
                         "住" : ["房租", "水費", "電費", "其他"],
                         "行" : ["交通費", "其他"],
                         "育" : ["教育", "其他"],
                         "樂" : ["旅遊", "看電影", "其他"]]
    var selectType = ""
    var selectTypeDetail = ""
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var currentSelectDate = Date()
    var currentSelectDateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDate()
        selectType = typeArray[0]
        if let chooseType = typeDetailDic[selectType]{
            selectTypeDetail = chooseType[0]
        }
    }
    
    func getDate(){
        
        //  顯示 datePicker 方式和大小
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "zh_TW")
        datePicker.locale = Locale(identifier: "zh_TW")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        navigationItem.title = dateFormatter.string(from: datePicker.date)
    }
    
    //  左上角按鈕選擇日期
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        //  建立警告控制器顯示 datePicker
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            self.currentDateExpenditureArray = [Expenditure]()
            // 按下確定，讓標題改成選取到的日期
            self.currentSelectDateText = self.dateFormatter.string(from: self.datePicker.date)
            self.navigationItem.title = self.currentSelectDateText
            self.currentSelectDate = self.datePicker.date
            
            for expenditure in self.allExpenditureArray{
                if self.currentSelectDateText == expenditure.date{
                    self.currentDateExpenditureArray.append(expenditure)
                }
            }
            self.ExpenditureTableView.reloadData()
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        
        self.present(dateAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editExpenditureSegue"{
            if let indexPath = ExpenditureTableView.indexPathForSelectedRow{
                let editExpenditureVC = segue.destination as? EditExpenditureViewController
                editExpenditureVC?.money = currentDateExpenditureArray[indexPath.row].money
                editExpenditureVC?.type = currentDateExpenditureArray[indexPath.row].type
                editExpenditureVC?.typeDetail = currentDateExpenditureArray[indexPath.row].typeDetail
                editExpenditureVC?.dateText = currentDateExpenditureArray[indexPath.row].date
                editExpenditureVC?.index = indexPath
                print(currentDateExpenditureArray[indexPath.row].date)
                
                editExpenditureVC?.setupEditType()
                editExpenditureVC?.typeDropDownMenu.menuText = currentDateExpenditureArray[indexPath.row].type
                editExpenditureVC?.setupEditTypeDetail()
                editExpenditureVC?.typeDetailDropDownMenu.menuText = currentDateExpenditureArray[indexPath.row].typeDetail
                
                editExpenditureVC?.moneyTextfield.text = String(currentDateExpenditureArray[indexPath.row].money)
            }
        }
        else if segue.identifier == "addExpenditureSegue"{
            let AddExpenditureVC = segue.destination as? AddExpenditureViewController
            
            currentSelectDateText = dateFormatter.string(from: currentSelectDate)
            AddExpenditureVC?.dateText = currentSelectDateText
            AddExpenditureVC?.setupTypeInit()
        }
        
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
        
    }
}

//  tableView
extension ExpenditureViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - Tableview Datasource Methods
    //  tableView 的列數等於 moneyArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDateExpenditureArray.count
    }
    //  重複使用列數
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ExpenditureTableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        
        let expenditure = currentDateExpenditureArray[indexPath.row]
        cell.imageView?.image = UIImage(named: "\(expenditure.type)")
        cell.textLabel?.text = "\t類型：\(expenditure.type)"
        cell.detailTextLabel?.text = "\(expenditure.typeDetail) $\(expenditure.money)"
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ExpenditureTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //  在 tableView 上往左滑可以刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            currentDateExpenditureArray.remove(at: indexPath.row)
            ExpenditureTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}