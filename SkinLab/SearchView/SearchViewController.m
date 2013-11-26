//
//  SearchViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-3.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SearchViewController.h"

#define SearchViewHeight 110
#define SkinTypeViewWidth 60

#define TableFrameShort CGRectMake(SkinTypeViewWidth, SearchViewHeight, kScreenWidth - SkinTypeViewWidth, kScreenHeight - KSNHeight - SearchViewHeight)
#define TableFramelong  CGRectMake(SkinTypeViewWidth, SearchViewHeight, kScreenWidth - SkinTypeViewWidth, kScreenHeight - KSNHeight - 40)


@interface SearchViewController ()

@property (assign, nonatomic) int page;

@end

@implementation SearchViewController

- (void)dealloc
{
    DLog(@"SearchViewController dealloc")
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searching   = NO;
        _loadingMore = NO;
        _contenty    = 0;
        
        _brandsButtonSelected = NO;
        _typesButtonSelected  = NO;
        _priceButtonSelected  = NO;
        
        _withOutKeyWord = @"";
        _withKeyWord    = @"";
        _keyWord   = @"";
        _type      = @"";
        _brands    = @"";
        _priceLow  = @"";
        _priceHigh = @"";
        
        self.productPriceArray = @[@"所有价格", @"0~200", @"200~400", @"400~1000", @"1000+"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationController];
    [self setupMainView];
    [self setupSearchView];
    [self setupSearchTableView];
    [self setupSkinTypeView:[DataCenter shareData].classArray];
    [self setupStateLabel];
    
    [self.stateLabel setupStateLabel:StateLabelModeLoading];
    
    _page = 1;
    self.keyWord = [self.keyWord stringByReplacingOccurrencesOfString:@" " withString:@"@@"];
    [self searchWithPage:_page];
    [self getProductBrands];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.searchMode != SearchModeWithIngres) {
        
    }else{
        [self setupNavigationController];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationController{
    
    if (![AppHelper shareHelper].appCenter.isiOS7) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }else{
        
    }
    
}

- (void)setupMainView{
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 70)];
    self.mainView = tempView;
    [self.view addSubview:self.mainView];
    
}

- (void)setupSearchView {
    
    if ([DataCenter shareData].deviceType == DeviceTypeiPhone4) {
        SearchView *tempView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SearchViewHeight) withMode:SearchViewModeSearchView];
        self.searchView = tempView;
    }else{
        SearchView *tempView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SearchViewHeight) withMode:SearchViewModeMainView];
        self.searchView = tempView;
    }
    
    self.searchView.searchField.text = self.keyWord;
    self.searchView.delegate = self;
    [self.mainView addSubview:self.searchView];
    
}

- (void)setupSkinTypeView:(NSArray *)array {
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, SearchViewHeight, SkinTypeViewWidth, kScreenHeight - KSHeight - SearchViewHeight + 70)];
    self.skinTypeView = tempView;
    [self.mainView addSubview:self.skinTypeView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SkinTypeViewWidth - 1, 0, 1, self.skinTypeView.frame.size.height)];
    line.backgroundColor = GreenColor;
    [self.skinTypeView addSubview:line];
    
    float buttonHeight;
    
    if ([DataCenter shareData].deviceType == DeviceTypeiPhone5) {
        buttonHeight = (kScreenHeight - KSNHeight - SearchViewHeight)/6;
    }else{
        buttonHeight = (kScreenHeight - KSHeight - SearchViewHeight)/6;
    }
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonHeight * i, SkinTypeViewWidth, buttonHeight)];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:[DataCenter shareData].classArray[i][@"basicType"] forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(skinTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.skinTypeView insertSubview:button belowSubview:line];
    }
}

