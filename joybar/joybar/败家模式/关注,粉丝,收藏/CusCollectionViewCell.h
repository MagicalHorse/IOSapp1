//
//  CusCollectionViewCell.h
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol cancleCollectDelegate <NSObject>
//
//-(void)cancelCollect;
//
//@end
@interface CusCollectionViewCell : UICollectionViewCell

//@property (nonatomic ,assign)id<cancleCollectDelegate>delegate;

-(void)setCollectionData:(NSDictionary *)dic andHeight:(NSInteger)height;

@end
