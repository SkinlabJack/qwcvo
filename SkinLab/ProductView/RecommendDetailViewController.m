//
//  RecommendDetailViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-25.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "RecommendDetailViewController.h"

#define ImageHeight   200
#define InfoHeight    70
#define ButtonViewHeight  60
#define SimilarViewHeight 190

@interface RecommendDetailViewController ()

@end

@implementation RecommendDetailViewController

- (void)dealloc
{
    DLog(@"RecommendDetailViewController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _ingredientsDic = [[NSMutableDictionary alloc] init];
        _recommendDetailViewMode = RecommendDetailViewModeWithoutNav;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [self setupProductImageView];
    [self setupProductInfoView];
    [self setupButtonView];
    [self setupNavigationController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ViewCreate

- (void)setProductInfoByID:(NSString *)productID{
    if (productID != nil) {
        [self httpRequestProductInfo:productID];
        DLog(@"##%@##", productID);
    }
}

- (void)setupNavigationController{
    
    if (![AppHelper shareHelper].appCenter.isiPhone5 && self.recommendDetailViewMode == RecommendDetailViewModeWithoutNav) {
        
        float y = 0;
        if ([AppHelper shareHelper].appCenter.isiOS7) {
            y = 25;
        }else{
            y = 7.5;
        }
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, y, 50, 30)];
        [leftButton setImage:[UIImage imageNamed:@"透明返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftButton];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 55, y, 50, 30)];
        [rightButton setImage:[UIImage imageNamed:@"透明主页"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightButton];
    
    }
    
    if (![AppHelper shareHelper].appCenter.isiOS7) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"主页" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setupProductImageView{
    
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        if (self.recommendDetailViewMode == RecommendDetailViewModeWithNav) {
            
            UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
            self.scrollView = tempScrollView;

        }else{
            
            UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSHeight)];
            self.scrollView = tempScrollView;
            
            if ([AppHelper shareHelper].appCenter.isiOS7) {
                self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }else{
                self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSHeight);
            }

        }
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - KSHeight + 1);
    }else{
        UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
        self.scrollView = tempScrollView;
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - KSNHeight + 1);
    }

    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    UIView *imageBack = [[UIView alloc] initWithFrame:CGRectMake(0, - (400 - ImageHeight), kScreenWidth, 400)];
    imageBack.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:imageBack];
    
    UIImageView *tempProductImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageHeight, ImageHeight)];
    self.productImage = tempProductImage;
    self.productImage.center = CGPointMake(160, ImageHeight/2);
    [self.scrollView addSubview:self.productImage];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, ImageHeight - 1, kScreenWidth, 1)];
    line.image = [UIImage imageNamed:@"分割线"];
    [self.scrollView addSubview:line];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HideSource"]) {
        
        _infoViewHeight = InfoHeight;
        
    }else{
        UIButton *sourceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, ImageHeight + InfoHeight + 10, 160, 30)];
        [sourceButton setImage:[UIImage imageNamed:@"查看数据来源"] forState:UIControlStateNormal];
        [sourceButton addTarget:self action:@selector(showSource:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:sourceButton];
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:CGRectMake(190, ImageHeight + InfoHeight + 10, 120, 30)];
        [hideButton setImage:[UIImage imageNamed:@"隐藏数据来源"] forState:UIControlStateNormal];
        [hideButton addTarget:self action:@selector(hideSource:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:hideButton];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, ImageHeight + InfoHeight + 50 - 1, kScreenWidth, 1)];
        line.image = [UIImage imageNamed:@"分割线"];
        [self.scrollView addSubview:line];
        
        _infoViewHeight = InfoHeight + 50;
    }
    
    if ([AppHelper shareHelper].appCenter.isiOS7 && ![AppHelper shareHelper].appCenter.isiPhone5 && self.recommendDetailViewMode != RecommendDetailViewModeWithNav) {
        UIView *state = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KSHeight)];
        state.backgroundColor = GreenColor;
        [self.view addSubview:state];
    }
    
}

