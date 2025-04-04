//
//  Setting.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct Setting:View{
    @State var show = false
    var body:some View{
        ZStack{
            VStack{
                NavigationView {
                    List{
                        
                        Section(header: Text("關於")){
                            HStack{
                                Spacer()
                                VStack{
                                    Image("Icon")
                                        .resizable().frame(width:60,height:60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(color:.primary.opacity(0.5)
                                                ,radius: 11,x: 1, y: 1).onTapGesture {
                                            show = true
                                        }
                                    Text("多功能APP").padding(5)
                                    Text("Version:1.0.1").padding(5)
                                    Text("Copyright © 2024 Toolspeter").padding(5)
                                }
                                Spacer()
                            }
                            HStack{
                                Link(destination: URL(string: "https://github.com/Toolspeter")!){
                                    Image("Github").resizable().frame(width:20,height:20)
                                        .foregroundStyle(.primary)
                                }
                                Text("Toolspeter")
                                Spacer()
                            }
                        }
                    }
                    .navigationTitle("設定")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
//            if !show{
//                ZStack{
//                    progressbar()
//                    progressbar_cut().foregroundStyle(.background)
//                    Text("100%").font(.system(size: 25)).fontWeight(.bold)
//                    
//                }.background(.gray.opacity(0.5))
//                    .onTapGesture {
//                        show = false
//                    }
//            }
        }
    }
}

struct progressbar:Shape{
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x:rect.midX,y:rect.midY)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: -89.0), endAngle: Angle(degrees: -55.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: -53.0), endAngle: Angle(degrees: -19.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: -17.0), endAngle: Angle(degrees: 17.0), clockwise: false)
                        path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 19.0), endAngle: Angle(degrees: 53.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 55.0), endAngle: Angle(degrees: 89.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 91.0), endAngle: Angle(degrees: 125.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 127.0), endAngle: Angle(degrees: 161.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 163.0), endAngle: Angle(degrees: 197.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 199.0), endAngle: Angle(degrees: 233.0), clockwise: false)
            path.move(to:center)
            path.addArc(center: center, radius: 60, startAngle: Angle(degrees: 235.0), endAngle: Angle(degrees: 269.0), clockwise: false)
            
        }
    }
}
struct progressbar_cut:Shape{
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x:rect.midX,y:rect.midY)
            path.move(to: center)
            path.addArc(center: center, radius: 40, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 360.0), clockwise: false)
            path.closeSubpath()
        }
    }
}

#Preview {
//    ContentView()
    Setting()
}
