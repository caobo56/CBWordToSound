//
//  ViewController.m
//  CBWordToSound
//
//  Created by caobo56 on 2018/1/25.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "ViewController.h"
#import<AVFoundation/AVFoundation.h>

@interface ViewController ()<AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController{
    AVSpeechSynthesizer * av;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //实现该方法是需要注意view需要是继承UIControl而来的
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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



@end
