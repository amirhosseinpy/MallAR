//
//  FileDownloader.swift
//  MallAR
//
//  Created by amirhosseinpy on 6/13/1399 AP.
//  Copyright © 1399 Farazpardazan. All rights reserved.
//

import Foundation

class FileDownloader {
    func loadFileAsync(urlString: String?, fileName: String?, completion: @escaping (URL?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        // create your document folder url
        guard let documentsUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }
        
        // your destination file url
        let destination = documentsUrl.appendingPathComponent(fileName ?? url.lastPathComponent)
        
        print("downloading file from URL: \(url.absoluteString)")
        print("destination: \(destination)")
        if FileManager().fileExists(atPath: destination.path) {
            print("The file already exists at path, deleting and replacing with latest")
            
            if FileManager().isDeletableFile(atPath: destination.path) {
                do {
                    try FileManager().removeItem(at: destination)
                    print("previous file deleted")
                    self.saveFile(url: url, destination: destination) { (complete) in
                        if complete {
                            completion(destination)
                        } else {
                            completion(nil)
                        }
                    }
                } catch {
                    print("current file could not be deleted")
                }
            }
            // download the data from your url
        } else {
            self.saveFile(url: url, destination: destination) { (complete) in
                if complete {
                    completion(destination)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func saveFile(url: URL, destination: URL, completion: @escaping (Bool) -> Void) {
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            // after downloading your data you need to save it to your destination url
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let location = location, error == nil
                else { print("error with the url response"); completion(false); return}
            do {
                try FileManager.default.moveItem(at: location, to: destination)
                print("new file saved at \(destination)")
                completion(true)
            } catch {
                print("file could not be saved: \(error)")
                completion(false)
            }
        }).resume()
    }
}

class FileSystem {
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let downloadDirectory: URL = {
        let directory: URL = FileSystem.documentsDirectory.appendingPathComponent("/Download/")
        return directory
    }()
}
