//
//  disopWindow.m
//  call_lib
//
//  Created by test on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "disopWindow.h"
#import "Configuration.h"
#import "winscard.h"
#import "ft301u.h"



#ifdef __cplusplus
extern "C"{
#endif /* __cplusplus */
    LONG FtGetDevVer( SCARDCONTEXT hContext,char *firmwareRevision);
    
#ifdef __cplusplus
}
#endif


enum{
    dropListViewForSelected = 101,
    dropListViewForRun = 102,
    alertViewForConpany = 1001,
};

int touchInDropCount = 0;

@implementation disopWindow


@synthesize readInf=_readInf;
@synthesize powerOn;
@synthesize powerOff;
@synthesize sendCommand;
@synthesize runCommand;
@synthesize listData;

@synthesize getSerialNo;
//@synthesize getCardState;
@synthesize writeFlash;
@synthesize readFlash;
@synthesize showInfoData;



#pragma mark system

-(IBAction) backgroundClick:(id)sender
{
	[commandText resignFirstResponder];
}

- (IBAction)textFieldDone:(id)sender{
	[sender resignFirstResponder];
}

-(void) initFun
{
    if (showInfoView!= nil) {
        [self showInfoViewButtonPressed];
    }
    listData = [[NSArray alloc]initWithObjects:@"0084000004",@"0084000008",nil];
    //initialization 
    NSString* text = [NSString string];
    text = [[Configuration sharedConfiguration]getLangStringForKey:@"POWER_ON"];
    [powerOn setTitle:text forState:UIControlStateNormal];
    
    text = [[Configuration sharedConfiguration] getLangStringForKey:@"POWER_OFF"];
    [powerOff setTitle:text forState:UIControlStateNormal];
    
    
    ATR_Label.text =[[Configuration sharedConfiguration]getLangStringForKey:@"ATR_LABEL"];
    
    APDU_Label.text = [[Configuration sharedConfiguration]getLangStringForKey:@"APDU"];
    
    text = [[Configuration sharedConfiguration]getLangStringForKey:@"SEND_COMMAND"];
    [self.sendCommand setTitle:text forState:UIControlStateNormal];
    
    text = [[Configuration sharedConfiguration]getLangStringForKey:@"RUN_COMMAND"];
    [self.runCommand setTitle:text forState:UIControlStateNormal];
    
    powerOn.enabled = YES;
    [powerOn setBackgroundImage:[UIImage imageNamed:@"ON.png"] forState:UIControlStateNormal];
    powerOff.enabled = NO;
    [powerOff setBackgroundImage:[UIImage imageNamed:@"OFF.png"] forState:UIControlStateNormal];
    sendCommand.enabled = NO;
    [sendCommand setBackgroundImage:[UIImage imageNamed:@"SEND_OFF.png"] forState:UIControlStateNormal];
    
    runCommand.enabled = NO;
    commandText.enabled = NO;
    dropList.enabled = NO;
    
    //drop list 
    [dropList setBackgroundImage:[UIImage imageNamed:@"DROPLIST_OFF.png"] forState:UIControlStateNormal];
    commandText.text = @"";
    
    text = [[Configuration sharedConfiguration]getLangStringForKey:@"DIS_REV_INFO"];
    [self.runCommand setTitle:text forState:UIControlStateNormal];
    disTextView.text = text;
}

-(void) disNoAccDig
{

    [self initFun];
    
    [dropList setHidden:YES];
    [infoBut setHidden:YES];
    [sendCommand setHidden:YES];
    [powerOn setHidden:YES];
    [powerOff setHidden:YES];
    
    [getSerialNo setHidden:YES];
    
    [cardState setHidden:YES];
    [cardState setHidden:YES];
    [writeFlash setHidden:YES];
    [readFlash setHidden:YES];
    [cardState_Latel setHidden:YES];
    
    [commandText setHidden:YES];
    [ATR_Label setHidden:YES];
    [disTextView setHidden:YES];

    [APDU_Label setHidden:YES];
    [disResp setHidden:YES];
    [apduInput setHidden:YES];
    
    NSString* image = [[Configuration sharedConfiguration]getLangStringForKey:@"NO_TOKEN_IMAGE"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:image]];
   
}

