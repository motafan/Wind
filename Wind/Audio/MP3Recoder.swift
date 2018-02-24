//
//  MP3Recoder.swift
//  Wind
//
//  Created by tanfanfan on 2017/2/13.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

final public class MP3Bot: NSObject {
   fileprivate struct Constant {
        public static let bufferByteSize: UInt32 = 10240 * 8
        public static let bufferNum: Int = 3
        public static let sampleRate: Float64 = 16000
        public static let bitsPerChannel: UInt32 = 16
        public static let formatID: AudioFormatID = kAudioFormatLinearPCM
    }
    
    fileprivate lazy var mp3Buffer: [UInt8] =  {
        return [UInt8](repeating: 0, count:Int(Constant.bufferByteSize))
    }()
    fileprivate var audioQueue: AudioQueueRef?
    fileprivate var audioBuffer: [AudioQueueBufferRef?] = []
    fileprivate var recordFormat: AudioStreamBasicDescription!
    public private(set) var isRecording: Bool = false
    private(set) var fileUrl: URL!
    private(set) var fileHandle: FileHandle!
    let lame = LameGetConfigContext()
    public func startRecord(fileUrl: URL) throws {
        
        if self.isRecording {
            return
        }
        
        self.fileUrl = fileUrl
        do {
            if FileManager.default.fileExists(atPath: fileUrl.absoluteString) {
               try FileManager.default.removeItem(at: fileUrl)
            }
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                                    with: .defaultToSpeaker)
            try session.setActive(true)
            
            try fileHandle = FileHandle(forUpdating: fileUrl)
        } catch let error {
            throw error
        }
        setAudioFormat()
        let userData = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        var recordFormat = self.recordFormat!
        
        // 设置回调函数
        AudioQueueNewInput(
            &recordFormat,
            AudioQueueInputCallback,
            userData,
            CFRunLoopGetCurrent(),
            nil,
            0,
            &audioQueue
        )
        // 创建缓冲器
        for _ in 0..<Constant.bufferNum {
            var buffer: AudioQueueBufferRef? = nil
            AudioQueueAllocateBuffer(audioQueue!, Constant.bufferByteSize, &buffer)
            AudioQueueEnqueueBuffer(audioQueue!, buffer!, 0, nil)
            self.audioBuffer.append(buffer) 
        }
        
        // 开始录音
        AudioQueueStart(audioQueue!, nil)
        isRecording = true
    }
    
    public func stopRecord() {
        if isRecording {
            isRecording = false
            AudioQueueStop(self.audioQueue!, true)
            AudioQueueDispose(self.audioQueue!, true)
            fileHandle.closeFile()
        }
    }
    
    private func setAudioFormat() {
        
        recordFormat = AudioStreamBasicDescription()
        recordFormat.mSampleRate = Constant.sampleRate
        recordFormat.mFormatID = kAudioFormatLinearPCM
        recordFormat.mChannelsPerFrame =  UInt32(AVAudioSession.sharedInstance().inputNumberOfChannels)
        // If the output format is PCM, create a 16-bit file format description.
        recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked
        recordFormat.mBitsPerChannel = Constant.bitsPerChannel
        recordFormat.mBytesPerFrame = (recordFormat.mBitsPerChannel / 8) * recordFormat.mChannelsPerFrame
        recordFormat.mBytesPerPacket = recordFormat.mBytesPerFrame
        recordFormat.mBytesPerFrame = recordFormat.mBytesPerPacket
        recordFormat.mFramesPerPacket = 1
    }
    
    private func checkError(error: OSStatus,with errorString: String) -> Bool {
        
        if error == noErr { return true }
        
        return false
    }
}


func AudioQueueInputCallback(inUserData: UnsafeMutableRawPointer?,
                             inAQ: AudioQueueRef,
                             inBuffer: AudioQueueBufferRef,
                             inStartTime: UnsafePointer<AudioTimeStamp>,
                             inNumPackets: UInt32,
                             inPacketDesc: UnsafePointer<AudioStreamPacketDescription>?) {
    let recoder = Unmanaged<MP3Bot>.fromOpaque(inUserData!).takeUnretainedValue()
    
    if inNumPackets > 0  && recoder.isRecording {
        let buffer = inBuffer.pointee
        let nsamples = buffer.mAudioDataByteSize
        let lame = recoder.lame
        let pcm = buffer.mAudioData.assumingMemoryBound(to: Int16.self)
        let size = lame_encode_buffer(lame, pcm, pcm, Int32(nsamples), &recoder.mp3Buffer, Int32(nsamples * 4))
        let data =  Data(bytes: &recoder.mp3Buffer, count: Int(size))
        recoder.fileHandle.write(data)
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
    }
}

public func synchronized(_ lock: Any, handler: () ->()) {
    objc_sync_enter(lock);  defer { objc_sync_exit(lock) }
    handler()
}

private func LameGetConfigContext() -> lame_t! {
    let lame = lame_init()
    //通道
    lame_set_num_channels(lame, 1)
    //采样率
    lame_set_in_samplerate(lame, Int32(MP3Bot.Constant.sampleRate));
    //位速率
    lame_set_brate(lame, Int32(MP3Bot.Constant.bitsPerChannel))
    lame_set_mode(lame, MPEG_mode(rawValue: 1))
    //音频质量
    lame_set_quality(lame, 2)
    id3tag_set_comment(lame,"sjw")
    lame_init_params(lame)
    return lame
}
