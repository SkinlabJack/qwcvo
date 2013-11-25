//
//  QuestionnaireViewController.m
//  tryseason
//
//  Created by Dai Qinfu on 13-1-8.
//  Copyright (c) 2013年 Dai Qinfu. All rights reserved.
//

#import "QuestionnaireViewController.h"

#define QuestionsCount 12

@interface QuestionnaireViewController ()

@end

@implementation QuestionnaireViewController

- (void)dealloc
{
    DLog(@"QuestionnaireViewController dealloc");
    self.delegate = nil;
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userAnswer    = [[NSMutableArray alloc] init];
        _previousArray = [[NSMutableArray alloc] init];
        
        if ([DataCenter isFileExist:@"answerDic.plist"]) {
            _answerDic = [[NSMutableDictionary alloc] initWithDictionary:[DataCenter readDictionaryFromFile:@"answerDic.plist"]];
        }else{
            _answerDic = [[NSMutableDictionary alloc] init];
        }
        
        _doneNumber = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    
    [self setupNavigationController];
    
    QuestionView *tempQuestionView = [[QuestionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 75 - 50)];
    self.questionView = tempQuestionView;
    self.questionView.delegate = self;
    [self.view addSubview:self.questionView];
    
    QuestionnaireProgressView *tempQuestionnaireProgressView = [[QuestionnaireProgressView alloc] initWithFrame:CGRectMake(0, kScreenHeight - KSNHeight - 32, kScreenWidth, 30)];
    self.questionnaireProgressView = tempQuestionnaireProgressView;
    [self.view addSubview:self.questionnaireProgressView];
    
    UIButton *tempNextButton = [[UIButton alloc] initWithFrame:CGRectMake(185, kScreenHeight - 90 - 44, 75, 30)];
    self.nextButton = tempNextButton;
    self.nextButton.backgroundColor = GreenColor;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius  = 5;
    [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    self.nextButton.enabled = NO;
    
    UIButton *tempPreviousButton = [[UIButton alloc] initWithFrame:CGRectMake(60, kScreenHeight - 90 - 44, 75, 30)];
    self.PreviouseButton = tempPreviousButton;
    self.PreviouseButton.backgroundColor = GreenColor;
    self.PreviouseButton.layer.masksToBounds = YES;
    self.PreviouseButton.layer.cornerRadius  = 5;
    [self.PreviouseButton setTitle:@"上一题" forState:UIControlStateNormal];
    [self.PreviouseButton addTarget:self action:@selector(previousButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.PreviouseButton];
    self.PreviouseButton.enabled = NO;
    
    self.skinType = [NSString stringWithFormat:@"DRNT"];
    
    StateLabel *tempTextLabel = [[StateLabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    self.stateLabel = tempTextLabel;
    self.stateLabel.center = CGPointMake(kScreenWidth/2, (kScreenHeight - KSNHeight)/2);
    self.stateLabel.text   = @"正在为您加载问卷，请稍候...";
    [self.view addSubview:self.stateLabel];
    
    if (self.questionArray == nil) {
        [self httpRequestTestData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick event:@"testview" label:@"begin"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationController {
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}


- (void)savePrevious:(NSDictionary *)dic{
    [self.previousArray addObject:dic];
    self.PreviouseButton.enabled = YES;
    
    _doneNumber++;
    [self.questionnaireProgressView setProgressData:100 * _doneNumber/QuestionsCount];
}

- (void)deletePrevious{
    if (self.previousArray.count != 0) {
        _doneNumber--;
        [self.questionnaireProgressView setProgressData:100 * _doneNumber/QuestionsCount];
        [self.previousArray removeObjectAtIndex:(self.previousArray.count - 1)];
    }
    
    if (self.previousArray.count == 0) {
        self.PreviouseButton.enabled = NO;
    }

}

- (void)showNoteVie:(NSString *)qDes show:(BOOL)show{
    if (self.noteView == nil) {
        UIButton *tempNoteView = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 548)];
        self.noteView = tempNoteView;
        self.noteView.alpha = 0;
        [self.noteView addTarget:self action:@selector(noteViewTaped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:self.noteView];
        
    }
    
    int imageNumber = 0;
    
    if ([qDes isEqualToString:@"主流媒体将皮肤类型简单的归类为油性.干性与混合性。但是以上三种皮肤特征都被皮肤其他的特征所\345\275\261响。这些特征包括：皮肤的屏障能力（可理解为皮肤自身保护能力），皮肤形成色素的功能，皮肤的氧化程度等等。敬请您今天给予我们一点儿耐性与美肤实验室共同探索真正适合您的护肤选\346\213\251。"]) {
        imageNumber = 1;
    }else if ([qDes isEqualToString:@"因为容易受到外界细菌的攻击，所以敏感性皮肤其中一个症状就是座疮。以下问题将会诊断您是哪一类型的敏感肤质。"]) {
        imageNumber = 2;
    }else if ([qDes isEqualToString:@"紫外线的袭击是皮肤老化的主要因素，让我们了解您的光老化程度，推荐适合您的抗氧化剂。"]) {
        imageNumber = 3;
    }else{
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"说明%d.jpg", imageNumber];
    [self.noteView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.noteView setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.noteView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.noteView.alpha = 0;
        }];
    }
    
}

#pragma mark - Button

- (IBAction)leftBarButtonClicked:(UIButton *)sender {
    [self.userAnswer removeAllObjects];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)previousButtonClicked:(id)sender{
    NSString *questionID = self.previousArray[self.previousArray.count - 1][@"QuestionID"];
    NSString *answerID   = self.previousArray[self.previousArray.count - 1][@"AnswerID"];
    [self.questionView setQuestionViewData:self.questionArray[questionID.intValue]
                                questionID:questionID.intValue];
    DLog(@"%@", answerID)
    [self.questionView setAnswerViewSelected:answerID];
    [self deletePrevious];
}

- (IBAction)nextButtonClicked:(UIButton *)sender {
    [self.questionView answerClicked:self.questionView.answerID];
    
}

- (void)noteViewTaped{
    [UIView animateWithDuration:0.25 animations:^{
        self.noteView.alpha = 0;
    }];
}

#pragma mark - httpRequest

- (void)httpRequestTestData{
    
    [[SkinLabHttpClient sharedClient] getPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeTestData]
                                   parameters:@{@"id": @""}
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          self.stateLabel.hidden = YES;
                                          self.stateLabel.touchEnable = NO;
                                          
                                          NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                               options:NSJSONReadingMutableLeaves
                                                                                                 error:nil];
                                          self.questionArray = dataArray;
                                          
//                                          if (![DataCenter isNull:self.questionArray[0][@"QDes"]]) {
//                                              [self showNoteVie:self.questionArray[0][@"QDes"] show:YES];
//                                          }
//                                          DLog(@"%@", dataArray)
                                          
                                          [self.questionView setQuestionViewData:self.questionArray[0] questionID:0];
                                          [self.questionnaireProgressView setProgressData:0];
                                          
                                          self.nextButton.enabled = YES;
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          self.stateLabel.text = @"网络连接超时，点击重试...";
                                          
                                          __weak typeof(self) blockSelf = self;
                                          [self.stateLabel addTapGesture:^(UILabel *label) {
                                              [blockSelf httpRequestTestData];
                                          }];
                                          
                                          DLog(@"%@",error);
                                      }];
}

- (void)httpRequestUpLoadAnswer:(NSString *)userID
                         answer:(NSString *)answer
                       skinType:(NSString *)skinType{
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeTestUploadNew]
                                    parameters:@{@"UserID": userID, @"Answers": answer, @"SkinType": skinType}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSString *responseString = [operation.responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"NULL\""];
                                           NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                   options:NSJSONReadingMutableLeaves
                                                                                                     error:nil];
                                        
                                           if ([DataCenter isNull:dataDic]) {
                                               [self questionnaireDidEnded];
                                           }else{
                                               [self.delegate questionnaireDidFinished:dataDic];
                                               [self dismissModalViewControllerAnimated:YES];
                                           }
                                           
