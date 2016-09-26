//
//  StartLiveController.m
//  Live
//
//  Created by lin on 16/9/26.
//  Copyright © 2016年 biqinglin. All rights reserved.
//

#import "StartLiveController.h"
#import <LFLiveKit.h>

#define KWindowWidth MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))
#define KWindowHeight MAX(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))

@interface StartLiveController () <LFLiveSessionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic, strong) LFLiveSession *session;

@property (weak, nonatomic) IBOutlet UIView *livingView;

/**这个就是本地服务器的RTMP地址 */
@property (nonatomic, copy) NSString *rtmp;

@end

@implementation StartLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 默认开启后置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionBack;
}

- (LFLiveSession*)session {
    
    if(!_session){
        
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        //_session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2] liveType:LFLiveRTMP];
        
        /** 定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        
        LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
        audioConfiguration.numberOfChannels = 2;
        audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
        audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
        videoConfiguration.videoSize = CGSizeMake(720, 1280);
        videoConfiguration.videoBitRate = 800*1024;
        videoConfiguration.videoMaxBitRate = 1000*1024;
        videoConfiguration.videoMinBitRate = 500*1024;
        videoConfiguration.videoFrameRate = 15;
        videoConfiguration.videoMaxKeyframeInterval = 30;
        videoConfiguration.orientation = UIInterfaceOrientationPortrait;
        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration liveType:LFLiveRTMP];
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingView;
    }
    return _session;
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    NSLog(@"%@",[NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.rtmp]);
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

- (IBAction)startLive:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        
        // 192.168.1.100这里填写的是你本地IP地址
        stream.url = @"rtmp://192.168.1.100:1935/rtmplive/room";
        self.rtmp = stream.url;
        [self.session startLive:stream];
        
        [self.startButton setTitle:@"关闭直播" forState:0];
    }
    else {
        
        [self.session stopLive];
        [self.startButton setTitle:@"开启直播" forState:0];
    }
}

/**
 *  切换前后摄像头
 */
- (IBAction)changeCapture:(id)sender {
    
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}

/**
 *  返回
 */
- (IBAction)close:(id)sender {
    
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
    NSLog(@"%@已销毁",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
