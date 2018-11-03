For development based on Feitian bR301, The API please using PC/SC API or WINSCARD API.

The open source demo code can found in:
https://github.com/FeitianSmartcardReader/R301/tree/master/Sample%20Code

For Linux and Mac OS X, now only support cable connection, cannot usng bluetooth wireless connection with these platform.

For mobile platform, the open source demo code can found in:
https://github.com/FeitianSmartcardReader/bR301_Android
https://github.com/FeitianSmartcardReader/bR301_iOS

[Notice]
	Before using bR301 driver, please make sure your reader firmware is latest one. The driver support bR301 firmware 2.0+ 
	If you are using Windows 10, please make sure the version is not 1703, we found a compitable issue in 1703, and it solved by Microsoft in 1803. 

The current reader only support 1 bR301 with bluetooth connection on PC, please keep one bR301 with bluetooth connection on Windows.

Changelog:
2015/11/10
	Fixed big data problem
	Update user manual, when do uninstall driver, please through device manager to uninstall
2015/11/02
	Fixed using WINSCARD API to do communication, scardconnect error problem,error code 0x8010001C,0x80100065,
	Fixed bug when card in the communication process, and driver no response problem
	Package driver to EXE
2015/10/22
	Change driver folder to ZIP, because when download from github, the github will delete return key in INF file, after then customer install driver will warning driver not sign 
2015/10/20
	Update driver file, fixed T1 card support and timeout issue.
2015/10/19
	Upload bR301 PC resource into github, included bR301 bluetooth driver and PC SDK
	The driver support windows 7/8/10, also x86 and x64 tablet supported already.
