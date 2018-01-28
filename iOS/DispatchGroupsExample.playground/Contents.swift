//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
// this property to true so that the playground will continue the execution of the Swift file even after reaching the last line.

/*
 Default cache values:
    Memory capacity: 4 megabytes (4 * 1024 * 1024 bytes)
    Disk capacity: 20 megabytes (20 * 1024 * 1024 bytes)
    Disk path: <nobr>(user home directory)/Library/Caches/(application bundle id)
*/
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

let session = URLSession.shared

let urls = [
    URL(string:"http://www.apple.com")!,
    URL(string:"http://www.frontside.hu")!,
    URL(string:"http://www.facebook.com")!]

let urlGroup = DispatchGroup()

for url in urls {
    urlGroup.enter()
    let task = session.dataTask(with: url) {
        data, response, error in
        print("Downloaded the site: \(url)")
        urlGroup.leave()
    }
    task.resume()
}

//You can wait for the all answer with this solution:
//urlGroup.wait()
//PlaygroundPage.current.finishExecution()

//You can use timeout.
//guard urlGroup.wait(timeout: .now() + 3) == .success else { fatalError()}
//print("All done")
//PlaygroundPage.current.finishExecution()

//Callback answer
urlGroup.notify(queue: .main){
    PlaygroundPage.current.finishExecution()
    print("All done")
}



