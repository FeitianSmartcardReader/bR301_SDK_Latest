//
//  Utils.c
//  bR301_by_Swift
//
//  Created by 彭珊珊 on 15/12/1.
//  Copyright © 2015年 shanshan. All rights reserved.
//

#include "Utils.h"
#include <ctype.h>

/* remarks     : string to hex */
void StrToHex(unsigned char *pbDest, char *szSrc, unsigned int dwLen)
{
    char h1,h2;
    unsigned char s1,s2;
    
    for (int i=0; i<dwLen; i++)
    {
        h1 = szSrc[2*i];
        h2 = szSrc[2*i+1];
        
        s1 = toupper(h1) - 0x30;
        if (s1 > 9)
            s1 -= 7;
        
        s2 = toupper(h2) - 0x30;
        if (s2 > 9)
            s2 -= 7;
        
        pbDest[i] = s1*16 + s2;
    }
}

/* remarks     : hex to string */
void HexToStr(char *szDest, unsigned char *pbSrc, unsigned int dwLen)
{
    char	ddl,ddh;
    
    for (int i=0; i<dwLen; i++)
    {
        ddh = 48 + pbSrc[i] / 16;
        ddl = 48 + pbSrc[i] % 16;
        if (ddh > 57)  ddh = ddh + 7;
        if (ddl > 57)  ddl = ddl + 7;
        szDest[i*2] = ddh;
        szDest[i*2+1] = ddl;
    }
    
    szDest[dwLen*2] = '\0';
}
