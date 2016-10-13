//
//  KFMemoryProfilerResidentMemoryInBytes.h
//  kugou
//
//  Created by moLiang on 2016/8/11.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    /**
     @return current resident memory from mach task info
     */
    uint64_t KFMemoryProfilerResidentMemoryInBytes(void);
    
    uint64_t KFMemoryTotalMemorySize(void);
    
    uint64_t KFCpuUsage(void);
    
#ifdef __cplusplus
}
#endif
