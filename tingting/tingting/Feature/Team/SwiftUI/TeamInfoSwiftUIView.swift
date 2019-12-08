//
//  TeamInfoSwiftUIView.swift
//  tingting
//
//  Created by 김선우 on 11/23/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import SwiftUI

struct TeamInfoSwiftUIView: View {
    @State private var name: String = "여기에 초대를 위한 소개를 남겨보세요!!여기에 초대를 위한 소개를 남겨보세요!!여기에 초대를 위한 소개를 남겨보세요!!여기에 초대를 위한 소개를 남겨보세요!!여기에 초대를 위한 소개를 남겨보세요!!여기에 초대를 위한 소개를 남겨보세요!!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            TeamInfoCardSwiftUIView()
            
            Text("팀원 목록").bold()
            HStack(alignment: .bottom, spacing: 10) {
                UserCardSwiftUIView()
                UserCardSwiftUIView()
                UserCardSwiftUIView()
            }
            
            Text("메시지").bold()
            TextField("여기에 초대를 위한 소개를 남겨보세요!!", text: $name).lineLimit(0).padding()
            Spacer()
            
        }.padding()
    }
}

struct TeamInfoSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TeamInfoSwiftUIView()
    }
}

struct TeamInfoCardSwiftUIView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .bottom) {
                
                Text("불금불금")
                    .padding(.bottom, -4)
                    .font(.title)
                    .foregroundColor(.primaryColor)
                
                HStack {
                    ForEach(["여자", "4:4"], id: \.self) {
                        Text($0)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(25)
                    }
                }
                Spacer()
            }
            Text("안녕하세요~~ 다음주에 홍대에서 재밌게 놀 사람~~~~~~~ 구해요~~ 많이 신청해주세요")
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primaryColor, lineWidth: 3)
        )
    }
}


struct UserCardSwiftUIView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image("sampleImage").resizable()
                .frame(width: 45.0, height: 45.0)
                .clipShape(Circle())
            Text("팀장")
            Text("정해")
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
        )
    }
}
 