- (void)setupSearchTableView{
    
    if ([DataCenter shareData].deviceType == DeviceTypeiPhone4) {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SearchViewHeight, kScreenWidth, kScreenHeight)];
        self.searchTableView = tempTableView;
        
        if ([AppHelper shareHelper].appCenter.isiOS7) {
            self.searchTableView.frame = CGRectMake(SkinTypeViewWidth, SearchViewHeight, kScreenWidth - SkinTypeViewWidth, kScreenHeight - SearchViewHeight);
        }else{
            self.searchTableView.frame = CGRectMake(SkinTypeViewWidth, SearchViewHeight, kScreenWidth - SkinTypeViewWidth, kScreenHeight - KSHeight - SearchViewHeight);
        }
        
    }else{
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:TableFrameShort];
        self.searchTableView = tempTableView;
    }
    
    self.searchTableView.delegate   = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.bounces    = NO;
    self.searchTableView.backgroundColor = GrayColor;
    self.searchTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.searchTableView.separatorColor  = [UIColor clearColor];
    self.searchTableView.contentInset    = UIEdgeInsetsMake(0, 0, 30, 0);
    self.searchTableView.showsVerticalScrollIndicator = NO;
    [self.mainView addSubview:self.searchTableView];
    
}

- (void)setupfilterView {
    
    UIView *tempFilterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.filterView = tempFilterView;
    self.filterView.alpha = 0;
    [self.view addSubview:self.filterView];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 325)];
    tempView.layer.shadowOffset  = CGSizeMake(0, 0);
    tempView.layer.shadowColor   = [UIColor blackColor].CGColor;
    tempView.layer.shadowOpacity = 0.5;
    tempView.layer.shadowRadius  = 5.0;
    [self.filterView addSubview:tempView];
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 325)];
    self.filterTableView = tempTableView;
    [tempView addSubview:self.filterTableView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(45, -10, 20, 10)];
    self.filterImageView = image;
    self.filterImageView.image = [UIImage imageNamed:@"三角"];
    [self.filterView addSubview:self.filterImageView];
    
}

- (void)setupQuickSearchView{
    
    UIView *tempQuickCearch = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - KSNTHeight)];
    self.quickSearchView    = tempQuickCearch;
    self.quickSearchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.quickSearchView.alpha = 0;
    [self.view addSubview:self.quickSearchView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSearchViewTouched)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.quickSearchView addGestureRecognizer:tap];
    
}

