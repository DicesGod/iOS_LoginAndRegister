import UIKit
import CoreData

enum cases{
    case success
    case incorrectPassword
    case notRegistered
    case duplicatedEmail
}

class LoginandRegisterViewController: UIViewController {
    
    var studentsList = [Student]()
    var check = 0
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudents()
        loadSession()
         if(emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false){
        check = findStudent()
        login()
        }
    }
    
    @IBAction func SaveStudent(_ sender: UIButton) {
        storeStudent{
            (done) in
            if done{
                navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                //Try to save again using new data
            }
        }
        
    }

    @IBAction func Login(_ sender: UIButton) {
       saveSession()
       login()
    }
}

extension LoginandRegisterViewController{
    func storeStudent(completion: (_ done:Bool) ->()) {
        let check = findStudent()
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        if (passwordTextField.text == confirmPasswordTextField.text && (check == cases.notRegistered.hashValue || check == 0) && emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false)
        {
           
            let student =  Student(context: managedContext)
            student.username = emailTextField.text
            student.password = passwordTextField.text
            student.score = 0
            do{
                try managedContext.save()
                Toast.show(message:"Your email has been registered!",controller: self)
                completion(true)
                confirmPasswordLabel.isHidden = true
                confirmPasswordTextField.isHidden = true
                Register.isEnabled = false
                Login.isEnabled = true
                self.performSegue(withIdentifier: "mainpage", sender: self)
                saveSession()
            } catch{
                print("Failed to save student: ", error.localizedDescription)
                completion(false)
            }
        }
        else if (check == cases.duplicatedEmail.hashValue || check == cases.success.hashValue || check == cases.incorrectPassword.hashValue)
        {
            Toast.show(message:"Duplicated email! Please try again with another email!",controller: self)
        }
        else if (passwordTextField.text != confirmPasswordTextField.text && check == cases.notRegistered.hashValue){
            Toast.show(message:"Your password and confirm password are not matched!",controller: self)
        }
        else if (emailTextField.text!.isEmpty || (passwordTextField.text?.isEmpty)!)
        {
            Toast.show(message:"No field should be null!",controller: self)
        }
    }
}

//get students from core data
extension LoginandRegisterViewController{
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
    
    func  fetchStudents(){
        fetchStudents{
            (done) in
            if done{
                if studentsList.count > 0 {
                    print("Data loaded! xD")
                }
            } else{
                print("Failed to load data! xD")
            }
        }
    }
}

//find student in the loaded list
extension LoginandRegisterViewController{
    func findStudent() -> Int{
        var result = 0
        for loginstudent in studentsList
        {
            if (emailTextField.text == loginstudent.username && passwordTextField.text == loginstudent.password){
                result = cases.success.hashValue
                break
            }
            else if (emailTextField.text == loginstudent.username && passwordTextField.text != loginstudent.password)
            {
                result = cases.incorrectPassword.hashValue
                break
            
            }
                
            else if (emailTextField.text == loginstudent.username && passwordTextField.text != confirmPasswordTextField.text)
            {
                result = cases.duplicatedEmail.hashValue
                break
            }
                
            else{
                result = cases.notRegistered.hashValue
            }
        }
         return result
        
    }
}

//save stave
extension LoginandRegisterViewController{
    func saveSession(){
        UserDefaults.standard.set(emailTextField.text, forKey: "username")
        UserDefaults.standard.set(passwordTextField.text, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    func loadSession(){
        if (UserDefaults.standard.string(forKey: "username") != "") {
            emailTextField.text = UserDefaults.standard.string(forKey: "username")
            passwordTextField.text = UserDefaults.standard.string(forKey: "password")
        }
        else{
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    func login(){
        check = findStudent()
        if (check == cases.success.hashValue){
            self.performSegue(withIdentifier: "mainpage", sender: self)
            saveSession()
        }
        else if(check == cases.incorrectPassword.hashValue){
            Toast.show(message:"Your password is not correct! Please try again",controller: self)
        }
        else{
            Toast.show(message:"Your email has not been registered! Please register!",controller: self)
            Register.isEnabled = true
            confirmPasswordLabel.isHidden = false
            confirmPasswordTextField.isHidden = false
            Toast.show(message:"Your email has not been registered! Please register!",controller: self)
            Login.isEnabled = false
        }
    }
}
