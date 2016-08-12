//
//  WPDataModel.h
//  wxDemo
//
//  Created by 吴鹏 on 16/8/3.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PASSSTYPE)
{
    PASSSTYPE_STR = 0,
    PASSSTYPE_IMG ,
};

typedef NS_ENUM(NSInteger,FROMORTO)
{
    TO = 0 ,
    FROM ,
    
};

@interface WPDataModel : NSObject

@property (nonatomic) PASSSTYPE stype;
@property (nonatomic) FROMORTO fromOrto;
@property (nonatomic , strong) id content;
@property (nonatomic , assign) float contentWidth;
@property (nonatomic , assign) float contentHeight;


@end