- (void)setupProductInfoView{
    
    UILabel *tempProductBrand = [[UILabel alloc] initWithFrame:CGRectMake(10, ImageHeight + 5, 300, 25)];
    self.productBrand = tempProductBrand;
    self.productBrand.backgroundColor = [UIColor clearColor];
    self.productBrand.font            = [UIFont boldSystemFontOfSize:18];
    self.productBrand.textColor       = BlackColor;
    [self.scrollView addSubview:self.productBrand];

    UILabel *tempProductName = [[UILabel alloc] initWithFrame:CGRectMake(10, ImageHeight + 30, 170, 32)];
    self.productName = tempProductName;
    self.productName.numberOfLines   = 2;
    self.productName.backgroundColor = [UIColor clearColor];
    self.productName.font            = [UIFont systemFontOfSize:15];
    self.productName.textColor       = TextGrayColor;
    [self.scrollView addSubview:self.productName];

    UILabel *tempProductPrice = [[UILabel alloc] initWithFrame:CGRectMake(180, ImageHeight + 30, 130, 32)];
    self.productPrice = tempProductPrice;
    self.productPrice.backgroundColor = [UIColor clearColor];
    self.productPrice.textAlignment   = UITextAlignmentRight;
    self.productPrice.font      = [UIFont boldSystemFontOfSize:15];
    self.productPrice.textColor = GreenColor;
    [self.scrollView addSubview:self.productPrice];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, ImageHeight + InfoHeight - 1, kScreenWidth, 1)];
    line.image = [UIImage imageNamed:@"分割线"];
    [self.scrollView addSubview:line];
    
    
}

- (void)setupButtonView{
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, ImageHeight + _infoViewHeight, kScreenWidth, ButtonViewHeight)];
    self.buttonView = tempView;
    [self.scrollView addSubview:self.buttonView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.image = [UIImage imageNamed:@"分割线"];
    [self.buttonView addSubview:line];
    
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 140, 30)];
    self.wantButton = buyButton;
    [self.wantButton setTitle:@"想用" forState:UIControlStateNormal];
    [self.wantButton setBackgroundColor:GreenColor];
    self.wantButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.wantButton addTarget:self action:@selector(wantButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:self.wantButton];
    
    UIButton *favoritButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 15, 140, 30)];
    self.usingButton = favoritButton;
    [self.usingButton setTitle:@"在用" forState:UIControlStateNormal];
    [self.usingButton setBackgroundColor:GreenColor];
    self.usingButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.usingButton addTarget:self action:@selector(usingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:self.usingButton];
    
}

- (void)setProductInfo:(NSDictionary *)dic{
    self.productInfoDic = dic;
    
    __weak typeof(self) blockSelf = self;
    
//    设置产品基本信息
    NSURL *imageURL = [SkinLabHttpClient getImageURL:self.productInfoDic[@"productImage"]];
    [self.productImage setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL]
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          float zoom = image.size.width/image.size.height;
                                          blockSelf.productImageWidth = ImageHeight * zoom;
                                          
                                          blockSelf.productImage.frame  = CGRectMake(0, 0, ImageHeight * zoom, ImageHeight);
                                          blockSelf.productImage.center = CGPointMake(kScreenWidth/2, ImageHeight/2);
                                          blockSelf.productImage.image  = image;
                                          
                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          DLog(@"%@",error);
                                      }];
    
    self.productBrand.text = self.productInfoDic[@"productBrand"];
    self.productName.text  = self.productInfoDic[@"productName"];
    self.productPrice.text = [NSString stringWithFormat:@"参考价 ￥%@", self.productInfoDic[@"productPrice"]];
    
    [self.usingButton setTitle:[NSString stringWithFormat:@"在用  %@人在用", self.productInfoDic[@"productCollect"]] forState:UIControlStateNormal];
    [self.wantButton setTitle:[NSString stringWithFormat:@"想用  %@人想用", self.productInfoDic[@"productWish"]] forState:UIControlStateNormal];
    
    [self setupProductIndexView];
    
//    设置推荐产列表
    if (![IOHelper isNull:self.productInfoDic[@"productID"]]) {
        NSString *productID = self.productInfoDic[@"productID"];
        [self httpRequestSimilarProduct:productID page:@"1"];
    }
}

