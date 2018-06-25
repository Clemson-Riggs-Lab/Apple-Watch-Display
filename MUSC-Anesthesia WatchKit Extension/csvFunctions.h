//
//  csvFunctions.h
//  MUSC-Anesthesia
//
//  Created by Nicolas Threatt on 6/25/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

#ifndef __cplusplus
extern "C" {
#endif
    
int countRows();
string *readData(int csvRows);

#ifdef __cplusplus
}
#endif
