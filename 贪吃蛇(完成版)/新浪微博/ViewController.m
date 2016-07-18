//
//  ViewController.m
//  新浪微博
//
//  Created by 飞奔的羊 on 16/3/5.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMove;
@property (weak, nonatomic) IBOutlet UIView *Sneak;
@property (nonatomic,weak) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *labelSneak;
@property (nonatomic,weak)UILabel *food;
@property (nonatomic)CGRect originFram;
@property (nonatomic) CGPoint lastPosition;
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
@property (nonatomic)CGFloat changeTime;
@property (nonatomic)int score;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation ViewController
/**
 *  设置初始属性
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.changeTime = 0.1;
    self.originFram =self.Sneak.frame;
    
    self.changeTime = 0.1;
}
/**
 *  重写score的方法
 *
 *  @param score
 */
- (void)setScore:(int)score{
    _score =score;
    NSString *str = [NSString stringWithFormat:@"%d",score];
    [self.coinButton setTitle:str forState:UIControlStateNormal];
    
}
/**
 *  向下移动
 */
- (IBAction)downButton {
     [self.timer invalidate];
    self.timer = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.changeTime target:self selector:@selector(move) userInfo:nil repeats:YES];
  
    [UIView animateWithDuration:2 animations:^{
                self.Sneak.subviews.lastObject.transform = CGAffineTransformRotate(self.Sneak.subviews.lastObject.transform, -M_PI_2);
        self.labelSneak.transform = CGAffineTransformRotate(self.labelSneak.transform, -M_PI_2);
        self.Sneak.transform = CGAffineTransformRotate(self.Sneak.transform, -M_PI_2);
    }];
    self.timer = timer;
}
- (void)move{
    [self eatFood];
  if (self.con.constant >= 675) {
        self.con.constant = 0;
        [self.view layoutIfNeeded];
    }
    self.con.constant +=3;
    [UIView animateWithDuration:1 animations:^{
        //需要重新更新布局->重新加载当前控件中的子控件
        
        [self.view layoutIfNeeded];
    }];
    
}
/**
 *  向右移动
 */
- (IBAction)clickRight {
     [self.timer invalidate];
    self.timer = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.changeTime target:self selector:@selector(moveR) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:2 animations:^{
                self.Sneak.subviews.lastObject.transform = CGAffineTransformRotate(self.Sneak.subviews.lastObject.transform, -M_PI_2);
          self.labelSneak.transform = CGAffineTransformRotate(self.labelSneak.transform, -M_PI_2);
      self.Sneak.transform = CGAffineTransformRotate(self.Sneak.transform, M_PI_2);
  }];
    
    
    self.timer = timer;
}
- (void)moveR{
    [self eatFood];
    if (self.rightMove.constant >= 500) {
        self.rightMove.constant = 0;
        [self.view layoutIfNeeded];
    }
    self.rightMove.constant +=3;
    [UIView animateWithDuration:1 animations:^{

        [self.view layoutIfNeeded];
    }];
    
   
    
}
/**
 *  向左移动
 */
- (IBAction)clickLeft {
      [self.timer invalidate];
    self.timer = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.changeTime target:self selector:@selector(moveL) userInfo:nil repeats:YES];
    [UIView animateWithDuration:2 animations:^{
                self.Sneak.subviews.lastObject.transform = CGAffineTransformRotate(self.Sneak.subviews.lastObject.transform, M_PI_2);
          self.labelSneak.transform = CGAffineTransformRotate(self.labelSneak.transform, M_PI_2);
        self.Sneak.transform = CGAffineTransformRotate(self.Sneak.transform, -M_PI_2);
    }];
    self.timer = timer;
}
- (void)moveL{
    [self eatFood];
    self.rightMove.constant -=3;
    if (self.rightMove.constant <= 0) {
        self.rightMove.constant = 500;
        [self.view layoutIfNeeded];
    }
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}
/**
 *  向上地洞
 */
- (IBAction)clickUp {
   [self.timer invalidate];
    self.timer = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.changeTime target:self selector:@selector(moveU) userInfo:nil repeats:YES];
    [UIView animateWithDuration:2 animations:^{
        self.Sneak.subviews.lastObject.transform = CGAffineTransformRotate(self.Sneak.subviews.lastObject.transform, M_PI_2);
          self.labelSneak.transform = CGAffineTransformRotate(self.labelSneak.transform, M_PI_2);
        self.Sneak.transform = CGAffineTransformRotate(self.Sneak.transform, -M_PI_2);
    }];
    self.timer = timer;
}
- (void)moveU{
    [self eatFood];
    if (self.con.constant <= 0) {
        self.con.constant = 675;
        [self.view layoutIfNeeded];
       
        
    }
    self.con.constant -=3;
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}
/**
 *  吃食物
 */
