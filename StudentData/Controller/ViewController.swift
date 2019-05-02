import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

struct Question{
    var char1 = ""
    var char2 = ""
    var question = ""
    var season = 0
    var correct_answer = false
}

class ViewController: UIViewController {
    
    var season1:[String: Float] = ["Jon Snow": 54.75,"Tyrion Lannister": 52.75,"Daenerys Targaryen": 54,"Sansa Stark": 24,"Cersei Lannister": 28,"Arya Stark": 33.5,"Jaime Lannister": 21]

    var listQuestions = [Question]()
    var tempQuestionsList = [Question]()
    var usedQuestions = [Question]()
    var arrayKeys = [String]()
    var arrayValues = [Float]()
    
    func generateQuestions() -> Void{
        arrayKeys = [String](season1.keys)
        arrayValues = [Float](season1.values)
        
        for i in 0..<arrayValues.count-1{
            for y in i+1..<arrayValues.count{
                if (arrayValues[i] < arrayValues[y])
                {
                    listQuestions.append(Question(char1: arrayKeys[i], char2: arrayKeys[y], question: String(arrayKeys[i])+" was screened longer than "+String(arrayKeys[y])+" in season 1", season: 1,correct_answer: true))
                    listQuestions.append(Question(char1: arrayKeys[i], char2: arrayKeys[y], question: String(arrayKeys[i])+" was not screened longer than "+String(arrayKeys[y])+" in season 1", season: 1,correct_answer: false))
                }
                else{
                    listQuestions.append(Question(char1: arrayKeys[i], char2: arrayKeys[y], question: String(arrayKeys[i])+" was screened longer than "+String(arrayKeys[y])+" in season 1", season: 1,correct_answer: false))
                    listQuestions.append(Question(char1: arrayKeys[i], char2: arrayKeys[y], question: String(arrayKeys[i])+" was not screened longer than "+String(arrayKeys[y])+" in season 1", season: 1,correct_answer: true))
                }
            }
        }
    }

    func randomDisplayQuestions() -> Void{
        tempQuestionsList = listQuestions
        var count = 0
        repeat{
            let randomNumber = Int.random(in: 0 ..< tempQuestionsList.count)
            usedQuestions.append(tempQuestionsList[randomNumber])
            tempQuestionsList.remove(at: randomNumber)
            count = count+1
            
            for i in 0..<usedQuestions.count-1{
                for y in i+1..<usedQuestions.count{
                    if((tempQuestionsList[i].char1 == tempQuestionsList[y].char1 && tempQuestionsList[i].char2 == tempQuestionsList[y].char2||tempQuestionsList[i].char1 == tempQuestionsList[y].char2 && tempQuestionsList[i].char2 == tempQuestionsList[y].char1)){
                        usedQuestions.remove(at: y)
                        count = count-1

                        break

                    }
                }
            }
       }
            while (count < 5)
    }


    @IBOutlet weak var tableView: UITableView!
    
    let cellid = "CellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        generateQuestions()
        randomDisplayQuestions()
        print(listQuestions.count)
        tableView.delegate = self
        tableView.dataSource = self
        
        }
    
    override func viewWillAppear(_ animate: Bool){
        generateQuestions()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedQuestions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! TableViewCell
        let question = usedQuestions[indexPath.row]
        cell.QuestionContent.text = question.question
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