//                                           DLog(@"%@", dataDic)
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           self.stateLabel.text = @"网络连接超时，点击重试...";
                                           
                                           __weak typeof(self) blockSelf = self;
                                           [self.stateLabel addTapGesture:^(UILabel *label) {
                                               [blockSelf questionnaireDidEnded];
                                           }];
                                           
                                           DLog(@"%@",error);
                                       }];

}


#pragma mark - QuestionViewDelegate
- (void)answerButtonDidClicked:(NSInteger)nextTag
                     buttonTag:(NSInteger)buttonTag
                      isSingle:(BOOL)isSingle
                      skinType:(NSString *)skinType
                 nowQuestionID:(int)nowQuestionID{
    
    NSDictionary *previousData = @{@"QuestionID": [NSString stringWithFormat:@"%d", nowQuestionID], @"SkinType": self.skinType, @"AnswerID": [NSString stringWithFormat:@"%d", buttonTag]};
    [self savePrevious:previousData];
    
    [self.answerDic setObject:[NSString stringWithFormat:@"%d", buttonTag] forKey:[NSString stringWithFormat:@"%d", nowQuestionID + 1]];
    
    NSArray *typeArray = @[@"D", @"R", @"N", @"T", @"O", @"S", @"P", @"W"];
    if (![skinType isEqualToString:@""]) {
//        DLog(@"skinType = %@", skinType);
        
        for (int i = 0; i < 8; i++) {
            
            if ([typeArray[i] isEqualToString:skinType]) {

                NSMutableString *temp = [NSMutableString stringWithString:self.skinType];
                if (i == 4) {
                    self.skinType = [temp stringByReplacingOccurrencesOfString:@"D" withString:skinType];
                }else if (i == 5){
                    self.skinType = [temp stringByReplacingOccurrencesOfString:@"R" withString:skinType];
                }else if (i == 6){
                    self.skinType = [temp stringByReplacingOccurrencesOfString:@"N" withString:skinType];
                }else if (i == 7){
                    self.skinType = [temp stringByReplacingOccurrencesOfString:@"T" withString:skinType];
                }
            }
        }
    }else{

    }
    DLog(@"skinType = %@", self.skinType);
    
    [self.questionView setQuestionViewData:self.questionArray[nextTag - 1] questionID:(nextTag - 1)];
    [self.userAnswer addObject:[NSString stringWithFormat:@"%d", buttonTag]];
    
    NSString *questionID = self.questionArray[nextTag - 1][@"QID"];
    NSString *answerID   = self.answerDic[questionID];
    [self.questionView setAnswerViewSelected:answerID];
    [[DataCenter shareData] writeToFile:self.answerDic withFileName:@"answerDic.plist"];
    
//    if (![DataCenter isNull:self.questionArray[nextTag - 1][@"QDes"]]) {
//        [self showNoteVie:self.questionArray[nextTag - 1][@"QDes"] show:YES];
//    }
}

- (void)questionnaireDidEnded{
    
    self.nextButton.enabled     = NO;
    self.questionView.hidden    = YES;
    self.stateLabel.hidden      = NO;
    self.stateLabel.text        = @"测试完成，正在为您加载测试结果...";
    self.stateLabel.touchEnable = NO;
    
    [self.questionnaireProgressView setProgressData:100];
    NSString *answerString = [self.userAnswer componentsJoinedByString:@"@@"];
    
    [self httpRequestUpLoadAnswer:[DataCenter shareData].deviceID
                           answer:answerString
                         skinType:self.skinType];
        
    DLog(@"FAnswers = %@", answerString);
    DLog(@"FSkinType = %@", self.skinType);
    DLog(@"%@", self.answerDic)
    
    [MobClick event:@"testview" label:@"end"];
}

@end