- (void)setupStateLabel{
    
    StateLabel *tempStateLabel = [[StateLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.stateLabel = tempStateLabel;
    self.stateLabel.center = CGPointMake((kScreenWidth - SkinTypeViewWidth)/2, (kScreenHeight - KSNHeight - 90)/2);
    [self.searchTableView addSubview:self.stateLabel];
    
    __weak typeof(self) blockSelf = self;
    [self.stateLabel addTapGesture:^(UILabel *label) {
        [blockSelf.stateLabel setupStateLabel:StateLabelModeLoading];

        blockSelf.page = 1;
        [blockSelf searchWithPage:1];
    }];
    
}

- (void)setupNewSearch{
    _loadingMore = NO;
    
    self.keyWord        = @"";
    self.withKeyWord    = @"";
    self.withOutKeyWord = @"";
    self.brands = @"";
    self.type   = @"";
    self.effect = nil;
    _page = 1;
    
    [self.searchView cleanSearchCondition];
}

- (void)showQuickSearchView:(BOOL)show{
    if (self.quickSearchView == nil) {
        [self setupQuickSearchView];
    }
    
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.quickSearchView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            self.quickSearchView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showFilterView:(BOOL)show{
    if (self.filterView == nil) {
        [self setupfilterView];
    }
    
    if (show) {
        self.filterView.frame = CGRectMake(0, self.mainView.frame.origin.y + SearchViewHeight, 320, kScreenHeight);
        [UIView animateWithDuration:0.25 animations:^{
            self.filterView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.filterView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showSkinTypeTableView:(NSString *)skinType buttonFrame:(CGRect)frame{
    if (self.skintypeTableView == nil) {
        self.skintypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(SkinTypeViewWidth, 110, kScreenWidth - SkinTypeViewWidth, 160)];
        self.skintypeTableView.alpha   = 0;
        self.skintypeTableView.bounces = NO;
        self.skintypeTableView.backgroundColor = GreenColor;
        self.skintypeTableView.separatorColor  = [UIColor whiteColor];
        self.skintypeTableView.showsVerticalScrollIndicator = NO;
        [self.mainView addSubview:self.skintypeTableView];
        
        __weak typeof(self) blockSelf = self;
        
        self.skintypeTableDelegate = [[ArrayDelegate alloc] initWithHeight:40
                                                   cellClickedBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                                                       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                
                                                       blockSelf.effect = cell.textLabel.text;
                                                       blockSelf.searchView.searchField.text = cell.textLabel.text;
                                                       [blockSelf searchButtonDidTouched:cell.textLabel.text];
                                                       blockSelf.skintypeTableView.alpha = 0;
                                                       
                                                       [MobClick event:@"QuickSearch" label:cell.textLabel.text];
                                                   }];
        self.skintypeTableView.delegate = self.skintypeTableDelegate;
    }
    
    for (NSDictionary *dic in [DataCenter shareData].classArray) {
        if ([dic[@"basicType"] isEqualToString:skinType]) {
            self.skintypeTableDataSource = [[ArrayDataSource alloc] initWithItems:dic[@"subType"]
                                                            cellIdentifier:@"TyleCell"
                                                        configureCellBlock:^(id cell, id item) {
                                                            
                                                            UITableViewCell *tempCell    = cell;
                                                            tempCell.backgroundColor     = [UIColor clearColor];
                                                            tempCell.textLabel.textColor = [UIColor whiteColor];
                                                            tempCell.textLabel.text      = item[@"subType"];
                                                            tempCell.selectionStyle      = UITableViewCellSelectionStyleNone;
                                                            tempCell.textLabel.font      = [UIFont systemFontOfSize:18];
                                                            
                                                        }];
            self.skintypeTableView.dataSource = self.skintypeTableDataSource;
            [self.skintypeTableView reloadData];
            break;
        }
    }
    
    
    
    if (frame.origin.y + frame.size.height/2 < 80) {
        self.skintypeTableView.frame = CGRectMake(SkinTypeViewWidth, 110, kScreenWidth - SkinTypeViewWidth, 160);
    }else{
        
        if (self.searchTableView.frame.size.height - frame.origin.y - frame.size.height/2 < 80) {
            self.skintypeTableView.frame  = CGRectMake(SkinTypeViewWidth, self.searchTableView.frame.size.height - 160 + 110, kScreenWidth - SkinTypeViewWidth, 160);
        }else{
            self.skintypeTableView.center = CGPointMake(self.skintypeTableView.center.x, frame.origin.y + frame.size.height/2 + 110);
        }
    }
    
    self.skintypeTableView.alpha = 1;

}

- (void)searchWithPage:(int)page{
    if (page != 1) {
        float height = self.searchTableView.contentSize.height;
        
        ActivityView *tempActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0, height, kScreenWidth - SkinTypeViewWidth, 30)];
        self.activityView = tempActivityView;
        self.activityView.delegate = self;
        self.activityView.backgroundColor = [UIColor clearColor];
        [self.searchTableView addSubview:self.activityView];
    }
    
    NSString *pageString = [NSString stringWithFormat:@"%d", page];
    [self httpRequestSearch:self.keyWord
              withoutIngres:self.withOutKeyWord
                 withIngres:self.withKeyWord
                     brands:self.brands
                       type:self.type
                   priceLow:self.priceLow
                  priceHigh:self.priceHigh
                     userID:[DataCenter shareData].deviceID
                       page:pageString];
}

- (void)getProductBrands{
    [self httpRequestBranch:self.keyWord
              withoutIngres:self.withOutKeyWord
                 withIngres:self.withKeyWord
                       type:self.type
                   priceLow:self.priceLow
                  priceHigh:self.priceHigh];
}



#pragma mark - ButtonClicked

- (IBAction)leftBarButtonClicked:(id)sender{
    self.activityView.delegate = nil;
    
    self.filterTableView.delegate   = nil;
    self.filterTableView.dataSource = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreSearchViewTouched{
    [self.searchView cancelButtonClicked:nil];
}

- (void)filterViewTouched{
    [self showFilterView:NO];
    _brandsButtonSelected = NO;
    _typesButtonSelected  = NO;
    _priceButtonSelected  = NO;
}

- (IBAction)skinTypeButtonClicked:(UIButton *)sender {
    
    if (sender.selected) {
        self.skintypeTableView.alpha = 0;
        sender.selected              = NO;

    }else{
        if (!_searching) {
            for (UIView *view in [self.skinTypeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)view;
                    button.backgroundColor = [UIColor whiteColor];
                    button.selected        = NO;
                    [button setTitleColor:GreenColor forState:UIControlStateNormal];
                }
            }
            
            sender.selected        = YES;
            sender.backgroundColor = GreenColor;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.effect = sender.titleLabel.text;
            self.searchView.searchField.text = sender.titleLabel.text;
            [self searchButtonDidTouched:sender.titleLabel.text];
            
            [self showSkinTypeTableView:sender.titleLabel.text buttonFrame:sender.frame];
            
            [MobClick event:@"QuickSearch" label:sender.titleLabel.text];
        }
    }
    
}

#pragma mark - httpRequest

- (void)httpRequestSearch:(NSString *)keyWords
            withoutIngres:(NSString *)withoutIngres
               withIngres:(NSString *)withIngres
                   brands:(NSString *)brands
                     type:(NSString *)type
                 priceLow:(NSString *)priceLow
                priceHigh:(NSString *)priceHigh
                   userID:(NSString *)userID
                     page:(NSString *)page{
    DLog(@"%@", type)
    
    NSDictionary *parameters = @{@"WithIngres": withIngres, @"WithoutIngres": withoutIngres,
                                 @"KeyWords": keyWords, @"Brands": brands,
                                 @"Type": type, @"PriceLow": priceLow,
                                 @"PriceHigh": priceHigh, @"Page": page, @"UserID": userID, @"NeedPara": @"1"};
    _searching = YES;
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSearchKeyWord]
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                   options:NSJSONReadingMutableLeaves
                                                                                                     error:nil];
                                           NSArray *productArray = dataDic[@"Products"];
//                                           DLog(@"%@", dataDic);
                                           
                                           if (![DataCenter isNull:productArray]) {
                                               
                                               if (_page == 1) {
                                                   self.productListArray = [NSMutableArray arrayWithArray:productArray];
                                                   [self.searchTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                                               }else{
                                                   [self.productListArray addObjectsFromArray:productArray];
                                               }
                                               
                                               [self.searchTableView reloadData];
                                               _searching = NO;
                                               
                                               if (self.productListArray.count < 11) {
                                                   
                                                   [UIView animateWithDuration:0.25 animations:^{
                                                       self.mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight + 70);
                                                   } completion:^(BOOL finished) {
                                                      
                                                   }];
                                               }
                                               
                                               if (productArray.count == 0) {
                                                   if (_page == 1) {
                                                       [self.stateLabel setupStateLabel:StateLabelModeNothing];
                                                   }else{
                                                       [self.stateLabel setupStateLabel:StateLabelModeHide];
                                                   }
                                                   _loadingMore = NO;
                                               }else{
                                                   
                                                   if (![DataCenter isNull:dataDic[@"Type"]]) {
                                                       NSMutableArray *tempArray = [NSMutableArray arrayWithObject:@{@"productType": @"所有类型"}];
                                                       [tempArray addObjectsFromArray:dataDic[@"Type"]];
                                                       self.productTypesArray = tempArray;
                                                   }
                                                   
                                                   [self.stateLabel setupStateLabel:StateLabelModeHide];
                                                   _loadingMore = YES;
                                               }
                                               
                                           }else{
                                               _searching   = NO;
                                               _loadingMore = NO;
                                               
                                               if (_page == 1) {
                                                   [self.stateLabel setupStateLabel:StateLabelModeNothing];
                                               }else{
                                                   [self.stateLabel setupStateLabel:StateLabelModeHide];
                                               }
                                           }

                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           _searching   = NO;
                                           _loadingMore = NO;
                                           
                                           [self.stateLabel setupStateLabel:StateLabelModeNetworkingError];
                                           
                                           DLog(@"%@",error);
                                       }];
    
}

