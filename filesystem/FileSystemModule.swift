//
//  FileSystemModule.swift
//  aftermath
//
//  Copyright  2022 JAMF Software, LLC
//

import Foundation
import AppKit

class FileSystemModule: AftermathModule, AMProto {
    
    let name = "FileSystem"
    var dirName = "FileSystem"
    var description = "A module that performs file system scans"
    lazy var moduleDirRoot = self.createNewDirInRoot(dirName: dirName)
    lazy var rawDir = self.createNewDir(dir: moduleDirRoot, dirname: "raw")
    
    
    func run() {
        // run browser module
        let browserModule = BrowserModule()
        browserModule.run()
        
        // get slack data
        let slackFile = self.createNewCaseFile(dirUrl: self.moduleDirRoot, filename: "slack_extract.json")
        let slack = Slack(slackLoc: self.rawDir, writeFile: slackFile)
        slack.run()
        
        // get data from common directories
        let commonDirFile = self.createNewCaseFile(dirUrl: self.moduleDirRoot, filename: "common_directories.txt")
        let common = CommonDirectories(writeFile: commonDirFile)
        common.run()
        
        // get users on system
        let sysUsers = self.createNewCaseFile(dirUrl: self.moduleDirRoot, filename: "users.txt")
        for user in getUsersOnSystem() { self.addTextToFile(atUrl: sysUsers, text: "\nUsers\n\(user.username)\n\(user.homedir)\n") }
        
        // walk file system
        let walker = FileWalker()
        walker.run()
    }
}
