//
//  AddressBookViewController.m
//  AoMountain
//
//  Created by 贺乾龙 on 2017/5/8.
//  Copyright © 2017年 QL. All rights reserved.
//

#import "AddressBookViewController.h"
#import "PPGetAddressBook.h"
//#import "PersonDetailViewController.h"
#import "ChineseToPinyin.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface AddressBookViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{

    NSArray *_titleArr;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;

/** 所有人的信息*/
@property (nonatomic, strong) NSMutableArray *allPeopleArr;

/** 搜索*/
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView  *headView;

/** 搜索结果的数组*/
@property (nonatomic, strong) NSMutableArray *searchArr;

/** 判断是搜索状态还是编辑状态*/
@property (nonatomic, assign) BOOL isSearch;

/** 记录搜索的关键字*/
@property (nonatomic, strong) NSString  *searchKeyText;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    _titleArr = @[@"奥山集团办公信息化",@"我的部门",@"地产事业部",@"财务部门",@"行政部门"];
    [self createTableView];
    self.allPeopleArr = [NSMutableArray array];
}


-(UIView *)CreateHeadView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 54)];
        _headView.backgroundColor = [UIColor whiteColor];
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索联系人";
        _searchBar.delegate = self;
        _searchBar.frame = CGRectMake(15,7,SCREEN_WIDTH - 30,40);
        _searchBar.backgroundColor = [UIColor lightGrayColor];
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.layer.cornerRadius = 3;
        _searchBar.layer.masksToBounds = YES;
        [_searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_headView addSubview:self.searchBar];
        
    }
    return _headView;
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [self CreateHeadView];
    [self.view addSubview:_tableView];
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = nameKeys;
        [self.tableView reloadData];
        
        
        self.isSearch = NO;

        for (int i= 0; i<nameKeys.count; i++) {
            NSArray *arr = [addressBookDict objectForKey:nameKeys[i]];
            for (int j = 0; j< arr.count; j++) {
                PPPersonModel *model = [arr objectAtIndex:j];
                [self.allPeopleArr addObject:model];
            }
        }
        
        
        
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许奥山移动办公访问您的通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    


}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return 2;
    }else{
        return _keys.count +1;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        
        if (section == 0) {
            return _titleArr.count;
            
        }else{
            return self.searchArr.count;
        }
        
    }else{
        if (section == 0) {
            return _titleArr.count;
            
        }else{
            NSString *key = _keys[section-1];
            return [_contactPeopleDict[key] count];
            
        }

    }
    
}
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return _keys[section];
//}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *reuseIdentifier = @"cellres";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        cell.textLabel.text = _titleArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;

        return cell;
    }else{
        
        static NSString *reuseIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        if (self.isSearch) {
            
            PPPersonModel *pModel = self.searchArr[indexPath.row];
            cell.imageView.image = pModel.headerImage ? pModel.headerImage : [UIImage imageNamed:@"defult"];
            cell.imageView.layer.cornerRadius = 50/2;
            cell.imageView.clipsToBounds = YES;
            cell.textLabel.text = pModel.name;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;

        }else{
            NSString *key = _keys[indexPath.section-1];
            PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
            cell.imageView.image = people.headerImage ? people.headerImage : [UIImage imageNamed:@"defult"];
            cell.imageView.layer.cornerRadius = 50/2;
            cell.imageView.clipsToBounds = YES;
            cell.textLabel.text = people.name;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;

        }
        
        return cell;

    }
    

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else{
        
        if (self.isSearch) {
            PPPersonModel *people = self.searchArr[indexPath.row];
            NSLog(@"%@=======%@",people.name,people.mobileArray);
            
            
        }else{
            NSString *key = _keys[indexPath.section-1];
            PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
            NSLog(@"%@=======%@",people.name,people.mobileArray);

        }
        
        

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0010;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0.01;
    }else{
        return 15;

    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        UILabel *indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 120, 8)];
        if (self.isSearch) {
            indexLabel.text = @"搜索结果";

        }else{
            indexLabel.text = _keys[section -1];

        }
        indexLabel.font = [UIFont systemFontOfSize:15];
        indexLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:indexLabel];
        return view;

    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:NO];
    /**
     *  将系统自带的cancel修改为“取消”
     */
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //将要结束编辑模式
    [searchBar setShowsCancelButton:NO animated:NO];
    return YES;//yes 可以结束
}
//点击cancel 按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";//清空内容
    [searchBar resignFirstResponder];//取消第一响应
    self.isSearch = NO;

    //[self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
#pragma mark - 点击键盘搜索按钮事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length > 0) {
        self.isSearch = YES;

    }else{
        
        self.isSearch = NO;
        [searchBar resignFirstResponder];
 
    }
    
    
    [self.searchArr removeAllObjects];
    
    for (int i = 0; i<self.allPeopleArr.count; i++) {
        PPPersonModel *model = self.allPeopleArr[i];
        NSString *lowStr = [ChineseToPinyin pinyinFromChineseString:searchText withSpace:NO ];
        NSString *allStr =[ChineseToPinyin pinyinFromChineseString:model.name withSpace:NO ];
        //**********手机号模糊搜索*************//
        if (model.mobileArray.count == 1) {
            
            if ([model.mobileArray[0] rangeOfString:searchText].location != NSNotFound) {
                
                [self.searchArr addObject:model];

            }
            
        }else{
            
            for (int i= 0; i<model.mobileArray.count; i++) {
                if ([model.mobileArray[i] rangeOfString:searchText].location != NSNotFound) {
                    [self.searchArr addObject:model];

                }
  
            }
        
        
        }
        
        //**********姓模糊搜索*************//
        self.searchKeyText = [NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:searchText]];
        BOOL isHas = [allStr isEqualToString:lowStr];
        BOOL isPY = false;
        if ( lowStr || lowStr.length != 0) {
            
            isPY = [allStr hasPrefix:lowStr];
 
        }
        if (isHas) {
            //这种情况是精确查找。
            [self.searchArr addObject:model];//讲搜索后的数据添加到数组中
            
        }else{

            if (isPY && !isHas) {
                //迷糊查找
                [self.searchArr addObject:model];

            }
            
        }
        
    }
    [self.tableView reloadData];

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.searchBar resignFirstResponder];
}

-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}
@end
