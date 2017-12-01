import UIKit
import QuartzCore

protocol LoginDelegate: class {
    func userHasLoggedIn()
}

class AccountViewController: UIViewController {
    
    var childVC : UIViewController?
    var goInitial = false
    @IBOutlet weak var currentStateView: UIView!
    @IBOutlet weak var backButton: UIButton!
    let userManager = UserManager()
    var loginDelegate: LoginDelegate?
    
    // TODO: Logic for Facebook login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childVC = InitialViewController()
        setView()
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.changeBackButtonImage), name: .changeImageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.changeToRegister), name: .registerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.changeToLogin), name: .loginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.dismissAccountViewController), name: .dismissViewNotification, object: nil)
        userManager.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func setView() {
        self.addChildViewController(childVC!)
        currentStateView.addSubview((childVC?.view)!)
        childVC?.didMove(toParentViewController: self)
    }
    
    func changeBackButtonImage() {
        // Change image in backButton
        backButton.imageView?.image = backButton.imageView?.image == UIImage(named: "left-arrow-2") ? UIImage(named: "letter-x") : UIImage(named: "left-arrow-2")
    }
    
    func changeToRegister() {
        goInitial = true
        currentStateView.subviews.forEach {$0.removeFromSuperview()}
        childVC = RegisterViewController()
        setView()
    }
    
    func changeToLogin() {
        goInitial = true
        currentStateView.subviews.forEach {$0.removeFromSuperview()}
        childVC = LoginViewController()
        setView()
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton) {
        goInitial == true ? goBack() : dismissAccountViewController()
    }
    
    func goBack() {
        goInitial = false
        currentStateView.subviews.forEach {$0.removeFromSuperview()}
        childVC = InitialViewController()
        setView()
    }
    
    func dismissAccountViewController() {
        /*
        if let currentUser = UserAuth.user {
            
            if currentUser.profile == "artist" {
                
            } else if currentUser.profile == "collector"{
                
            } else {
                print("not able to grab current users artist status")
            }
        }
        loginDelegate?.userHasLoggedIn()
 */
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorAlert(alertTitle:String, alertMsg:String) {
        let alertController = UIAlertController(title: alertTitle, message:
            alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AccountViewController: checkStatus {
    func errorRegistering() {
        self.errorAlert(alertTitle: "Error Creating Account", alertMsg: "There was an error creating your account. Please check if you have entered the correct credentials.")
    }
    
    func errorLoggingIn() {
        self.errorAlert(alertTitle: "Error Logging In", alertMsg: "Please check if you have entered the correct credentials.")
    }
}

extension Notification.Name {
    static let changeImageNotification = Notification.Name("changeImage")
    static let registerNotification = Notification.Name("register")
    static let loginNotification = Notification.Name("login")
    static let dismissViewNotification = Notification.Name("dismissAccountViewController")
}
