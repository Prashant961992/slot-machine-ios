//  Assignment 1 - Slot Machine
//
//  Harsh Mehta - 300951815
//  Shivam Shah - 300877523

import UIKit

class TropicanaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var images = [UIImage(named: "basketball"), UIImage(named: "baseball"), UIImage(named: "footmall"), UIImage(named: "seasonball"), UIImage(named: "tennisball"),UIImage(named: "baseball1"),UIImage(named: "stump"), UIImage(named: "hockeystick"), UIImage(named: "cricketstadium"), UIImage(named: "clothescricket"), UIImage(named: "basketballbaket"), UIImage(named: "crown"),UIImage(named: "winner")]
    let sportimages = [("basketball", 0.08), ("baseball", 0.08), ("footmall", 0.08), ("seasonball", 0.08), ("tennisball", 0.08),("baseball1",0.08),("stump", 0.08), ("hockeystick", 0.08), ("cricketstadium", 0.08), ("clothescricket", 0.08), ("basketballbaket", 0.08), ("crown", 0.08),("winner", 0.04)]
 
    // Get Odd Combination
    let odds = [0.1, 0.25, 0.65]
    
    //Define Maximum Range
    let maxRandomRange = 4294967296
    
    // Number Connection
    var beginningcount = 1000
    var jackpot = 100000
    var betM = 0
    
    // UILabel Connection
    @IBOutlet weak var jackPot: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var bet: UILabel!
    
    //UIbutton Connection
    @IBOutlet weak var btnSpin: UIButton!
    @IBOutlet weak var btnBet: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnQuit: UIButton!
    @IBOutlet weak var btnAddCash: UIButton!
    
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var picker3: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker1.selectRow(4, inComponent:0, animated:true)
        picker2.selectRow(4, inComponent:0, animated:true)
        picker3.selectRow(4, inComponent:0, animated:true)
        beginningcount = 0
        
        updateUI()
        
    }
    
    //Spin Action
    @IBAction func spin(_ sender: UIButton) {
        //get random Combination
        let selectedCombination = randomNumber()
        
        // Gameindexes Indexies for non repating count
        var indexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        switch selectedCombination {
        case 0:
            // 3 Position Is Same
            let gameIndex = getRandomFruitFaceIndex()
            picker1.selectRow(gameIndex, inComponent: 0, animated: true)
            picker2.selectRow(gameIndex, inComponent: 0, animated: true)
            picker3.selectRow(gameIndex, inComponent: 0, animated: true)
            
            //Winner
            if gameIndex == 12 {
                beginningcount += jackpot
                jackpot = 10000
            }
            else {
                beginningcount += betM * 10
            }
            
            let alert = UIAlertController(title: "Winner", message: "You Won the Games", preferredStyle: .alert)
            
            let printSomething = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { _ in
                print("We can run a block of code." )
            }
            
            alert.addAction(printSomething)
            
            self.present(alert, animated: true, completion: nil)
            
        case 1:
            
            //2 Position Is Same
            let position = Int(arc4random_uniform(3))
            var gameIndex = getRandomFruitFaceIndex()
            switch position {
            case 0: //Position: ITEM ANY
                picker1.selectRow(gameIndex, inComponent: 0, animated: true)
                picker2.selectRow(gameIndex, inComponent: 0, animated: true)
                
                indexes.remove(at: indexes.index(of: gameIndex)!)
                
                gameIndex = getRandomNonRepeatingGamesIndex(indexies: indexes)
                picker3.selectRow(gameIndex, inComponent: 0, animated: true)
            case 1: //Position Item ANY Item
                picker1.selectRow(gameIndex, inComponent: 0, animated: true)
                picker3.selectRow(gameIndex, inComponent: 0, animated: true)
                
                indexes.remove(at: indexes.index(of: gameIndex)!)
                
                gameIndex = getRandomNonRepeatingGamesIndex(indexies: indexes)
                picker2.selectRow(gameIndex, inComponent: 0, animated: true)
            case 2:
                
                //Position any
                picker2.selectRow(gameIndex, inComponent: 0, animated: true)
                picker3.selectRow(gameIndex, inComponent: 0, animated: true)
                
                indexes.remove(at: indexes.index(of: gameIndex)!)
                
                gameIndex = getRandomNonRepeatingGamesIndex(indexies: indexes)
                picker1.selectRow(gameIndex, inComponent: 0, animated: true)
            default: break
            }
            
            //Winner
            beginningcount += betM
        case 2:
            // 3 of Any
            
            //reel 1
            var gameIndex = getRandomFruitFaceIndex()
            picker1.selectRow(gameIndex, inComponent: 0, animated: true)
            indexes.remove(at: indexes.index(of: gameIndex)!)
            //reel 2
            gameIndex = getRandomNonRepeatingGamesIndex(indexies: indexes)
            picker2.selectRow(gameIndex, inComponent: 0, animated: true)
            indexes.remove(at: indexes.index(of: gameIndex)!)
            //reel 3
            gameIndex = getRandomNonRepeatingGamesIndex(indexies: indexes)
            picker3.selectRow(gameIndex, inComponent: 0, animated: true)
            
            //Increse Count if player loses
            jackpot += betM * 2
            
        default:
            break
        }
        
        //update Games
        updateUI()
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UIImageView(image: images[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return ((images[0]?.size.height)! + 15)
    }
    
    //Update Data Reset Count
    func updateUI() {
        jackPot.text = String (jackpot)
        wallet.text = String (beginningcount)
        betM = 0
        bet.text = String (betM)
        btnSpin.isEnabled = false
        btnBet.isEnabled = true //beginningcount < 5 ? false : true
    }
    
    //get RandomNumber
    func getRandomNumber() -> Int {
        let randomNumber = arc4random()
        
        return Int(randomNumber)
    }
    
    //Randomly select combination for the reel using given odds
    func randomNumber() -> Int{
        let randomNumber = getRandomNumber()
        var cWeight:Double  = 0
        
        for (i, odd) in odds.enumerated() {
            cWeight += odd
            if ( randomNumber < Int(cWeight * Double(maxRandomRange)) ) {
                return i
            }
        }
        
        return -1
    }
    
    //select Index randomely
    func getRandomFruitFaceIndex() -> Int {
        let randomNumber = getRandomNumber()
        var cWeight:Double = 0
        
        for (i, element) in sportimages.enumerated() {
            cWeight += element.1
            if (randomNumber < Int(cWeight * Double(maxRandomRange))) {
                return i
            }
        }
        
        return -1
    }
    
    //Generate Non Reapitng Fruit sportimages Index from avaliable collection of indexes
    func getRandomNonRepeatingGamesIndex(indexies: [Int]) -> Int {
        var randomIndex = -1
        
        repeat {
            randomIndex = getRandomFruitFaceIndex()
        } while (!indexies.contains(randomIndex))
        
        return randomIndex
    }
    
    //increasing
    @IBAction func bet(_ sender: UIButton) {
        betM = 5
        beginningcount = 5
        btnSpin.isEnabled = true
        btnBet.isEnabled = true
        
        wallet.text = String (beginningcount)
        bet.text = String (betM)
    }
    
    @IBAction func bet10(_ sender: UIButton) {
        betM = 10
        beginningcount = 10
        btnSpin.isEnabled = true
        btnBet.isEnabled = true
        wallet.text = String (beginningcount)
        bet.text = String (betM)
    }
    
    @IBAction func bet20(_ sender: UIButton) {
        betM = 20
        beginningcount = 20
        btnSpin.isEnabled = true
        btnBet.isEnabled = true
        wallet.text = String (beginningcount)
        bet.text = String (betM)
    }
    
    @IBAction func bet50(_ sender: UIButton) {
        betM = 50
        beginningcount = 50
        btnSpin.isEnabled = true
        btnBet.isEnabled = true
        wallet.text = String (beginningcount)
        bet.text = String (betM)
    }
    
    @IBAction func bet100(_ sender: UIButton) {
        betM = 100
        beginningcount = 100
        btnSpin.isEnabled = true
        btnBet.isEnabled = true
        wallet.text = String (beginningcount)
        bet.text = String (betM)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        // Reset Count
        beginningcount = 0
        jackpot = 100000
        updateUI()
    }
    
    @IBAction func quit(_ sender: UIButton) {
        // App ShutDown
        exit(0)
    }
    
}
