import UIKit

class User {
    
    var _image: UIImage?;
    
    func displayName() -> String {
        return("Kendrick T.");
    }
    
    func image() -> UIImage! {
        if(_image != nil){ return _image! }
        
        if let image = imageFromUrl(mockImageUrl()) {
            _image = image;
            return(image);
        }
        else {
            return(nil)
        }
    }
    
    private func imageFromUrl(imageUrl: String) -> UIImage! {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        var image: UIImage?
        dispatch_sync(queue, { () -> Void in
            let url = NSURL(string: imageUrl)
            var urlRequest = NSURLRequest(URL: url!)
            var response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var downloadError: NSError?
            
            let imageData:NSData = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: &downloadError)!
            
            if let error = downloadError {
                println("Error happened = \(error)")
            }
            else {
                if imageData.length > 0 {
                    image = UIImage(data: imageData)
                }
                else {
                    println("No data could get donwloaded from the URL")
                }
            }
        })
    
        if let theImage = image {
            return (theImage)
        }
        else {
            return nil
        }
    }
        
    func facebookImageUrl(fbUserId: String) -> String {
        return("https://graph.facebook.com/v2.2/\(fbUserId)/picture?type=large");
    }
    
    func mockImageUrl() -> String {
        return(facebookImageUrl("7813645"));
    }
}

class Notification {
    
    func user() -> User {
        return(User());
    }
    
    var _type = "";
    var _action = "";
    var _body = "";
    
    init(type: String, action: String, body: String){
        _type = type;
        _action = action;
        _body = body;
    }
    
    func type() -> String { return(_type); }
    func action() -> String { return(_action); }
    func body() -> String { return(_body); }
}

let NotificationManager = NotificationManagerClass();

class NotificationManagerClass {
    
    var mockNotifications = [
        Notification(type: "comment", action: "commented on your post", body: ""),
        Notification(type: "post", action: "posted a thing", body: ""),
        Notification(type: "message", action: "", body: "I need your help!"),
        Notification(type: "message", action: "", body: "Tofu post-ironic chia direct trade health goth Portland next level, typewriter lo-fi Helvetica gentrify Carles. Austin Bushwick roof party, health goth crucifix viral tofu cred meggings Pitchfork hashtag. Quinoa Marfa 3 wolf moon four loko pug, Odd Future bespoke chambray Pinterest ethical authentic kogi raw denim. Next level migas cray, Godard viral meditation scenester ennui listicle Vice. Bitters ennui DIY, Bushwick asymmetrical cred slow-carb Banksy Thundercats kitsch Tumblr seitan.")
    ]
    
    func numberOfNotifications()->Int{ return(mockNotifications.count); }
    func notification(index: Int)->Notification{ return(mockNotifications[index]); }
}

let HabitManager = HabitManagerClass();

let why = "Writing down what you eat makes you more aware of what you’re actually eating. It’s a lot easier to get from Point A to Point B when you know where the heck Point A is.";
let scale = "You can try every day, 5 days a week, every weekday, etc. You can also chnge how much you write down. “Tacos for lunch” is still more information than nothing. You can also simply take a picture of what you eat.";
let piggyback = "You can piggyback off meals. As soon as you are ready to eat, take a picture. Or as soon as you are done, jot it down.";

class HabitManagerClass {

    var _mockHabits = [
        Habit(description: "I will write down nothing!", compliance: 0.99, whyDescription: why, scaleDescription: scale, piggybackDescription: piggyback),
        Habit(description: "I will eat more slowly", compliance: 0.50, whyDescription: why, scaleDescription: scale, piggybackDescription: piggyback),
        Habit(description: "I will eat vegetables at every meal", compliance: 0.99, whyDescription: why, scaleDescription: scale, piggybackDescription: piggyback),
        Habit(description: "I will eat protein at every meal", compliance: 0.23, whyDescription: why, scaleDescription: scale, piggybackDescription: piggyback),
        Habit(description: "Tofu post-ironic chia direct trade health goth Portland next level, typewriter lo-fi Helvetica gentrify Carles. Austin Bushwick roof party, health goth crucifix viral tofu cred meggings Pitchfork hashtag. Quinoa Marfa 3 wolf moon four loko pug, Odd Future bespoke chambray Pinterest ethical authentic kogi raw denim. Next level migas cray, Godard viral meditation scenester ennui listicle Vice. Bitters ennui DIY, Bushwick asymmetrical cred slow-carb Banksy Thundercats kitsch Tumblr seitan.", compliance: 0.75, whyDescription: why, scaleDescription: scale, piggybackDescription: piggyback)
//        Habit(description: "I will drink a glass of water before every meal", compliance: 0.75, whyDescription: why, scaleDescription: scale, piggybackDescription: piggyback)
    ];


    func get() -> [Habit] { return(_mockHabits); }

    func current() -> Habit { return(_mockHabits[0]); }

}

class Habit {

    var _compliance = 0.0;
    var _description = "";
    var _whyDescription = "";
    var _scaleDescription = "";
    var _piggybackDescription = "";

    init(description: String, compliance: Double, whyDescription: String, scaleDescription: String, piggybackDescription: String){
        _description = description;
        _compliance = compliance;
        _whyDescription = whyDescription;
        _scaleDescription = scaleDescription;
        _piggybackDescription = piggybackDescription;
    }

    func description() -> String { return(_description); }
    func compliance() -> Double { return(_compliance); }
    func numberOfDaysCompliant() -> Int { return(3); }
    func numberOfDays() -> Int { return(5); }
    func whyDescription() -> String { return(_whyDescription); }
    func scaleDescription() -> String { return(_scaleDescription); }
    func piggybackDescription() -> String { return(_piggybackDescription); }
}
