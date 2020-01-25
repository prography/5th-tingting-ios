//
//  NetworkManager.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//
 
import Alamofire
import RxSwift
import RxCocoa

class NetworkManager {}

// Auth
extension NetworkManager {

    /// 학교인증 API (1)
    static func authenticateSchool(request: APIModel.School.Request) -> Router<CommonReponse> {
        return Router(url: "/auth/school", method: .post, parameters: request)
    }
    
    /// 학교인증 API (2): 사용하지 않음
    //    static func authenticateSchoolConfirm() -> Router<CommonReponse> {
    //        return Router(url: "/auth/school/confirm", method: .post)
    //    }
    
    /// 학교인증 API (3)
    static func authenticateSchoolComplete(email: String) -> Router<CommonReponse> {
        let params = ["email": email]
        return Router(url: "/auth/school/complete", method: .get, parameters: params)
    }
    
    /// 소셜(카카오) 회원가입 --- 수정 중!
    static func kakaoLogin(email: String) -> Router<CommonReponse> {
        let params = ["email": email]
        return Router(url: "/auth/school/confirm", method: .get, parameters: params, removeTokenCodes: [401])
        
    }
    
    /// 로컬 로그인
    static func login(request: APIModel.Login.Request) -> Router<APIModel.Login.Response> {
        return Router(url: "/auth/local/login", method: .post, parameters: request)
    }
    
    /// 로컬 회원가입
    static func signUp(request: APIModel.SignUp.Request) -> Router<APIModel.SignUp.Response> {
        return Router(url: "/auth/local/signup", method: .post, parameters: request)
    }
    
    /// 아이디(로컬아이디) 중복확인
    static func checkDuplicate(loginID: String) -> Router<CommonReponse> {
        let params = ["local_id": loginID]
        return Router(url: "/auth/duplicate-id", method: .get, parameters: params)
    }
    
    /// 이름(닉네임) 중복확인
    static func checkDuplicate(name: String) -> Router<CommonReponse> {
        let params = ["name": name]
        return Router(url: "/auth/duplicate-name", method: .get, parameters: params)
    }
    
    /// 로그아웃 --- 미구현
    static func logout() -> Router<CommonReponse> {
        return Router(url: "/auth/logout", method: .get)
    }
}

// Profile
extension NetworkManager {
    
    /// 내 프로필 보기
    static func getMyProfile() -> Router<APIModel.MyProfile> {
        return Router(url: "/me/profile", method: .get, removeTokenCodes: [401, 403])
    }
    
    /// 내 프로필 수정하기
    static func editMyProfile(to user: User) -> Router<APIModel.MyProfile> {
        return Router(url: "/me/profile", method: .put, parameters: user, removeTokenCodes: [401, 403])
    }
    
    /// 다른 사용자 프로필 보기
    static func getProfile(id: String) -> Router<APIModel.Profile> {
        return Router(url: "/user/\(id)/profile", method: .get, removeTokenCodes: [401, 403])
    }
}

// Team
extension NetworkManager {
    
    /// 전체 팀 리스트 보기
    static func getAllTeams() -> Observable<[Team]> {
//        let mockData = (0...20).map { _ in MockTeam.getMockResponse() }
//        return Router(url: "/teams", method: .get, mockData: mockData)
        
        return Router<APIModel.TeamList>(url: "/teams", method: .get)
            .asObservable()
            .map { $0.getTeamList() }
    }
    
    /// 팀 생성하기
    static func createTeam(_ teamInfo: TeamInfo) -> Router<Team> {
//        return Router(url: "/teams", method: .post, mockData: MockTeam.getMockResponse())
         return Router(url: "/teams", method: .post, parameters: teamInfo)
    }
    
    /// 팀명 중복 확인
    static func checkDuplicate(teamName: String) -> Router<CommonReponse> {
//        return Router(url: "/teams/duplicate-name", method: .get, mockData: MockCommonReponse.getMockResponse())
        
        let params = ["name": teamName]
        return Router(url: "/teams/duplicate-name", method: .get, parameters: params)
    }
    
    /// 개별 팀 정보 보기
    static func getTeamInfo(id: Int) -> Router<Team> {
//        return Router(url: "/teams/\(id)", method: .get, mockData: MockTeam.getMockResponse())

                return Router(url: "/teams/\(id)", method: .get)
    }
    
    /// 개별 팀 정보 보기
    static func getMyTeamInfo(id: String) -> Router<Team> {
//        return Router(url: "/me/teams/\(id)", method: .get, mockData: MockTeam.getMockResponse())
         return Router(url: "/me/teams/\(id)", method: .get)
    }
    
    /// 나의 팀 정보 수정하기
    static func editTeamInfo(id: String, teamInfo: TeamInfo) -> Router<Team> {
        return Router(url: "/me/teams/\(id)", method: .get)
    }
    
    /// 팀 떠나기
    static func leaveTeam(id: String) -> Router<CommonReponse> {
        return Router(url: "/me/teams/\(id)/leave", method: .post)
    }
    
    /// 팀 합류하기
    static func joinTeam(id: Int) -> Router<CommonReponse> {
//        return Router(url: "/teams/\(id)/join", method: .post, mockData: MockCommonReponse.getMockResponse())
         return Router(url: "/teams/\(id)/join", method: .post)
    }
}

// Matching
extension NetworkManager {
    /// 전체 매칭 후보 목록 보기
    static func getAllMatchingList() -> Router<APIModel.MatcingTeamList> {
        return Router(url: "/matching/teams", method: .get)
    }
    
    /// 개별 매칭 후보 정보 보기 (팀보기)
    static func getMatchingTeam(id: Int) -> Router<Team> {
        
        let myTeamID = TeamManager.shared.selectedMyTeamInfo.value?.id
        
        let params = ["myTeamId": myTeamID]
        
        return Router(url: "/matching/teams/\(id)", method: .get, parameters: params)
    }

    /// 개별 매칭 후보 정보 보기 (신청팀 보기)
    static func getAppliedMatchingTeam(id: Int) -> Router<Team> {
        
        let myTeamID = TeamManager.shared.selectedMyTeamInfo.value?.id
        
        let params = ["myTeamId": myTeamID]
        
        return Router(url: "/matching/applied-teams/\(id)", method: .get, parameters: params)
    }
    
    static func applyFirstMatching(request: APIModel.ApplyMatching.Request) -> Router<CommonReponse> {
        return Router(url: "/matching/send-heart/first", method: .post, parameters: request)
    }
    
    static func applyMatching(teamID: Int) -> Router<CommonReponse> {
        let params = ["matchingId": teamID]
        return Router(url: "/matching/send-heart", method: .post, parameters: params)
    }
    
    static func acceptMatching(teamID: Int) -> Router<CommonReponse> {
        let params = ["matchingId": teamID]
        return Router(url: "/matching/receive-heart", method: .post, parameters: params)
    }
    
}

extension NetworkManager {
    static func cancelAllRequest() {
        URLSession.shared.invalidateAndCancel()
    }
}