-(void) disAccDig
{

    self.view.backgroundColor = [UIColor clearColor];
    NSString* imageName = [[Configuration sharedConfiguration]getLangStringForKey:@"BACK_BACKGROUND"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
   
    [dropList setHidden:NO];
    [infoBut setHidden:NO];
    [sendCommand setHidden:NO];

    [powerOn setHidden:NO];
    [powerOff setHidden:NO];
    
    [getSerialNo setHidden:NO];
    
    [cardState setHidden:NO];
    [cardState setHidden:NO];
    [writeFlash setHidden:NO];
    [readFlash setHidden:NO];
    [cardState_Latel setHidden:NO];
    
    [commandText setHidden:NO];
    [ATR_Label setHidden:NO];
    [disTextView setHidden:NO];
    
    [APDU_Label setHidden:NO];
    [disResp setHidden:NO];
    [apduInput setHidden:NO];
   
}


#pragma mark -
#pragma mark ReaderInterfaceDelegate Methods
- (void) cardInterfaceDidDetach:(BOOL)attached
{
   
    
    if (attached) {
        NSLog(@"CardInterfaceDidChange>>cardattach");
        [cardState setOn:TRUE ];
        //powerOn.enabled = YES;
        //powerOff.enabled = NO;
        
    }
    else{
        NSLog(@"CardInterfaceDidChange>>carddisattach");
        [cardState setOn:FALSE ];
        //powerOn.enabled = YES;
        //powerOff.enabled = NO;
        
    }
    
}
- (void) readerInterfaceDidChange:(BOOL)attached
{
   
    if (attached) {
        [self performSelectorOnMainThread:@selector(disAccDig) withObject:nil waitUntilDone:YES];
        NSLog(@"readerInterfaceDidChange>>disAccDig");
    }
    else{
        [self performSelectorOnMainThread:@selector(disNoAccDig) withObject:nil waitUntilDone:YES];
        NSLog(@"readerInterfaceDidChange>>disNoAccDig");
    }

    
}


#pragma mark -

- (void )viewDidUnLoad{
    /*退出程序执行*/
   // SCardReleaseContext(gContxtHandle);
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    showInfoView = nil;
    [self disNoAccDig];
    
    _readInf = [[ReaderInterface alloc]init];
    
    [_readInf setDelegate:self];

    
    [cardState setEnabled:false];

     SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    
    [super viewDidLoad];
}

-(void) show_iR301_Info
{
    char firmwareRevision[32]={0};
   // char hardwareRevision[32]={0};
    char libVersion[32]={0};
    NSString *title=[[Configuration sharedConfiguration]getLangStringForKey:@"DEVI_INFOR"];
    NSString *company = [[Configuration sharedConfiguration]getLangStringForKey:@"FACT_INFOR"];
    FtGetLibVersion(libVersion);
    NSString *softversion=[[Configuration sharedConfiguration]getLangStringForKey:@"SOFT_VER"];
    NSString *SDKVersion=[NSString stringWithFormat:@"%@%s",[[Configuration sharedConfiguration]getLangStringForKey:@"SDK_VER"],libVersion];
    FtGetDevVer(0,firmwareRevision);
   // NSString *hardversion=[NSString stringWithFormat:@"%@%s",[[Configuration sharedConfiguration]getLangStringForKey:@"HARD_VER"],hardwareRevision];
    NSString *fix =[NSString stringWithFormat:@"%@%s",[[Configuration sharedConfiguration]getLangStringForKey:@"FIX_VER"],firmwareRevision];
    
    showInfoData = [[NSArray alloc] initWithObjects:title,@"",company,softversion,SDKVersion,fix,nil];
    
    
}

-(IBAction) showInfo
{
    if (showInfoView != nil) {
        [self showInfoViewButtonPressed];
        return;
    }
    showInfoView = [[UIView alloc] init];
    showInfoView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    CGRect frame = CGRectMake(12.0f, 50.0f, 296.0f, 340.0f);
    showInfoView.frame = frame;
    showInfoView.layer.masksToBounds = YES;
    showInfoView.layer.cornerRadius = 6.0;
    showInfoView.layer.borderWidth = 1.0;
    showInfoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    frame = CGRectMake(20.0f, 50.0f, 245.0f, 180.0f);
    [self show_iR301_Info];
    UITableView *selectFileList = [[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
    selectFileList.tag = alertViewForConpany;
    [selectFileList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    selectFileList.allowsSelection=NO;
    [selectFileList setDelegate:self];
    [selectFileList setDataSource:self];
    [showInfoView addSubview:selectFileList];
    
    UIButton *showInfoDoButton = [ UIButton buttonWithType:UIButtonTypeRoundedRect];
    showInfoDoButton.frame = CGRectMake(20.0f, 260.0f, 245.0f, 40.0f);
    [showInfoDoButton setTitle:@"OK" forState:UIControlStateNormal];
    [showInfoDoButton addTarget:self action:@selector(showInfoViewButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [showInfoView addSubview:showInfoDoButton];
    [self.view addSubview:showInfoView];
    
}

-(void)showInfoViewButtonPressed
{
    [showInfoView removeFromSuperview];
    [showInfoView release];
    showInfoView=nil;
}

-(IBAction)limitCharacter:(id)sender
{
	const char *buf = [[commandText text] UTF8String];
    
    NSString* AlertWarning = [[Configuration sharedConfiguration]getLangStringForKey:@"AlertWarning"];

    NSString *AlertMessage = [[Configuration sharedConfiguration] getLangStringForKey:@"AlertMessage"];
    NSString *AlertOK = [[Configuration sharedConfiguration]getLangStringForKey:@"AlertOK"];
    
	for (int i = 0; i < [commandText.text length]; i++) 
	{		
		if ((buf[i] > 0x46 || buf[i] < 0x30) || buf[i] == 0x40) {
			UIAlertView *WaringStr = [[UIAlertView alloc] initWithTitle:AlertWarning
																message:AlertMessage 
															   delegate:nil 
													  cancelButtonTitle:AlertOK
													  otherButtonTitles:nil];
			[WaringStr show];
			[WaringStr release];
			break;
		}
	}
}


#pragma mark operation ----
-(IBAction) powerOnFun:(id)sender
{   
    disTextView.text = @"";
	LONG iRet = 0;
    DWORD dwActiveProtocol = -1;
    char mszReaders[128] = "";
    DWORD dwReaders = -1;
  
   
    iRet = SCardListReaders(gContxtHandle, NULL, mszReaders, &dwReaders);
    if(iRet != SCARD_S_SUCCESS)
    {
        NSLog(@"SCardListReaders error %08x",iRet);
    }

    iRet = SCardConnect(gContxtHandle,mszReaders,SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1,&gCardHandle,&dwActiveProtocol);
	if (iRet != 0) {
        ATR_Label.text = [[Configuration sharedConfiguration]getLangStringForKey:@"ATR_LABEL"];

   
        disTextView.text = [[Configuration sharedConfiguration] getLangStringForKey:@"SEND_LABEL"];
        
        NSString* disText = disTextView.text;
        disText = [disText stringByAppendingString:[[Configuration sharedConfiguration]getLangStringForKey:@"CONN_LABEL_NO"]];
        disTextView.text = disText;
        
        powerOn.enabled = YES;

	}
	else {
        unsigned char patr[33];
        DWORD len = sizeof(patr);
        iRet = SCardGetAttrib(gCardHandle,NULL, patr, &len);
        if(iRet != SCARD_S_SUCCESS)
        {
            NSLog(@"SCardGetAttrib error %08x",iRet);
        }
        
		NSMutableData *tmpData = [NSMutableData data];
        [tmpData appendBytes:patr length:len];
        
        NSString* dataString= [NSString stringWithFormat:@"%@",tmpData];
        NSRange begin = [dataString rangeOfString:@"<"];
        NSRange end = [dataString rangeOfString:@">"];
        NSRange range = NSMakeRange(begin.location + begin.length, end.location- begin.location - 1);
        dataString = [dataString substringWithRange:range];

        ATR_Label.text = [NSString stringWithFormat:@"ATR:%@",dataString];
        

        disTextView.text = [[[Configuration sharedConfiguration]getLangStringForKey:@"SEND_LABEL"]stringByAppendingString:@"\n"];
    
        DWORD pcchReaderLen;
       
        len = sizeof(patr);
        pcchReaderLen = sizeof(mszReaders);
     
        NSString* disText = disTextView.text;
        disText = [[disText stringByAppendingString:[[Configuration sharedConfiguration]getLangStringForKey:@"CONN_LABEL_OK"]]stringByAppendingString:@"\n"];
        disTextView.text = disText;

        powerOn.enabled = NO;
        [powerOn setBackgroundImage:[UIImage imageNamed:@"OFF.png"] forState:UIControlStateNormal];
        
        self.powerOff.enabled = YES;
        [powerOff setBackgroundImage:[UIImage imageNamed:@"ON.png"] forState:UIControlStateNormal];
        
 
        //active command
        powerOff.enabled = YES;
        [powerOff setBackgroundImage:[UIImage imageNamed:@"ON.png"] forState:UIControlStateNormal];
        sendCommand.enabled =YES;
        runCommand.enabled = YES;
        commandText.enabled = YES;
        dropList.enabled = YES;
        [dropList setBackgroundImage:[UIImage imageNamed:@"DROPLIST_ON.png"] forState:UIControlStateNormal];
        [dropList setTitle:@"" forState:nil];
    }
    
}


/*int  mxGetTickCount()
{
    
    int timeTick;
    
    mach_timebase_info_data_t info;
    
    uint64_t machineTime;
    
    mach_timebase_info(&info);
    
    machineTime =mach_absolute_time();
    
    timeTick = machineTime * info.numer / info.denom /1000000LL;
    
    return timeTick;
    
}*/


#import<mach/mach_time.h>
#include  <pthread.h>
-(IBAction) sendCommandFun:(id)sender
{
	LONG iRet = 0;
	unsigned  int capdulen;
	unsigned char capdu[512];
	unsigned char resp[512];
	unsigned int resplen = sizeof(resp) ;

	NSString* tempBuf = [NSString string];
    
    if(powerOn.enabled == YES)
        return;
    
    if(([commandText.text length] == 0 )  && [sender isKindOfClass:[UIButton class]] )
    {   
        NSString* disText = disTextView.text;
        disText = [[disText stringByAppendingString:[[Configuration sharedConfiguration]getLangStringForKey:@"SEND_APDU"]]stringByAppendingString:@"\n"];
        disTextView.text = disText;
              
        disText = disTextView.text;
        disText = [[disText stringByAppendingString:[[Configuration sharedConfiguration]getLangStringForKey:@"REC_APDU"]]stringByAppendingString:@"\n"];
        disTextView.text = disText;
        [self moveToDown];
        
        return;
    }
    else
    {
        if([commandText.text length] < 5 )
        {
            disTextView.text = @"Invalid APDU.";
            return;
        }
    }

    
    if([sender isKindOfClass:[NSString class]])
    {
        tempBuf = (NSString*) sender;
    }else
    {
        tempBuf = [commandText text];
    }
    NSString* comand = [tempBuf stringByAppendingString:@"\n"];
    const char *buf = [tempBuf UTF8String];
	NSMutableData *data = [NSMutableData data];
	uint32_t len = strlen(buf);
	
    //to hex
	char singleNumberString[3] = {'\0', '\0', '\0'};
	uint32_t singleNumber = 0;
	for(uint32_t i = 0 ; i < len; i+=2)
	{
		if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
		{
			singleNumberString[0] = buf[i];
			singleNumberString[1] = buf[i + 1];
			sscanf(singleNumberString, "%x", &singleNumber);
			uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
			[data appendBytes:(void *)(&tmp) length:1];
		}
		else
		{
			break;
		}
	}
     for (int kkk=0; kkk<1; kkk++) {
	[data getBytes:capdu];
    resplen = sizeof(resp);
	capdulen = [data length];
    SCARD_IO_REQUEST pioSendPci;
    
    iRet=SCardTransmit(gCardHandle,&pioSendPci, (unsigned char*)capdu, capdulen,NULL,resp, &resplen);
	if (iRet != 0) {
        
		NSLog(@"ERROR SCardTransmit ret %08X.", iRet);
		NSMutableData *tmpData = [NSMutableData data];
		[tmpData appendBytes:resp length:capdulen*2];
        if(powerOn.enabled == NO){ 

            NSString* sending = [[Configuration sharedConfiguration] getLangStringForKey:@"SEND_DATA"];
            NSString* sendComand = [NSString stringWithFormat:
                                    @"%@：%@",sending,comand];
            NSString* disText = disTextView.text;
            disText = [disText stringByAppendingString:sendComand];
            
            NSString* returnData = [[Configuration sharedConfiguration]getLangStringForKey:@"RETURN_DATA"];
            
            NSString* errMSG = [NSString stringWithFormat:
                                    @"%@：%08X ",@"ERROR SCardTransmit ret",iRet];
            
            returnData = [returnData stringByAppendingString:errMSG];
            returnData = [returnData stringByAppendingString:@"\n"];
            disText = [disText stringByAppendingString:returnData];
            disTextView.text = disText;
            [self moveToDown];
            
            disText = disTextView.text;
            disTextView.text = disText;
        }

		sendCommand.enabled = YES;
	}
	else {         

		NSMutableData *tmpData = [NSMutableData data];
		[tmpData appendBytes:capdu length:capdulen*2];
        
        NSString* sending = [[Configuration sharedConfiguration] getLangStringForKey:@"SEND_DATA"];
        NSString* sendComand = [NSString stringWithFormat:
                                @"%@：%@",sending,comand];
        NSString* disText = disTextView.text;
        disText = [disText stringByAppendingString:sendComand];
        disTextView.text = disText;
         
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        
        NSString* recData = [NSString stringWithFormat:@"%@", RevData];
        NSRange begin = [recData rangeOfString:@"<"];
        NSRange end = [recData rangeOfString:@">"];
        NSRange start = NSMakeRange(begin.location + begin.length, end.location - begin.location-1);
        recData = [recData substringWithRange:start];
        recData = [recData stringByAppendingString:@"\n"];
        NSString* returnData = [[Configuration sharedConfiguration]getLangStringForKey:@"RETURN_DATA"];
        recData = [NSString stringWithFormat:@"%@：%@",returnData,recData];
        disText = disTextView.text;
        disText = [disText stringByAppendingString:recData];
        disTextView.text = disText;
        [self moveToDown];

		sendCommand.enabled = YES;
	}
          }
   
    [self moveToDown];
     
       
}

-(void) disPowerOff
{
    ATR_Label.text = [[Configuration sharedConfiguration]getLangStringForKey:@"ATR_LABEL"];
    
    disTextView.text = [[[Configuration sharedConfiguration]getLangStringForKey:@"SEND_LABEL_CLOSE"] stringByAppendingString:@"\n"];
    
    
    disTextView.text = [disTextView.text stringByAppendingString:[[Configuration sharedConfiguration]getLangStringForKey:@"CLOSE_CONN_OK"]];
    
    self.powerOn.enabled = YES;
    [self.powerOn setBackgroundImage: [UIImage imageNamed:@"ON.png"] forState:UIControlStateNormal];
    
    powerOff.enabled = NO;
    [self.powerOff setBackgroundImage: [UIImage imageNamed:@"OFF.png"] forState:UIControlStateNormal];
    sendCommand.enabled = NO;

    commandText.enabled = NO;
    commandText.text = @"";
    runCommand.enabled = NO;
    dropList.enabled = NO;
    [dropList setBackgroundImage:[UIImage imageNamed:@"DROPLIST_OFF.png"] forState:UIControlStateNormal];
}

-(IBAction) powerOffFun:(id)sender
{
    disTextView.text = @"";
	LONG iRet = 0;
    iRet = SCardDisconnect(gCardHandle,SCARD_UNPOWER_CARD);
	if (iRet != 0) {
		disTextView.text = [NSString stringWithFormat:@"ERROR PowerOff ret %d.\n", iRet];
		powerOff.enabled = YES;
		powerOn.enabled = YES;
	}
	else 
    {
        [self disPowerOff];
	}
}

-(void) moveToDown{
    NSRange range;

    range = NSMakeRange ([[disTextView text]length], 0);
    [disTextView scrollRangeToVisible: range];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)dealloc {
	//[_accessoryList release];
	[super dealloc];
}


/*- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if(alertViewForConpany == alertView.tag) {
        char firmwareRevision[32]={0};
        char hardwareRevision[32]={0};
        char libVersion[32]={0};
        float x = [[UIScreen mainScreen] bounds].size.width;
        alertView.frame = CGRectMake((x-300)*0.5, 50, 300, 350);
        
        UILabel* title = [[[UILabel alloc]initWithFrame:CGRectMake(0, 30, 300, 30)] autorelease];
        
        //title.text =
        title.text = [[Configuration sharedConfiguration]getLangStringForKey:@"DEVI_INFOR"];
        title.textAlignment = UITextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        [alertView addSubview:title];
        
        UILabel* company =[[[UILabel alloc]initWithFrame:CGRectMake(20, 80, 300, 30)] autorelease];
        //company.text =
        company.text = [[Configuration sharedConfiguration]getLangStringForKey:@"FACT_INFOR"];
        company.textAlignment = UITextAlignmentLeft;
        company.textColor = [UIColor whiteColor];
        [company setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        company.backgroundColor = [UIColor clearColor];
        [alertView addSubview:company];
        
        UILabel* soft = [[[UILabel alloc]initWithFrame:CGRectMake(20, 110, 300, 30)] autorelease];
        //soft.text =
        soft.text = [[Configuration sharedConfiguration]getLangStringForKey:@"SOFT_INFOR"];
        soft.textAlignment = UITextAlignmentLeft;
        soft.textColor = [UIColor whiteColor];
        [soft setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        soft.backgroundColor = [UIColor clearColor];
        [alertView addSubview:soft];
        
        UILabel* hard = [[[UILabel alloc]initWithFrame:CGRectMake(20, 140, 300, 30)] autorelease];
        FtGetDevVer(0,firmwareRevision, hardwareRevision);
        
        hard.text = [NSString stringWithFormat:@"%@%s",[[Configuration sharedConfiguration]getLangStringForKey:@"HARD_VER"],hardwareRevision];
        hard.textAlignment = UITextAlignmentLeft;
        hard.textColor = [UIColor whiteColor];
        [hard setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        hard.backgroundColor = [UIColor clearColor];
        [alertView addSubview:hard];
        
        UILabel* fix = [[[UILabel alloc]initWithFrame:CGRectMake(20, 170, 300, 30)] autorelease];
        //fix.text =
        fix.text = [NSString stringWithFormat:@"%@%s",[[Configuration sharedConfiguration]getLangStringForKey:@"FIX_VER"],firmwareRevision];
        
        fix.textAlignment = UITextAlignmentLeft;
        fix.textColor = [UIColor whiteColor];
        [fix setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        fix.backgroundColor = [UIColor clearColor];
        [alertView addSubview:fix];
        
        UILabel* softV = [[[UILabel alloc]initWithFrame:CGRectMake(20, 200, 300, 30)] autorelease];
        //softV.text =
        //soft.text = [[Configuration sharedConfiguration]getLangStringForKey:@"SOFT_VER"];
        FtGetLibVersion(libVersion);
        
        soft.text = [NSString stringWithFormat:@"%@%s",[[Configuration sharedConfiguration]getLangStringForKey:@"SOFT_VER"],libVersion];
        softV.textAlignment = UITextAlignmentLeft;
        softV.textColor = [UIColor whiteColor];
        [softV setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        softV.backgroundColor = [UIColor clearColor];
        [alertView addSubview:softV];
        
        
        UIView* obj = [[alertView subviews]objectAtIndex:3];
        CGRect fr = obj.frame;
        fr.origin.y = fr.origin.y + 240;
        fr.origin.x = (alertView.frame.size.width -fr.size.width)* 0.5;
        obj.frame = fr;
    }
}
*/

-(IBAction)runBtnPressed:(id)sender
{    
    touchInDropCount++;
    if(touchInDropCount%2)
    {
        if([self.view viewWithTag:dropListViewForRun])
        {
            ((UITableView*)[self.view viewWithTag:dropListViewForRun]).hidden = NO;
        }
        else
        {
            UITableView* listView;
            CGRect fr = runCommand.frame;
            
            listView=[[UITableView alloc]initWithFrame:
                      CGRectMake(10,188 + fr.size.height ,300,78)];
            listView.dataSource = self;
            
            listView.delegate=self;
            
            listView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:listView];
            listView.tag = dropListViewForRun; 
            [listView release];
        }
    }
    else
    {
        ((UITableView*)[self.view viewWithTag:dropListViewForRun]).hidden = YES;
        
    }
        
}

#pragma mark- UITableViewDataSource Methods
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIdentifier];
        if (cell == nil) {  
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: SimpleTableIdentifier] autorelease];
        }
        
        if (tableView.tag == alertViewForConpany) {
            if (indexPath.row == 0) {
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            cell.textLabel.text = [showInfoData objectAtIndex:indexPath.row];
            
        }else{
            cell.textLabel.text = [listData objectAtIndex:indexPath.row];
        }
        
        return cell;
    }
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == alertViewForConpany) {
        return showInfoData.count;
    }else{
        return listData.count;
    }
}
#pragma mark- UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == alertViewForConpany) {
        return 25;
    }else{
        return 30;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == alertViewForConpany) {
        return;
    }
    touchInDropCount++;
    if(dropListViewForRun == tableView.tag)
    {
        runCommand.enabled = YES;
        tableView.hidden = YES;
        NSString* command = [listData objectAtIndex:indexPath.row];
        commandText.text = command;
        [self sendCommandFun:command];
    }
    else if(dropListViewForSelected == tableView.tag)
    {
        dropList.enabled = YES;
        commandText.text = [listData objectAtIndex:indexPath.row];
        tableView.hidden = YES;
    }
    
}

