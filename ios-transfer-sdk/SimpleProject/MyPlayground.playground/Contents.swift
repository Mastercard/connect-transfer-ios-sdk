import UIKit

var greeting = "Hello, playground"

extension String {
  var isValidUrl: Bool {
    if let url = NSURL(string: self) {
      return UIApplication.shared.canOpenURL(url as URL)
    }
    return false
  }
}

let test1 = "partnerapp://"
let isValidUrl = test1.isValidUrl

print(isValidUrl)


let test2 = "https://www.google.com/"
let isValidUrl2 = test2.isValidUrl
print(isValidUrl2)


extension String {

    var canOpenURL : Bool {

        guard let url = NSURL(string: self) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
}


let test3 = "partnerapp://"
let isValidUrl3 = test3.canOpenURL

print(isValidUrl3)


let test4 = "https://www.google.com/"
let isValidUrl4 = test4.canOpenURL
print(isValidUrl4)


func validateURL (urlString: String) -> Bool {
    let urlRegEx = "(https?://(www.)?)?[-a-zA-Z0-9@:%._+~#=]{2,256}.[a-z]{2,6}b([-a-zA-Z0-9@:%_+.~#?&//=]*)"
    let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    return urlTest.evaluate(with: urlString)
}

print(validateURL(urlString: test3))
print(validateURL(urlString: test4))


extension String {
    func isValidUrlPredicate() -> Bool {
        guard let url = NSURL(string: self) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

let test5 = "partnerapp://"
let isValidUrl5 = test5.isValidUrlPredicate

print(test5.isValidUrlPredicate())


let test6 = "https://www.google.com/"
let isValidUrl6 = test6.isValidUrlPredicate
print(test6.isValidUrlPredicate())


let urlSchemeText = "https://www.google.com/"
let urlString = urlSchemeText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

let app = UIApplication.shared
print("Custom URL validation started",app)
if let urlString = urlString,
    let url = URL(string: urlString),
    app.canOpenURL(url) == true
{
    print("Custom URL validated")
    if #available(iOS 10.0, *) {
        //app.open(url, options: [:], completionHandler: nil)
    } else {
        //app.openURL(url)
    }
}else{
    print("Custom URL validation failed")
}




5

var url:NSURL = NSURL(string: "tel://000000000000")!
if UIApplication.shared.canOpenURL(url as URL) {
    print("Custom URL validated = tel")
} else {
    print("Custom URL validation failed = tel")
}
     // Put your error handler code..

extension String {
    func isStringLink() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && !self.isEmpty) else { return false }
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) > 0 {
            print(self.count)
            return true
        }
        if UIApplication.sharedApplication().canOpenURL(self) {
            return true
        }
        return false
    }
}

//Usage
let testURL: String = "http://www.google.com"
let testURL2: String = "tel://000000000000"
let testURL3: String = "partnerapp://"
if testURL3.isStringLink() {
    //Valid!
    print("Custom URL validated = isStringLink")

} else {
    //Not valid.
    print("Custom URL validation failed = isStringLink")

}
