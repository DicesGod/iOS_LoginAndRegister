import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate


class ViewController: UIViewController {
    
    var studentsList = [Student]()
    
    @IBOutlet weak var tableView: UITableView!
    let cellid = "CellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        
        }
    
    func  fetchStudents(){
        fetchStudents{
        (done) in
        if done{
            if studentsList.count > 0 {
                print("Data loaded! xD")
                tableView.isHidden = false
            }
        } else{
            tableView.isHidden = true
        }
        }
    }
    
    override func viewWillAppear(_ animate: Bool){
        fetchStudents()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! TableViewCell
        let student = studentsList[indexPath.row]
        cell.studentName.text = (student.name ?? "N/A")+"\n"+(student.email ?? "N/A")
//        if student.firstName == student.lastName{
//            cell.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//            cell.studentName.textAlignment = .center
//            cell.studentName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title:"Remove"){
            (action, indexPath) in
            self.removeStudent(indexPath: indexPath)
            self.fetchStudents()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let updateAction = UITableViewRowAction(style: .normal, title: "Upper"){
            (action, indexPath) in
            self.updateStudent(indexPath: indexPath)
            self.fetchStudents()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        removeAction.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        updateAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return [removeAction, updateAction]
    }
}

extension ViewController{
    func fetchStudents(completion: (_ done: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        //managedContext.fetch(request)
        do{
            studentsList = try managedContext.fetch(request) as! [Student]
            completion(true)
        }catch{
            print("Failed to fetech sutdent: ", error.localizedDescription)
            completion(false)
        }
    }
    
    func removeStudent(indexPath: IndexPath)  {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(studentsList[indexPath.row])
        do{
            try managedContext.save()
        }catch{
            print("Failed to remove student", error.localizedDescription)
        }
    }
    
    func updateStudent(indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let student = studentsList[indexPath.row]
        //student.lastName = student.lastName?.localizedUppercase
        do{
            try managedContext.save()
        }catch{
            print("Failed to update student:", error.localizedDescription)
        }
    }
}