- (void)setupProductIndexView{
    
    NSString *oilyIndex         = self.productInfoDic[@"OilyIndex"];
    NSString *pigmentedIndex    = self.productInfoDic[@"PigmentedIndex"];
    NSString *sensitiveIndex    = self.productInfoDic[@"SensitiveIndex"];
    NSString *wrinkledIndex     = self.productInfoDic[@"WrinkledIndex"];
    NSArray  *ingredientsArray  = self.productInfoDic[@"productIngres"];
    
    NSMutableDictionary *productDesDic = [NSMutableDictionary dictionary];
    
    if (![IOHelper isNull:self.productInfoDic[@"productDes"]]) {
        
        NSArray  *productDesArray = [self.productInfoDic[@"productDes"] componentsSeparatedByString:@"@@"];
        
        for (NSString *tempString in productDesArray) {
            NSArray *indexArray = [tempString componentsSeparatedByString:@"$$"];
            if (indexArray.count >= 2) {
                [productDesDic setObject:indexArray[1] forKey:indexArray[0]];
            }
        }
    }else{
        productDesDic = nil;
    }
    
    ParametersView *para = [[ParametersView alloc] initWithFrame:CGRectMake(0, ImageHeight + _infoViewHeight, 320, 145)];
    self.parametersView  = para;
    self.parametersView.ingredientsLightArray = self.ingredientsArray;
    self.parametersView.delegate = self;
    self.parametersView.alpha    = 0;
    [self.parametersView setupParametersoily:oilyIndex
                                   pigmented:pigmentedIndex
                                   wensitive:sensitiveIndex
                                    wrinkled:wrinkledIndex
                        withIngredientsArray:ingredientsArray
                              withproductDes:productDesDic
                              withLightArray:self.ingredientsArray];
    [self.scrollView addSubview:self.parametersView];
    
    [UIView animateWithDuration:0.25 animations:^{
       self.parametersView.alpha = 1;
    } completion:^(BOOL finished) {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"IndexFirstLaunch"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IndexFirstLaunch"];
            UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 504)];
            [helpButton setImage:[UIImage imageNamed:@"用户引导指数"] forState:UIControlStateNormal];
            [helpButton setImage:[UIImage imageNamed:@"用户引导指数"] forState:UIControlStateHighlighted];
            [helpButton addTarget:self action:@selector(hideHelp:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:helpButton];
        }
    }];
    
}

- (void)setupSimilarProduct:(NSArray *)productArray{        
    
    SimilarProductView *tempView = [[SimilarProductView alloc] initWithFrame:CGRectMake(0, ImageHeight + _infoViewHeight + ButtonViewHeight + self.parametersView.frame.size.height, kScreenWidth, 200)];
    self.similarProductView = tempView;
    self.similarProductView.delegate = self;
    self.similarProductView.alpha    = 0;
    [self.similarProductView setSimilarProduct:productArray];
    [self.scrollView addSubview:self.similarProductView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.similarProductView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - HttpRequest

- (void)httpRequestProductInfo:(NSString *)productID{
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeProductInfo]
                                    parameters:@{@"productID": productID}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:[IOHelper cleanNullOfString:operation.responseString]
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];
                                           if (![IOHelper isNull:dataArray]) {
                                               [self setProductInfo:dataArray[0]];
                                           }
                                           
                                           DLog(@"%@", dataArray);
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
}

- (void)httpRequestSimilarProduct:(NSString *)productID page:(NSString *)page{
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeProductSimilar]
                                    parameters:@{@"proID": productID, @"page": page}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];
                                           [self setupSimilarProduct:dataArray];
                                           DLog(@"%@", dataArray);
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
}

- (void)httpRequestIngredient:(NSString *)ingredientsID{
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeProductIngredient]
                                    parameters:@{@"ingreID": ingredientsID}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                   options:NSJSONReadingMutableLeaves
                                                                                                     error:nil];
                                           [self.ingredientsDetailView setIngredientView:dataDic];
                                           self.ingredientsDic[dataDic[@"ingreID"]] = dataDic;
//                                           DLog(@"%@", dataDic);
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
}

- (void)httpRequestAddCollect:(NSString *)UserID productID:(NSString *)productID{
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeProductCollect]
                                    parameters:@{@"UserID": UserID, @"ProductID": productID}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
}

- (void)httpRequestAddWishList:(NSString *)UserID productID:(NSString *)productID{
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeProductwish]
                                    parameters:@{@"UserID": UserID, @"ProductID": productID}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
}



#pragma mark - ButtonClicked

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)showSource:(id)sender{
    SourceViewController *sourceViewController = [[SourceViewController alloc] initWithNibName:@"SourceViewController" bundle:nil];
    if (self.recommendDetailViewMode == RecommendDetailViewModeWithNav) {
        sourceViewController.showNav = YES;
    }
    [self.navigationController pushViewController:sourceViewController animated:YES];
}