- (void)httpRequestBranch:(NSString *)keyWords
            withoutIngres:(NSString *)withoutIngres
               withIngres:(NSString *)withIngres
                     type:(NSString *)type
                 priceLow:(NSString *)priceLow
                priceHigh:(NSString *)priceHigh{
    
    NSDictionary *parameters = @{@"WithIngres": withIngres, @"WithoutIngres": withoutIngres,
                                 @"KeyWords": keyWords, @"Type": type,
                                 @"PriceLow": priceLow, @"PriceHigh": priceHigh,
                                 @"NeedPara": @"1"};
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSearchBrands]
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];
                                           if (![DataCenter isNull:dataArray]) {
                                               NSMutableArray *tempAttay = [NSMutableArray arrayWithObject:@{@"productBrand": @"所有品牌"}];
                                               [tempAttay addObjectsFromArray:[dataArray sortedArrayUsingFunction:searchBrandsSort context:NULL]];
                                               self.productBrandsArray = tempAttay;
                                           }
//                                           DLog(@"%@", dataArray)
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           DLog(@"%@",error);
                                       }];
    
}

- (void)httpRequestProductClicked:(NSString *)productID {
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeProductClicked]
                                    parameters:@{@"UserID": [DataCenter shareData].deviceID, @"ProductID": productID}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];

    
}

