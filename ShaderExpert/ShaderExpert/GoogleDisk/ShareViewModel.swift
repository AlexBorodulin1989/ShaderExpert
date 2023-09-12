//
//  LoginViewModel.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 12.09.2023.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST_Drive
#if os(macOS)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

final class ShareViewModel: ObservableObject {
    let service = GTLRDriveService()
}

extension ShareViewModel {
    func loginToGoogle() {

        if let window = Self.keyWindow() {
            let signInConfig = GIDConfiguration.init(clientID: "212033144017-vkh2oj61rfgj9mgkmbau8aro03uo1gh8.apps.googleusercontent.com")
            GIDSignIn.sharedInstance.configuration = signInConfig
            GIDSignIn.sharedInstance.signIn(withPresenting: window, hint: nil, additionalScopes: [kGTLRAuthScopeDrive]) { [weak self] result, error in
                if let error = error {
                    assert(false, error.localizedDescription)
                } else {
                    print(result?.user.accessToken.tokenString ?? "")
                    //result?.user.accessToken.expirationDate

                    self?.service.authorizer = result?.user.fetcherAuthorizer

                    self?.listAllFiles("me", token: nil) { files, nextPageToken, error in
                        print(files)
                    }
                }
            }
        }
    }
}

extension ShareViewModel {
    public func listAllFiles(_ fileName: String, token: String?, onCompleted: @escaping ([GTLRDrive_File]?, String?, Error?) -> ()) {

        let root = "(mimeType = 'image/jpeg' or mimeType = 'image/png' or mimeType = 'application/pdf') and (name contains '\(fileName)')"
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.pageToken = token
        query.q = root
        query.fields = "files(id,name,mimeType,modifiedTime,fileExtension,size,iconLink, thumbnailLink, hasThumbnail),nextPageToken"

        service.apiKey = "AIzaSyDMO0zn-2t9sSu26oGpx7UnD5_7WS1-d04"
        service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files, (results as? GTLRDrive_FileList)?.nextPageToken, error)
        }
    }
}

extension ShareViewModel {
    public static func keyWindow() -> NSWindow?
    {
        //UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        return NSApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