- (IBAction)hideSource:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HideSource"];
}

- (IBAction)hideHelp:(UIButton *)sender{
    [sender removeFromSuperview];
}

- (IBAction)usingButtonClicked:(UIButton *)sender{
    if (!sender.selected) {
        int count = [self.productInfoDic[@"productCollect"] integerValue] + 1;
        [self.usingButton setTitle:[NSString stringWithFormat:@"在用  %d人在用", count] forState:UIControlStateNormal];
        
        [self httpRequestAddCollect:[AppHelper shareHelper].appCenter.deviceID productID:self.productInfoDic[@"productID"]];
        [[AppHelper shareHelper].dataCenter addToMyUsing:self.productInfoDic];
        sender.selected = !sender.selected;
    }
}

- (IBAction)wantButtonClicked:(UIButton *)sender{
    if (!sender.selected) {
        int count = [self.productInfoDic[@"productCollect"] integerValue] + 1;
        [self.wantButton setTitle:[NSString stringWithFormat:@"想用  %d人想用", count] forState:UIControlStateNormal];
        
        [self httpRequestAddWishList:[AppHelper shareHelper].appCenter.deviceID productID:self.productInfoDic[@"productID"]];
        [[AppHelper shareHelper].dataCenter addToMyWant:self.productInfoDic];
        sender.selected = !sender.selected;
    }
}



#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0) {
        float width  = self.productImageWidth * (1 - scrollView.contentOffset.y/ImageHeight);
        float height = ImageHeight - scrollView.contentOffset.y;
        
        self.productImage.frame  = CGRectMake(0, scrollView.contentOffset.y, width, height);
        self.productImage.center = CGPointMake(160, self.productImage.center.y);
    }
}

#pragma mark - IngredientsViewDelegate

- (void)ingredientLabelDidTouched:(IngredientView *)ingredientView{
    if (self.ingredientsDetailView == nil) {
        IngredientsDetailView *tempIngredientsDetailView = [[IngredientsDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.ingredientsDetailView = tempIngredientsDetailView;
        self.ingredientsDetailView.alpha = 0;
        [self.view.window addSubview:self.ingredientsDetailView];
    }else{
        self.ingredientsDetailView.alpha = 0;
        [self.view.window addSubview:self.ingredientsDetailView];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.ingredientsDetailView.alpha = 1;
    }];
    
    self.ingredientsDetailView.ingreDes = ingredientView.ingredientDes;
    
    if (self.ingredientsDic[ingredientView.ingredientID] != nil) {
       [self.ingredientsDetailView setIngredientView:self.ingredientsDic[ingredientView.ingredientID]];
    }else{
        [self httpRequestIngredient:ingredientView.ingredientID];
    }
    
    [MobClick event:@"ingredient" label:ingredientView.ingredientID];

}

#pragma mark - ParametersViewDelegate

- (void)heightOfParametersView:(float)Height{
    self.parametersView.frame   = CGRectMake(0, ImageHeight + _infoViewHeight, kScreenWidth, Height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.buttonView.frame = CGRectMake(0, ImageHeight + _infoViewHeight + Height, kScreenWidth, ButtonViewHeight);
        self.similarProductView.frame = CGRectMake(0, ImageHeight + _infoViewHeight + ButtonViewHeight + Height, kScreenWidth, self.similarProductView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    float viewHeight;
    
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        viewHeight = kScreenHeight - KSHeight;
    }else{
        viewHeight = kScreenHeight - KSNHeight;
    }
    
    float nowHeight = ImageHeight + _infoViewHeight + ButtonViewHeight + Height + SimilarViewHeight;
    
    if (nowHeight < viewHeight) {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, viewHeight + 1);
    }else{
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, nowHeight);
    }
    
}

#pragma mark - SimilarProductViewDelegate

- (void)productImageDidClicked:(NSString *)productID{
    DLog(@"%@", productID)
    RecommendDetailViewController *recommendDetailViewController = [[RecommendDetailViewController alloc] initWithNibName:@"RecommendDetailViewController" bundle:nil];
    [recommendDetailViewController setProductInfoByID:productID];
    [self.navigationController pushViewController:recommendDetailViewController animated:YES];

    NSString *product = [NSString stringWithFormat:@"%@ByProduct", productID];
    [MobClick event:@"productview" label:product];
    
}

@end
