# CBWordToSound
iOS 文字转录音——AVSpeechSynthesizer的使用
之前写了个语音转文字的，就再弄一个文字转语音的demo

代码过程：

### 添加AVFoundation Framework

TARGET --》General -》Linked Frameworks and Libraries
添加 AVFoundation
并在项目中添加speech头文件
```
#import <AVFoundation/AVFoundation.h>
```
### 关键代码
```
- (IBAction)soundAction:(id)send {
    UIButton * sender = (UIButton *)send;
    if(sender.selected == NO) {
        if([av isPaused]) {
            //如果暂停则恢复，会从暂停的地方继续
            [av continueSpeaking];
            sender.selected=!sender.selected;
        }else{
            //初始化对象
            av= [[AVSpeechSynthesizer alloc]init];
            av.delegate = self;//挂上代理
            AVSpeechUtterance*utterance = [[AVSpeechUtterance alloc]initWithString:_textView.text];//需要转换的文字
            utterance.rate=AVSpeechUtteranceMinimumSpeechRate;
            // 设置语速，范围0-1，注意0最慢，1最快；
            // AVSpeechUtteranceMinimumSpeechRate最慢，
            // AVSpeechUtteranceMaximumSpeechRate最快
            AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置发音，这是中文普通话
            utterance.voice= voice;
            [av speakUtterance:utterance];//开始
            sender.selected=!sender.selected;
        }
    }else{
//        [av stopSpeakingAtBoundary:AVSpeechBoundaryWord];//感觉效果一样，对应代理>>>取消
        [av pauseSpeakingAtBoundary:AVSpeechBoundaryWord];//暂停
        sender.selected=!sender.selected;
    }
}
```

### 设置代理
```
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---完成播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    
}
```