- (void)eatFood{
    //1. 获取当前控件的frame
    self.originFram =self.Sneak.frame;
    //2. 获取要吃的frame
    CGRect food = self.food.frame;
    //3. 如果fame重叠(X Y MidX 或者)封装一个方法
    if (food.origin.x >= CGRectGetMinX(self.originFram)&&food.origin.x <= CGRectGetMaxX(self.originFram)&&food.origin.y >= CGRectGetMinY(self.originFram)&&food.origin.y <= CGRectGetMaxY(self.originFram)) {
        
        [self.food removeFromSuperview];
        self.score +=5;
            [self addSneak];
        [self addfood];
        if (self.score == 95) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"好像通关了" preferredStyle:UIAlertControllerStyleAlert];
            
            //创建两个UIAlertActoion对象
            UIAlertAction *ActionOK = [UIAlertAction actionWithTitle:@"下一关?" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *ActionCancle = [UIAlertAction actionWithTitle:@"留在当前页面" style:UIAlertActionStyleCancel handler:nil];
            
            //把AlertAction添加到AlertController里
            [alertController addAction:ActionCancle];
            [alertController addAction:ActionOK];
            //显示弹窗
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    //      3.1 获取吃的中心点  X  Y  如果中点的X Y 都在蛇的里面
    //            吃 x >= 蛇的MinX && 吃的X <= 蛇的MaxX && 吃的Y >= 蛇的MinY &&吃的Y<=蛇的最大的Y
    //
 


}
/**
 *  开始按钮
 */
- (IBAction)clickStart {
    [self window];
    self.startButton.enabled = NO;
}
/**
 *  添加小蛇
 */
-(void)addSneak{
    UIView *lastView = self.Sneak.subviews.lastObject;
    UILabel *la = [[UILabel alloc]init];
    la.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame), 20, 20);
    la.font = [UIFont systemFontOfSize:15];
    la.text = @"🐍";
    [self.Sneak addSubview:la];
}
/**
 *  添加食物
 */
-(void)addfood{

    UILabel *label = [[UILabel alloc]init];
    label.text = @"❤️";
    label.bounds = CGRectMake(0, 0, 25, 25);
    label.font = [UIFont systemFontOfSize:20];
    int x = arc4random_uniform(self.view.frame.size.width - (self.Sneak.bounds.size.width+50)) + 50;
    int y = arc4random_uniform(self.view.frame.size.height - (self.Sneak.bounds.size.width+50)) +100;
    
    label.frame = CGRectMake(x, y, 25, 25);
    self.food = label;
    [self.view addSubview:label];
    self.changeTime -=0.005;
  
}
/**
 *  弹窗
 */
-(void)window{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"来自制作者" message:@"没耐心的请退出" preferredStyle:UIAlertControllerStyleAlert];
    
    //创建两个UIAlertActoion对象
    UIAlertAction *ActionCancle = [UIAlertAction actionWithTitle:@"不玩你点什么" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UILabel *labele = [[UILabel alloc]init];
        labele.frame = CGRectMake(0, self.view.center.y, 414, 30);
        
        labele.text = @"你是一个快乐的小2B";
        labele.textColor = [UIColor blueColor];
        labele.textAlignment = NSTextAlignmentCenter;
        labele.font = [UIFont systemFontOfSize:35];
        [self.view addSubview:labele];
        
        labele.alpha = 0;
        [UIView animateWithDuration:3 animations:^{
         
            labele.alpha = 1;
        } completion:^(BOOL finished) {
             [self.view removeFromSuperview];
        }];
       
    }
                                   ];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"开始鬼畜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addfood];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moveU) userInfo:nil repeats:YES];
    }];
    
    
    //把AlertAction添加到AlertController里
    [alertController addAction:ActionCancle];
    [alertController addAction:action];
    //显示弹窗
    [self presentViewController:alertController animated:YES completion:nil];

}
/**
 *  时间的改变
 */
- (void)TimeJudgement{
    if (self.changeTime <=0.01) {
        
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