NSInteger searchBrandsSort(id user1, id user2, void *context)
{
    NSString *u1,*u2;
    u1 = (NSString *)(user1[@"productBrand"]);
    u2 = (NSString *)(user2[@"productBrand"]);
    return  [u1 localizedCompare:u2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *cellDataDic = self.productListArray[indexPath.row];
    
    NSURL    *imageURL;
    NSString *productName;
    NSString *productBrand;
    NSString *productEffect;
    
    if (![DataCenter isNull:cellDataDic[@"productImage"]]) {
        NSString *imageURLString = [cellDataDic[@"productImage"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
        imageURL = [SkinLabHttpClient getImageURL:imageURLString];
    }else{
        imageURL = nil;
    }
    
    if (![DataCenter isNull:cellDataDic[@"productName"]]) {
        productName = cellDataDic[@"productName"];
    }else{
        productName = @"";
    }
    
    if (![DataCenter isNull:cellDataDic[@"productBrand"]]) {
        productBrand = cellDataDic[@"productBrand"];
    }else{
        productBrand = @"";
    }
    
    if (self.effect != nil) {
        if (![DataCenter isNull:cellDataDic[@"produtEffect"]]) {
            
            NSString *produtEffectString = [cellDataDic[@"produtEffect"] stringByReplacingOccurrencesOfString:@"@@" withString:@","];
            productEffect = [NSString stringWithFormat:@"效果:%@,%@", self.effect, produtEffectString];
            
        }else{
            productEffect = [NSString stringWithFormat:@"效果:%@", self.effect];;
        }
    }else{
        if (![DataCenter isNull:cellDataDic[@"produtEffect"]]) {
            
            NSString *produtEffectString = [cellDataDic[@"produtEffect"] stringByReplacingOccurrencesOfString:@"@@" withString:@","];
            productEffect = [NSString stringWithFormat:@"效果:%@", produtEffectString];
            
        }else{
            productEffect = @"";
        }
    }
    
//    if (![DataCenter isNull:cellDataDic[@"productType"]]) {
//        productInfo = [NSString stringWithFormat:@"产品类型:%@  %@", cellDataDic[@"productType"], productEffect];
//    }else{
//        productInfo = @"";
//    }
    
    cell.index     = indexPath.row;
    cell.taobaoURL = cellDataDic[@"productURL"];
    cell.productName.text  = productName;
    cell.productBrand.text = productBrand;
    cell.productInfo.text  = productEffect;
    
    [cell.productImage setImageWithURL:imageURL];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendDetailViewController *recommendDetailViewController = [[RecommendDetailViewController alloc] initWithNibName:@"RecommendDetailViewController" bundle:nil];
    recommendDetailViewController.ingredientsArray = [self.withKeyWord componentsSeparatedByString:@"$$"];
    [recommendDetailViewController setProductInfoByID:self.productListArray[indexPath.row][@"productID"]];
    [self.navigationController pushViewController:recommendDetailViewController animated:YES];
    
    [self httpRequestProductClicked:self.productListArray[indexPath.row][@"productID"]];
    
    NSString *productID = [NSString stringWithFormat:@"%@BySearch", self.productListArray[indexPath.row][@"productID"]];
    [MobClick event:@"productview" label:productID];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(_loadingMore && !_searching && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height + 10))) {
        _page += 1;
        [self searchWithPage:_page];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ([DataCenter shareData].deviceType == DeviceTypeiPhone5) {
        if (self.productListArray.count > 10) {
            
            if (scrollView.contentOffset.y - _contenty > 0) {
                
                self.searchTableView.frame = TableFramelong;
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.mainView.frame = CGRectMake(0, -70, kScreenWidth, kScreenHeight + 70);
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }else if (scrollView.contentOffset.y - _contenty < 0){
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                   self.mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight + 70);
                    
                } completion:^(BOOL finished) {
                    self.searchTableView.frame = TableFrameShort;
                }];
                
            }
        }
        _contenty = scrollView.contentOffset.y;
    }
    
}

