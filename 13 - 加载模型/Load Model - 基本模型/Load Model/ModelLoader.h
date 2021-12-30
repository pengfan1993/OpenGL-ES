//
//  ModelLoader.h
//  Load Model
//
//  Created by pengfan on 2021/12/27.
//

#import <Foundation/Foundation.h>
#import "MatrixTransform.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModelLoader : NSObject

/// 初始化对象
/// @param filepath  文件路径
- (instancetype)initWithFilePath:(NSString *)filepath andContext:(ESContext *)eglContext;

/// 绘制内容
- (void)draw;
@end

NS_ASSUME_NONNULL_END
