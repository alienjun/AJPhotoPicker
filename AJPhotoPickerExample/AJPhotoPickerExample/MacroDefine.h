//
//  MacroDefine.h
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h


#endif /* MacroDefine_h */


//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]