#pragma mark - SearchViewDelegate

- (void)searchFieldDidTouched {
    [self showQuickSearchView:YES];
}

- (void)searchButtonDidTouched:(NSString *)keyWord {
    
    if (!_searching) {
        [self setupNewSearch];
        [self showQuickSearchView:NO];
        
        [self.stateLabel setupStateLabel:StateLabelModeLoading];
        self.productListArray = nil;
        [self.searchTableView reloadData];
        
        _page = 1;
        self.keyWord = [keyWord stringByReplacingOccurrencesOfString:@" " withString:@"@@"];
        [self searchWithPage:_page];
        [self getProductBrands];
    }
    DLog(@"%@", keyWord)
}

- (void)cancelButtonDidTouched {
    [self showQuickSearchView:NO];
}

- (void)backButtonDidTouched{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextDidChanged:(NSString *)text {
    
}

- (void)brandsButtonDidClicked:(UIButton *)btn {
    
        
        if (!_brandsButtonSelected) {
            _priceButtonSelected = NO;
            _typesButtonSelected = NO;
                        
            static NSString * const CellIdentifier = @"PhotoCell";
            
            ArrayDataSource *temp = [[ArrayDataSource alloc] initWithItems:self.productBrandsArray
                                                            cellIdentifier:CellIdentifier
                                                        configureCellBlock:^(id cell, id item) {
                                                            
                                                            UITableViewCell *tempCell    = cell;
                                                            tempCell.textLabel.textColor = GreenColor;
                                                            tempCell.textLabel.text      = item[@"productBrand"];
                                                            tempCell.textLabel.font      = [UIFont systemFontOfSize:18];
                                                            
                                                        }];
            self.brandTableDataSource = temp;

            
            if (self.brandTableDelegate == nil) {
                __weak typeof(self) blockSelf = self;
                
                ArrayDelegate *temp = [[ArrayDelegate alloc] initWithHeight:50
                                                           cellClickedBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                                                               UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                               [blockSelf filterCellDidTouched:cell.textLabel.text];
                                                           }];
                self.brandTableDelegate = temp;
            }
            
            [self showFilterView:YES];
            self.filterTableView.dataSource = self.brandTableDataSource;
            self.filterTableView.delegate   = self.brandTableDelegate;
            self.filterImageView.frame = CGRectMake(45, -10, 20, 10);
            [self.filterTableView reloadData];
        }else{
            [self showFilterView:NO];
        }
        _brandsButtonSelected = !_brandsButtonSelected;
    
}

- (void)typesButtonDidClicked:(UIButton *)btn{
    
    if (!_typesButtonSelected) {
        _priceButtonSelected  = NO;
        _brandsButtonSelected = NO;
        
        if (self.typesTableDataSource == nil) {
            static NSString * const CellIdentifier = @"PhotoCell";
            
            ArrayDataSource *temp = [[ArrayDataSource alloc] initWithItems:self.productTypesArray
                                                            cellIdentifier:CellIdentifier
                                                        configureCellBlock:^(id cell, id item) {
                                                            
                                                            UITableViewCell *tempCell    = cell;
                                                            tempCell.textLabel.textColor = GreenColor;
                                                            tempCell.textLabel.text      = item[@"productType"];
                                                            tempCell.textLabel.font      = [UIFont systemFontOfSize:18];
                                                            
                                                        }];
            self.typesTableDataSource = temp;
        }
        
        if (self.typesTableDelegate == nil) {
            __weak typeof(self) blockSelf = self;
            
            ArrayDelegate *temp = [[ArrayDelegate alloc] initWithHeight:50
                                                       cellClickedBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                                                           UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                           [blockSelf filterCellDidTouched:cell.textLabel.text];
                                                       }];
            self.typesTableDelegate = temp;
        }
        
        
        [self showFilterView:YES];
        self.filterTableView.dataSource = self.typesTableDataSource;
        self.filterTableView.delegate   = self.typesTableDelegate;
        self.filterImageView.frame = CGRectMake(45 + 105, -10, 20, 10);
        [self.filterTableView reloadData];
    }else{
        [self showFilterView:NO];
    }
    _typesButtonSelected = !_typesButtonSelected;
    
}

