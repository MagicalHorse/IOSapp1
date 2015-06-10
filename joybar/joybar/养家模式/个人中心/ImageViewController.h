
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CameraDelgeate <NSObject>
@optional
-(void)dismissCamrea:(UIImage *)image;
@end

@interface ImageViewController : BaseViewController
- (instancetype)initWithImage:(UIImage *)image;
@property (nonatomic, weak) id <CameraDelgeate> delegate;
@end
