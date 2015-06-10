//
//  SelectCityViewController.m
//  joybar
//
//  Created by 123 on 15/5/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray * dataSource, * dataBase;


@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarViewAndTitle:@"城市列表"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    //改变索引的颜色
    self.tableView.sectionIndexColor = [UIColor blueColor];
    //改变索引选中的背景颜色
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor orangeColor];
    //索引数组
    _dataSource = [[NSMutableArray alloc] init] ;
    //tableview 数据源
    _dataBase = [[NSMutableArray alloc] init] ;
    
//    //初始化数据
//    for(char c = 'A'; c <= 'Z'; c++ )
//    {
//        [_dataSource addObject:[NSString stringWithFormat:@"%c",c]];
//        [_dataBase addObject:[NSString stringWithFormat:@"%c",c]];
//        [_dataBase addObject:[NSString stringWithFormat:@"%c",c]];
//        [_dataBase addObject:[NSString stringWithFormat:@"%c",c]];
//    }
    [self getCityData];
}

-(void)getCityData
{
    [HttpTool postWithURL:@"Common/GetCityList" params:nil success:^(id json) {
        NSLog(@"%@",json);
        
        self.dataBase = [json objectForKey:@"data"];
        
        for (int i=0; i<self.dataBase.count; i++)
        {
            NSString *key = [[self.dataBase objectAtIndex:i] objectForKey:@"key"];
            [self.dataSource addObject:key];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _dataSource;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,index);
    
    for(NSString *character in _dataSource)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}


//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_dataSource count];
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dataSource objectAtIndex:section];
}

//返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.dataBase objectAtIndex:section] objectForKey:@"cities"] count];
}

//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"%@",[[[self.dataBase objectAtIndex:indexPath.section]objectForKey:@"cities"]objectAtIndex:indexPath.row]);
    
    cell.textLabel.text = [[[[self.dataBase objectAtIndex:indexPath.section] objectForKey:@"cities"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityID = [[[[self.dataBase objectAtIndex:indexPath.section] objectForKey:@"cities"] objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString *cityName =[[[[self.dataBase objectAtIndex:indexPath.section] objectForKey:@"cities"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    if (self.cityBlock)
    {
        self.cityBlock (cityID,cityName);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
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
