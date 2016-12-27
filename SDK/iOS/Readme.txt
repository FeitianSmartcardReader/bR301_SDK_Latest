2016/11/04
	
	Update sdk to 1.31.6, the latest version has add customer OEM string

2016/9/18
	Add auto pps
2016/4/18
	Update iOS SDK, add get reader type API - FtGetCurrentReaderType.
2016/2/24
	Fix SCardGetStatusChange() may (not always, but frequently) return “SCARD_E_READER_UNAVAILABLE” problem, new lib version is 1.31.2
2015/12/25
	Fix bug when create monitor to check reader/card slot status.
	Update lib version to 1.31.1, new lib add i386 and x64 support, the totally arch will included (armv7,armv7s,arm64,i386,x64)
2015/06/16
	Update iOS SDK
2014/12/03
	To get the latest bR301 SDK, you also can access github to get whole source code of bR301, the link is below:https://github.com/FeitianSmartcardReader
2014/10/8
	Add non-PCSC api
	Add comments(readerInterfaceDidChange/cardInterfaceDidDetach) of readerInterfaceDidChange in ReaderInterface.h
2014/8/15
	Add bR301, iR301, iPad casing reader support
	Modify source code to improve speed of get card/reader status of bR301
	Fixed bug when application access open/close session at same time, add mutex in source code
	Fixed minor bugs in arm64
	Fixed minor bugs in SCardListReader API
	Fixed minor bugs when running application in background
2014/05/12
	Support background running
	Fixed bug on iOS
2013/08/19
	
	Upgrade SDK, to support new bR301 which firmware is 2.0


2013/04/21
	Updated sample code
	Add developer Guide and FAQ
2013/02/20
	Library supported armv6/7/7s
