//
//  PlayerView.swift
//  HypnoPluss
//
//  Created by Yalcin Emilli on 25.08.20.
//

import SwiftUI
import AVKit
import MediaPlayer
import NotificationCenter
struct PlayerView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var kurs: Kurse
    var title: String
    
    init(_ kurs: Kurse, _ title: String) {
        self.kurs = kurs
        self.title = title
    }
    
    var body: some View {
        MusicPlayer(kurs: kurs, title: title)
            .navigationBarTitle("\(kurs.kursname)")
            .navigationBarBackButtonHidden(true)
                       .navigationBarItems(leading: Button(action : {
                           self.mode.wrappedValue.dismiss()
                       }){
                           Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                            .font(.title)
                       })
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(Kurse.exampleKurs, "Abnehmen_1")
    }
}

struct MusicPlayer : View {
    var kurs: Kurse
    @State var data : Data = .init(count: 0)
    @State var title = "ziuo"
    @State var player : AVAudioPlayer!
    @State var playerItem : AVPlayerItem!
    @State var playing = false
    @State var width : CGFloat = 0
    @State var songs = ""
    @State var current = 0
    @State var finish = false
    @State var del = AVdelegate()
    @State var startTime = "00:00"
    @State var EndTime = "00:00"
    var body : some View{
        
        VStack {
            
            ZStack {
                Image(self.kurs.image)
                .resizable()
                .frame(width: 250, height: 250)
                    .cornerRadius(15)
            }.padding()
         
            
            ZStack(alignment: .leading) {
                    
                            
                    Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)

                Capsule().fill(Color.red).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            let x = value.location.x
                            self.width = x
                            
                        }).onEnded({ (value) in
                            
                            let x = value.location.x
                            
                            let screen = UIScreen.main.bounds.width - 30
                            
                            let percent = x / screen
                            
                            self.player.currentTime = Double(percent) * self.player.duration
                           
                        }))
                }
                .padding(.top)
            VStack {
                HStack {
                    Text("\(self.startTime)")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("\(self.EndTime)")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            HStack(spacing: UIScreen.main.bounds.width / 5 - 30){
                
                Button(action: {
                    
                        self.player.stop()
                        setupNowPlaying()
                        self.playing = false
                        self.player.currentTime = 0
                        self.width = 0
                        self.startTime = "00:00"
                        
                    
                    
                }) {
            
                    Image(systemName: "stop.fill").font(.title)
                    
                }
                
                    Button(action: {
                        
                        self.player.currentTime -= 15
                        
                    }) {
                
                        Image(systemName: "gobackward.15").font(.title)
                        
                    }
                
                    Button(action: {
                        
                        if self.player.isPlaying{
                            
                            self.player.pause()
                            setupNowPlaying()
                            self.playing = false
                        }
                        else{
                            
                            if self.finish{
                                
                                self.player.currentTime = 0
                                self.width = 0
                                self.finish = false
                                
                            }
                            
                            self.player.play()
                            self.playing = true
                        }
                        
                    }) {
                
                        Image(systemName: self.playing && !self.finish ? "pause.fill" : "play.fill").font(.title)
                        
                    }
                
                    Button(action: {
                       
                        let increase = self.player.currentTime + 15
                        
                        if increase < self.player.duration{
                            
                            self.player.currentTime = increase
                        }
                        
                    }) {
                
                        Image(systemName: "goforward.15").font(.title)
                        
                    }
             
                
            }.padding(.top,25)
            .foregroundColor(.black)
            Spacer()
        }.padding()

        .onAppear {
            
            let url = Bundle.main.path(forResource: self.title, ofType: "mp3")
            
            self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            self.playerItem = AVPlayerItem(url: URL(fileURLWithPath: url!))
            //self.player = AVPlayer(playerItem: self.playerItem)
            self.player.delegate = self.del
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }
            catch{
                fatalError("playback failed")
            }
            endTimer()
            self.player.prepareToPlay()
            setupNowPlaying()
//            setupRemoteTransportControls()
//            self.player.play()
            //self.getData()

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                
                if self.player.isPlaying{

                    let screen = UIScreen.main.bounds.width - 30

                    let value = self.player.currentTime / self.player.duration
                    
                    timerupdate()
                    self.width = screen * CGFloat(value)
                }
            }

            NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in

                self.finish = true
                setupNowPlaying()
            }
        }
        
        .onDisappear {
            if self.player.isPlaying {
                self.player.stop()
                self.playing = false
                self.player.currentTime = 0
                self.width = 0
                self.startTime = "00:00"
            }
        }
    }
    

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
    }

    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.title

        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    

    func timerupdate() {
        
        
        let time = Int(self.player.currentTime)
        let minute = time/60
        let seconds = time - minute * 60
        self.startTime = String(format: "%02d:%02d", minute,seconds) as String
        /*
        let duration3 = Int(self.player.duration)
        let minutes3 = duration3/60
        let seconds3 = duration3 - minutes3 * 60
        
        let minutes4 = minutes3 - minute
        let seconds4 = seconds3 - seconds
        
        //print(seconds)
        //self.EndTime = String(format: "%02d:%02d", minutes4,seconds4) as String
*/
        
    }

    func endTimer() {
        let duration = Int(self.player.duration)
        let minutes2 = duration/60
        let seconds2 = duration - minutes2 * 60
        
        
        self.EndTime = String(format: "%02d:%02d", minutes2,seconds2) as String
        
    }
}
