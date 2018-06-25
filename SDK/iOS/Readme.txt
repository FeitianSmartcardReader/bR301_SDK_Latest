2018/06/25
	Update lib to 1.32.5
	1.32.5 - Solved a timeout issue, the behave is when send command to card to generate key pair in smart card, normally, it takes couple seconds, at this time, the SDK got mess data from reader, now add code to handle the mess data
2018/03/19
	Update lib to 1.32.4
	1.32.4 - After updating to latest iOS, if open app first, after insert reader, then the reader communication give errors. 1.32.4 fix this issue.
2017/05/24
	Update lib to 1.32.3
	1.32.3 - Fix bR301 issue when switch App to background, at this time do replug card, the lib doesn't response in time.
	       - Add customer OEM API to switch auto turn off function, the function is no communication data between App with reader, then the reader will do turn off automatically
	       - Fix bug when call ScardStatus API get wrong reader name, now make it same as SCardListReaders “FT smartcard reader”
2017/02/22
	Update to 1.32.0
	1.31.9 - Fix bug while in close session, the behave is using bluetooth printer with bR301 and iR301, the reader session will close.
	1.32.0 - Fix block issue while in reading data from reader, the behave is random get 0x80100016 error, the error only happen with iR301 series
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
