import Foundation
import UIKit
import WCApi

class AudiosTableViewController: UITableViewController, GetMultimediaHandlerProtocol {
    
    var multimedia: [MultimediaModel] = [MultimediaModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getMultimedia = GetMultimedia(handler: self)
        let user: UserModel = UserModel(username: "Thalie_Envolée")
        getMultimedia.get(user)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.multimedia.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("audio", forIndexPath: indexPath)
        
        let video = self.multimedia[indexPath.row] as MultimediaModel
        cell.textLabel?.text = video.name
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AudiosTableViewController{
    
    func setMultimedia(multimedia: [MultimediaModel]){
        
        self.multimedia = multimedia.filter(){
            if $0.mediaType == MultimediaModel.MediaTypes.audio {
                return true
            } else {
                return false
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    func getMultimediaError(error: GetMultimediaErrorFatal){
        let errorAlert = UIAlertView(title: "Error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
}