- (void)priceButtonDidClicked:(UIButton *)btn{
    
    if (!_priceButtonSelected) {
        _typesButtonSelected  = NO;
        _brandsButtonSelected = NO;
        
        if (self.priceTableDataSource == nil) {
            
            static NSString * const CellIdentifier = @"PhotoCell";
            
            ArrayDataSource *temp = [[ArrayDataSource alloc] initWithItems:self.productPriceArray
                                                            cellIdentifier:CellIdentifier
                                                        configureCellBlock:^(id cell, id item) {
                                                            
                                                            UITableViewCell *tempCell    = cell;
                                                            tempCell.textLabel.textColor = GreenColor;
                                                            tempCell.textLabel.text      = item;
                                                            tempCell.textLabel.font      = [UIFont systemFontOfSize:18];
                                                            
                                                        }];
            self.priceTableDataSource = temp;
        }
        
        if (self.priceTableDelegate == nil) {
            
            __weak typeof(self) blockSelf = self;
            
            ArrayDelegate *temp = [[ArrayDelegate alloc] initWithHeight:50
                                                       cellClickedBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                                                           UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                           [blockSelf filterCellDidTouched:cell.textLabel.text];
                                                       }];
            self.priceTableDelegate = temp;
        }
        
        [self showFilterView:YES];
        self.filterTableView.dataSource = self.priceTableDataSource;
        self.filterTableView.delegate   = self.priceTableDelegate;
        self.filterImageView.frame = CGRectMake(45 + 105 * 2, -10, 20, 10);
        [self.filterTableView reloadData];
    }else{
        [self showFilterView:NO];
    }
    _priceButtonSelected = !_priceButtonSelected;
    
    
}

- (void)filterCellDidTouched:(NSString *)text{
    
    [self.stateLabel setupStateLabel:StateLabelModeLoading];
    self.productListArray = nil;
    [self.searchTableView reloadData];
    
    if (_typesButtonSelected) {
        _typesButtonSelected = !_typesButtonSelected;
        
        if ([text isEqualToString:@"所有类型"]) {
            self.type = @"";
        }else{
            self.type = text;
        }
        
        [self.searchView.typesButton setTitle:text forState:UIControlStateNormal];
        
        self.typesTableDataSource = nil;
        self.typesTableDelegate   = nil;
        [self getProductBrands];
        
    }else if (_priceButtonSelected){
        if ([text isEqualToString:@"0~200"]) {
            self.priceLow  = @"0";
            self.priceHigh = @"200";
        }
        
        if ([text isEqualToString:@"200~400"]) {
            self.priceLow  = @"200";
            self.priceHigh = @"400";
        }
        
        if ([text isEqualToString:@"400~1000"]) {
            self.priceLow  = @"400";
            self.priceHigh = @"1000";
        }
        
        if ([text isEqualToString:@"1000+"]) { 
            self.priceLow  = @"1000";
            self.priceHigh = @"99999";
        }
        
        
        if ([text isEqualToString:@"所有价格"]) {
            self.priceLow  = @"0";
            self.priceHigh = @"99999";
        }
        
        [self.searchView.priceButton setTitle:text forState:UIControlStateNormal];
        _priceButtonSelected = !_priceButtonSelected;
        
        self.priceTableDataSource = nil;
        self.priceTableDelegate   = nil;
        [self getProductBrands];
        
    }else if (_brandsButtonSelected){
        _brandsButtonSelected = !_brandsButtonSelected;
        
        if ([text isEqualToString:@"所有品牌"]) {
            self.brands = @"";
        }else{
            self.brands = text;
        }
        [self.searchView.brandsButton setTitle:text forState:UIControlStateNormal];
        
        self.brandTableDataSource = nil;
        self.brandTableDelegate   = nil;
    
    }
    
    _page = 1;
    [self searchWithPage:_page];
    [self showFilterView:NO];
    
}

#pragma mark - ActivityViewDelegate

- (void)loadingDataDidFinished:(ActivityView *)activityView {
    [activityView removeFromSuperview];
}


@end
