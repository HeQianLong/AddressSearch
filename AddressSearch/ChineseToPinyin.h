/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */
/**
  *update by wm on 05-04-2016
 */
#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}
/**
 @func          汉字转全拼，小写输出
 @param string  需要传唤的汉字
 @param space   转换后是否带空格
 @return        转换后的全拼
 */
+ (NSString *) pinyinFromChineseString:(NSString *)string withSpace:(BOOL)space;

/*
 汉字首字母拼音输出，大写输出
 */
+ (char) sortSectionTitle:(NSString *)string;

/**
 @func          汉字转首字母简拼，小写输出
 @param string  需要传唤的汉字
 @return        转换后的简拼
 */
+ (NSString *) letterPinyinFromChineseString:(NSString *)string;
@end