#pragma mark Hardware serial number
-(IBAction)getSerialNumber:(id)sender
{

   char buffer[20] = {0};
    LONG iRet = FtGetSerialNum(0, sizeof(buffer), buffer);
        
        
    if(iRet != 0 )
        disTextView.text = @"Get serial number ERROR.";
    else {
        disTextView.text = [NSString stringWithFormat:@"%s", buffer];
    }

}

#pragma mark W/R flash
-(IBAction)ftWriteFlash:(id)sender
{
    LONG iRet;
    static BOOL w_flag = FALSE;
    unsigned char buffer[255] ={0};
    w_flag = !w_flag;
    if (w_flag) {
        for (int i=0; i< 255; i++) {
             buffer[i]= i;
        }
        iRet = FtWriteFlash(0, 0 ,255, buffer); 
    }
    else {
        iRet = FtWriteFlash(0, 0,20, buffer); 
    }
   
    if(iRet != 0 )
        disTextView.text = @"Write Flash ERROR.";
    else {
        disTextView.text = @"Write Flash SUCCESS.";;
    }
}

-(IBAction)ftReadFlash:(id)sender
{
    unsigned char buffer[255] ={0};
   
    LONG iRet = FtReadFlash(0, 0,255, buffer);
    

    if(iRet != 0 )
        disTextView.text = @"Read Flash ERROR.";
    else {
        NSMutableData *tmpData = [NSMutableData data];
        [tmpData appendBytes:buffer length:255];
        
        NSString* dataString= [NSString stringWithFormat:@"%@",tmpData];
        NSRange begin = [dataString rangeOfString:@"<"];
        NSRange end = [dataString rangeOfString:@">"];
        NSRange range = NSMakeRange(begin.location + begin.length, end.location- begin.location - 1);
        dataString = [dataString substringWithRange:range];
        
        disTextView.text = [NSString stringWithFormat:@"FALSH:\n%@",dataString];
    }

}
@end

