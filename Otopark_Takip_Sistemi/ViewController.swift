//
//  ViewController.swift
//  Otopark_Takip_Sistemi
//
//  Created by Ibrahim Gok on 26.01.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var otoparkAraButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    
    var provincePickerView = UIPickerView()
    
    var Provinces = ["İzmir","Manisa","İstanbul"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provincePickerView.delegate = self
        provincePickerView.dataSource = self
        
        textField.inputView = provincePickerView
        textField.placeholder = "Hangi İlde Bulunuyorsunuz?"
        textField.textAlignment = .center
        
        otoparkAraButton.isEnabled = false
        
    }
    
    @objc func selectProvince() {
        textField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Provinces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Provinces[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectProvince))
        textField.text = Provinces[row]
        view.addGestureRecognizer(gestureRecognizer)
        
        if textField.text != "" {
            otoparkAraButton.isEnabled = true
        }
    }
    
    
    @IBAction func otoparkAraButtonTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "toMapVC", sender: nil)
        
    }
    
        
        
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let destinationVC = segue.destination as! parkMap
            destinationVC.chosenProvince = textField.text!
        }
    }
}

