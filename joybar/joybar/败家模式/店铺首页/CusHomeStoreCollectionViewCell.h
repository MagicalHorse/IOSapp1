//
//  CusHomeStoreCollectionViewCell.h
//  joybar
//
//  Created by 123 on 15/7/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol handleCollectDelegate <NSObject>

-(void)collectHandle;

@end

@interface CusHomeStoreCollectionViewCell : UICollectionViewCell

-(void)setCollectionData:(NSDictionary *)dic andHeight:(NSInteger)height;

@property (nonatomic ,assign) id<handleCollectDelegate> delegate;

@end
