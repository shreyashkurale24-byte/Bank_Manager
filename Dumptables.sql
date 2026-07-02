-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: testdata
-- ------------------------------------------------------
-- Server version	5.7.43-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `airlimit`
--

DROP TABLE IF EXISTS `airlimit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airlimit` (
  `recno` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `method` varchar(10) COLLATE utf8_unicode_ci DEFAULT 'AIR',
  `trdate` int(11) DEFAULT NULL,
  `prodguid` varchar(36) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'hsn in case of gst',
  `amt1` decimal(18,2) DEFAULT '0.00',
  `amt2` decimal(18,2) DEFAULT '0.00',
  `amt3` decimal(18,2) DEFAULT '0.00',
  `entryby` char(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` char(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amt4` decimal(18,2) DEFAULT '250000.00',
  `amt5` decimal(18,2) DEFAULT '300000.00',
  `amt6` decimal(18,2) DEFAULT NULL COMMENT 'tdsliit 15h for supersenior',
  PRIMARY KEY (`recno`),
  UNIQUE KEY `ms050key1` (`method`,`trdate`,`prodguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='AIR limits ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airlimit`
--

LOCK TABLES `airlimit` WRITE;
/*!40000 ALTER TABLE `airlimit` DISABLE KEYS */;
/*!40000 ALTER TABLE `airlimit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atmcard`
--

DROP TABLE IF EXISTS `atmcard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atmcard` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `CardNo` char(16) DEFAULT NULL,
  `AcctGUID` char(36) DEFAULT NULL COMMENT 'GUID from ms201 account master',
  `Descn` varchar(50) DEFAULT NULL COMMENT 'name on card',
  `opendate` int(11) DEFAULT NULL,
  `expdate` int(11) DEFAULT NULL,
  `cardtype` tinyint(4) DEFAULT NULL COMMENT '0-visa,1-master',
  `reqguid` varchar(36) DEFAULT NULL,
  `CloseDate` int(11) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `daylimit` decimal(18,2) DEFAULT NULL,
  `monthlimit` decimal(18,2) DEFAULT NULL,
  `trnlimit` decimal(18,2) DEFAULT NULL,
  `entryby` varchar(36) DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` varchar(10) DEFAULT NULL,
  `trdate` int(11) NOT NULL COMMENT 'issue date',
  PRIMARY KEY (`recno`),
  KEY `Card` (`CardNo`),
  KEY `Code` (`AcctGUID`),
  KEY `atmdatekey` (`trdate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ATM card';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atmcard`
--

LOCK TABLES `atmcard` WRITE;
/*!40000 ALTER TABLE `atmcard` DISABLE KEYS */;
/*!40000 ALTER TABLE `atmcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atmcardrequest`
--

DROP TABLE IF EXISTS `atmcardrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atmcardrequest` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `CardNo` char(16) DEFAULT NULL,
  `CardType` tinyint(4) DEFAULT NULL COMMENT '0-visa,1-master',
  `OpenDate` int(11) DEFAULT NULL,
  `ExpDate` int(11) DEFAULT NULL,
  `CloseDate` int(11) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `Limit` decimal(18,2) DEFAULT NULL,
  `BillingDay` smallint(6) DEFAULT NULL COMMENT '5 of every month',
  `CashLimit` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  KEY `Cardno` (`CardNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ATM card request';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atmcardrequest`
--

LOCK TABLES `atmcardrequest` WRITE;
/*!40000 ALTER TABLE `atmcardrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `atmcardrequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atmtrn`
--

DROP TABLE IF EXISTS `atmtrn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atmtrn` (
  `recno` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `processcode` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `systraceno` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `terminalid` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acno` varchar(18) COLLATE utf8_unicode_ci DEFAULT NULL,
  `toacno` varchar(18) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` varchar(13) COLLATE utf8_unicode_ci DEFAULT NULL,
  `track2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authid` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `infohostcommand` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trnfees` varchar(9) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rrn` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instcode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cardno` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `orgsystraceno` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cashatpos` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trndatetime` varchar(14) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reserved1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reserved2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reserved3` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reversal` bit(1) DEFAULT NULL,
  `ledgerbalance` varchar(13) COLLATE utf8_unicode_ci DEFAULT NULL,
  `netbalance` varchar(13) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acctguid` char(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `successflag` bit(1) DEFAULT NULL,
  `postflag` bit(1) DEFAULT NULL,
  `respcode` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `indatetime` datetime DEFAULT CURRENT_TIMESTAMP,
  `outdatetime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`recno`),
  KEY `revKey` (`rrn`,`cardno`,`orgsystraceno`,`reversal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='atmtrn';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atmtrn`
--

LOCK TABLES `atmtrn` WRITE;
/*!40000 ALTER TABLE `atmtrn` DISABLE KEYS */;
/*!40000 ALTER TABLE `atmtrn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bnkmstremit`
--

DROP TABLE IF EXISTS `bnkmstremit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bnkmstremit` (
  `tenant` varchar(36) DEFAULT NULL,
  `recno` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Generate guid for this table',
  `Code` varchar(10) DEFAULT NULL,
  `MICR` char(9) DEFAULT NULL,
  `IFSC` char(11) DEFAULT NULL,
  `Descn` varchar(100) DEFAULT NULL,
  `Address` varchar(250) DEFAULT NULL,
  `PinCode` int(11) DEFAULT NULL,
  `AreaGUID` char(36) DEFAULT NULL,
  `mailid` varchar(100) DEFAULT NULL,
  `Phone` varchar(100) DEFAULT NULL,
  `ParentGUID` char(36) DEFAULT NULL COMMENT 'GUID from ms090 for branch',
  `Active` bit(1) DEFAULT NULL,
  `EntryBy` char(36) DEFAULT NULL,
  `EnrtyDate` int(11) DEFAULT NULL,
  `EntryTime` varchar(8) DEFAULT NULL,
  `DDFlag` bit(1) DEFAULT NULL COMMENT 'is DD drawn on this bank',
  `clrzone` tinyint(4) DEFAULT NULL,
  `weeklyoff` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  KEY `MICR` (`MICR`),
  KEY `IFSC` (`IFSC`),
  KEY `Code` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='bank master for remitt ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bnkmstremit`
--

LOCK TABLES `bnkmstremit` WRITE;
/*!40000 ALTER TABLE `bnkmstremit` DISABLE KEYS */;
/*!40000 ALTER TABLE `bnkmstremit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brbegin`
--

DROP TABLE IF EXISTS `brbegin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brbegin` (
  `tenant` varchar(36) DEFAULT NULL,
  `domain` char(36) NOT NULL,
  `dayopen` bit(1) DEFAULT NULL,
  `today` int(11) DEFAULT NULL,
  `crclrdate` int(11) DEFAULT NULL,
  `DrClrNos` int(11) DEFAULT NULL,
  `DrClrAmt` decimal(18,2) DEFAULT NULL,
  `DrClrGuid` char(36) DEFAULT NULL,
  `DayEndInProcess` bit(1) DEFAULT b'0',
  `clrlastentrydone` bit(1) DEFAULT b'0',
  `cycleno` int(11) DEFAULT '1',
  PRIMARY KEY (`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='branch begin details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brbegin`
--

LOCK TABLES `brbegin` WRITE;
/*!40000 ALTER TABLE `brbegin` DISABLE KEYS */;
/*!40000 ALTER TABLE `brbegin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brholidays`
--

DROP TABLE IF EXISTS `brholidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brholidays` (
  `RecNo` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `DOMAIN` char(36) DEFAULT NULL,
  `Descn` varchar(100) DEFAULT NULL,
  `TRDate` int(11) DEFAULT NULL,
  `WEEKLY` bit(1) DEFAULT NULL,
  `ACTIVE` bit(1) DEFAULT NULL,
  `holidaytype` int(11) DEFAULT '3',
  PRIMARY KEY (`RecNo`),
  UNIQUE KEY `Code` (`DOMAIN`,`TRDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Branch holiday master';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brholidays`
--

LOCK TABLES `brholidays` WRITE;
/*!40000 ALTER TABLE `brholidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `brholidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brncmst`
--

DROP TABLE IF EXISTS `brncmst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brncmst` (
  `recno` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Generate for this table used as domain in many tables',
  `tenant` varchar(36) DEFAULT NULL,
  `channeltype` int(11) NOT NULL COMMENT 'GUID from ms001 for ms14',
  `Code` varchar(12) DEFAULT NULL COMMENT 'branchcode',
  `Descn` varchar(100) DEFAULT NULL,
  `Address1` varchar(100) DEFAULT NULL,
  `Address2` varchar(100) DEFAULT NULL,
  `Address3` varchar(100) DEFAULT NULL,
  `CountryGUID` char(36) DEFAULT NULL COMMENT 'GUID from ms001 for ms08',
  `AreaGUID` char(36) DEFAULT NULL COMMENT 'GUID from ms002 for ms81',
  `PinCode` int(11) DEFAULT NULL,
  `Phone` varchar(25) DEFAULT NULL,
  `fax` varchar(25) DEFAULT NULL,
  `Mobile` varchar(25) DEFAULT NULL,
  `mailid` varchar(100) DEFAULT NULL,
  `TIN` varchar(25) DEFAULT NULL,
  `IFSC` varchar(25) DEFAULT NULL,
  `MICR` varchar(25) DEFAULT NULL,
  `distancefromho` int(11) DEFAULT NULL,
  `opendate` int(11) DEFAULT NULL,
  `closedate` int(11) DEFAULT NULL,
  `ParentGUID` varchar(36) DEFAULT NULL COMMENT 'guid from ms100 where deliverychannel type is atm not used for branch',
  `METROTYPE` tinyint(4) DEFAULT NULL,
  `COMPUTERISED` bit(1) DEFAULT NULL,
  `OpenBalDate` int(11) DEFAULT NULL,
  `oldcode` char(7) DEFAULT NULL,
  `active` bit(1) DEFAULT b'0',
  `EntryBy` char(36) DEFAULT NULL,
  `EntryDate` int(11) DEFAULT NULL,
  `EntryTime` varchar(8) DEFAULT NULL,
  `ClrHouse` char(36) DEFAULT NULL,
  `ClrHouseAdj` char(36) DEFAULT NULL,
  `LoanClrToAdj` bit(1) DEFAULT NULL,
  `ClrHouseAcct` char(36) DEFAULT NULL,
  `ClrHouseAdjAcct` char(36) DEFAULT NULL,
  `glopnbaldate` int(11) DEFAULT NULL,
  `autointposting` bit(1) DEFAULT b'0',
  `autostdposting` bit(1) DEFAULT b'0',
  `corrdate` int(11) DEFAULT NULL,
  `micrcity` varchar(9) DEFAULT '',
  `state` char(36) DEFAULT NULL,
  `tanno` varchar(50) DEFAULT NULL,
  `regionguid` char(36) DEFAULT NULL,
  `mergeinto` char(36) DEFAULT NULL,
  `hobracctguid` char(36) DEFAULT NULL COMMENT '1000.230.1205.0',
  `brhoacctguid` char(36) DEFAULT NULL COMMENT '1205.230.1000.0',
  `glpostdate` int(11) DEFAULT NULL,
  `mdescn` varchar(100) DEFAULT NULL,
  `maddress1` varchar(100) DEFAULT NULL,
  `maddress2` varchar(100) DEFAULT NULL,
  `maddress3` varchar(100) DEFAULT NULL,
  `ckyccode` varchar(50) DEFAULT NULL,
  `ckycregion` varchar(50) DEFAULT NULL,
  `shift` bit(1) DEFAULT b'0',
  `msebregionguid` varchar(36) DEFAULT NULL,
  `zoneguid` varchar(36) DEFAULT NULL,
  `maincorrdate` int(11) DEFAULT '20210331',
  PRIMARY KEY (`recno`,`channeltype`),
  UNIQUE KEY `Code` (`Code`),
  KEY `IFSC` (`IFSC`),
  KEY `MICR` (`MICR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='branch master ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brncmst`
--

LOCK TABLES `brncmst` WRITE;
/*!40000 ALTER TABLE `brncmst` DISABLE KEYS */;
/*!40000 ALTER TABLE `brncmst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cagentcode`
--

DROP TABLE IF EXISTS `cagentcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cagentcode` (
  `tenant` varchar(36) DEFAULT NULL,
  `MaxLength` tinyint(4) DEFAULT NULL COMMENT 'maxlength of acctcode max is 10 digits e.g 10',
  `acnolength` tinyint(4) DEFAULT NULL COMMENT 'length of acno e.g. 3',
  `acnosequence` tinyint(4) DEFAULT NULL COMMENT 'sequence in the code e.g 3',
  `branchinclude` bit(1) DEFAULT NULL COMMENT 'true',
  `branchlength` tinyint(4) DEFAULT NULL COMMENT '3',
  `branchsequence` tinyint(4) DEFAULT NULL COMMENT '1',
  `productinclude` bit(1) DEFAULT NULL COMMENT 'true',
  `productlength` tinyint(4) DEFAULT NULL COMMENT '4',
  `productsequence` tinyint(4) DEFAULT NULL COMMENT '2'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='pigmyagent code generation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cagentcode`
--

LOCK TABLES `cagentcode` WRITE;
/*!40000 ALTER TABLE `cagentcode` DISABLE KEYS */;
/*!40000 ALTER TABLE `cagentcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cashbal`
--

DROP TABLE IF EXISTS `cashbal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cashbal` (
  `tenant` varchar(36) DEFAULT NULL,
  `DOMAIN` char(36) NOT NULL,
  `TrDate` int(11) NOT NULL,
  `GUID` char(36) NOT NULL COMMENT 'Generate for this table used in tr0051',
  `TRTIME` char(8) DEFAULT NULL,
  `CounterGUID` char(36) DEFAULT NULL COMMENT 'GUID from counter table(ms501)',
  `CASHIER` char(36) DEFAULT NULL,
  `OpenCash` decimal(18,2) DEFAULT NULL,
  `CloseCash` decimal(18,2) DEFAULT NULL,
  `CrAmt` decimal(18,2) DEFAULT NULL,
  `DrAmt` decimal(18,2) DEFAULT NULL,
  `ENTRYDATE` int(11) DEFAULT NULL,
  `ENTRYTIME` char(8) DEFAULT NULL,
  `entryby` varchar(36) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DOMAIN`,`TrDate`,`GUID`),
  UNIQUE KEY `Tr005Key1` (`DOMAIN`,`TrDate`,`CounterGUID`,`CASHIER`),
  KEY `DateKey` (`TrDate`,`CounterGUID`),
  KEY `Counter` (`CounterGUID`,`TrDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='cash opening closing denom';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashbal`
--

LOCK TABLES `cashbal` WRITE;
/*!40000 ALTER TABLE `cashbal` DISABLE KEYS */;
/*!40000 ALTER TABLE `cashbal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cashbaldenom`
--

DROP TABLE IF EXISTS `cashbaldenom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cashbaldenom` (
  `tenant` varchar(36) DEFAULT NULL,
  `CashGUID` char(36) NOT NULL COMMENT 'GUID from tr005 table',
  `Seqnce` tinyint(4) NOT NULL,
  `CurValue` decimal(10,2) DEFAULT NULL COMMENT 'GUID from ms001 for method = ms50',
  `OpnQty` int(11) DEFAULT NULL,
  `ClQty` int(11) DEFAULT NULL,
  PRIMARY KEY (`CashGUID`,`Seqnce`),
  KEY `Code` (`CashGUID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='cash opening closing denom';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashbaldenom`
--

LOCK TABLES `cashbaldenom` WRITE;
/*!40000 ALTER TABLE `cashbaldenom` DISABLE KEYS */;
/*!40000 ALTER TABLE `cashbaldenom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cashlimit`
--

DROP TABLE IF EXISTS `cashlimit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cashlimit` (
  `tenant` varchar(36) DEFAULT NULL,
  `RecNo` int(11) NOT NULL AUTO_INCREMENT,
  `Domain` char(36) DEFAULT NULL COMMENT 'GUIDfrom branch master ms100',
  `TrDate` int(11) DEFAULT NULL,
  `ResGUID` char(36) DEFAULT NULL COMMENT 'GUID from resolution master tr151',
  `CashLimit` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`RecNo`),
  UNIQUE KEY `Key` (`Domain`,`ResGUID`),
  KEY `Code` (`Domain`,`TrDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Branch wise cash limit';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashlimit`
--

LOCK TABLES `cashlimit` WRITE;
/*!40000 ALTER TABLE `cashlimit` DISABLE KEYS */;
/*!40000 ALTER TABLE `cashlimit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chartofac`
--

DROP TABLE IF EXISTS `chartofac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chartofac` (
  `REFID` char(6) NOT NULL,
  `DISPLAY` varchar(100) DEFAULT NULL,
  `display1` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `PARENT` char(6) DEFAULT NULL,
  `ACTTYPE` tinyint(3) unsigned DEFAULT NULL,
  `LEDCAT` tinyint(4) DEFAULT NULL,
  `RNGBGN` char(10) DEFAULT NULL,
  `RNGEND` char(10) DEFAULT NULL,
  `ACTIVE` tinyint(1) DEFAULT '0',
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryby` varchar(36) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `grptype` int(11) DEFAULT '0' COMMENT '  1-share,2-cash,3-bank 4-bakinvt 5-deposit 6-loan 7-depointpaid 8-loanintpaid ',
  PRIMARY KEY (`REFID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Standard chart of accounts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chartofac`
--

LOCK TABLES `chartofac` WRITE;
/*!40000 ALTER TABLE `chartofac` DISABLE KEYS */;
/*!40000 ALTER TABLE `chartofac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chqbchrg`
--

DROP TABLE IF EXISTS `chqbchrg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chqbchrg` (
  `Recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `Fromdate` int(11) DEFAULT NULL COMMENT 'chanrges applicable from date',
  `prodguid` char(36) DEFAULT '',
  `Nos` int(11) DEFAULT NULL COMMENT 'upto nos of cheques e.g. 1 charges 10, 30 charges 50, 50 charges 70 etc',
  `charges` decimal(18,2) DEFAULT NULL,
  `servicetax` decimal(18,2) DEFAULT NULL,
  `entryby` char(36) DEFAULT NULL,
  `Entrydate` int(11) DEFAULT NULL,
  `entrytime` char(10) DEFAULT NULL,
  `taxinclusive` bit(1) DEFAULT b'0',
  `taxrate1` decimal(18,2) DEFAULT NULL,
  `taxrate2` decimal(18,2) DEFAULT NULL,
  `taxrate3` decimal(18,2) DEFAULT NULL,
  `chargesglguid` varchar(36) DEFAULT NULL,
  `taxglguid` varchar(36) DEFAULT NULL,
  `taxglguid1` varchar(36) DEFAULT NULL,
  `taxglguid2` varchar(36) DEFAULT NULL,
  `taxglguid3` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`Recno`),
  UNIQUE KEY `code` (`Fromdate`,`prodguid`,`Nos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Chequebook charges ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chqbchrg`
--

LOCK TABLES `chqbchrg` WRITE;
/*!40000 ALTER TABLE `chqbchrg` DISABLE KEYS */;
/*!40000 ALTER TABLE `chqbchrg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chqissue`
--

DROP TABLE IF EXISTS `chqissue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chqissue` (
  `RecNo` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `Domain` char(36) DEFAULT NULL,
  `AcctGUID` char(36) DEFAULT NULL COMMENT 'GUID form ms201',
  `TrDate` int(11) DEFAULT NULL COMMENT 'issue date',
  `FromNo` bigint(20) DEFAULT NULL COMMENT 'chequeno from',
  `ToNo` bigint(20) DEFAULT NULL COMMENT 'cheque no to',
  `RequestGUID` char(36) DEFAULT NULL COMMENT 'Cheque book request guid from sv002',
  `AtPar` bit(1) DEFAULT NULL COMMENT '0-atpar,1-no at par',
  `ENTRYBY` char(36) DEFAULT NULL,
  `ENTRYDATE` int(11) DEFAULT NULL,
  `ENTRYTIME` char(8) DEFAULT NULL,
  `auth_by` char(36) DEFAULT NULL,
  `auth_date` int(11) DEFAULT NULL,
  `auth_time` varchar(8) DEFAULT NULL,
  `charges` decimal(18,2) DEFAULT NULL,
  `servicetax` decimal(18,2) DEFAULT NULL,
  `taxrate1` decimal(18,2) DEFAULT NULL,
  `taxrate2` decimal(18,2) DEFAULT NULL,
  `taxrate3` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`RecNo`),
  UNIQUE KEY `Code` (`AcctGUID`,`FromNo`,`TrDate`),
  KEY `LIST` (`Domain`,`AcctGUID`,`TrDate`),
  KEY `ChqFromNo` (`FromNo`,`Domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='chqissue';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chqissue`
--

LOCK TABLES `chqissue` WRITE;
/*!40000 ALTER TABLE `chqissue` DISABLE KEYS */;
/*!40000 ALTER TABLE `chqissue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cimsalm`
--

DROP TABLE IF EXISTS `cimsalm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cimsalm` (
  `tenant` varchar(36) DEFAULT NULL,
  `refid` char(36) NOT NULL DEFAULT '',
  `parent` char(36) NOT NULL DEFAULT '',
  `nodeid` char(36) NOT NULL DEFAULT '',
  `almguid` char(36) NOT NULL DEFAULT '',
  `trdate` int(11) NOT NULL DEFAULT '0',
  `percentamount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`refid`,`parent`,`nodeid`,`almguid`,`trdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Statements % for ALM';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cimsalm`
--

LOCK TABLES `cimsalm` WRITE;
/*!40000 ALTER TABLE `cimsalm` DISABLE KEYS */;
/*!40000 ALTER TABLE `cimsalm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cimsbasic`
--

DROP TABLE IF EXISTS `cimsbasic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cimsbasic` (
  `tenant` varchar(36) DEFAULT NULL,
  `REFID` char(36) NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `DESCN` varchar(250) DEFAULT NULL,
  `ACTIVE` bit(1) DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryby` varchar(36) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `cashbookflag` int(11) DEFAULT NULL,
  `descn1` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `grprid` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`REFID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Statutory Financial statements, CIMS, BSR, ADF etc.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cimsbasic`
--

LOCK TABLES `cimsbasic` WRITE;
/*!40000 ALTER TABLE `cimsbasic` DISABLE KEYS */;
/*!40000 ALTER TABLE `cimsbasic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cimsfields`
--

DROP TABLE IF EXISTS `cimsfields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cimsfields` (
  `tenant` varchar(36) DEFAULT NULL,
  `REFID` char(36) NOT NULL,
  `NODEID` char(36) NOT NULL,
  `DESCN` varchar(250) DEFAULT NULL,
  `LEDGER` bit(1) DEFAULT NULL,
  `PARENT` char(36) NOT NULL,
  `IINDEX` int(10) unsigned DEFAULT NULL,
  `LLEVEL` int(10) unsigned DEFAULT NULL,
  `SEQNCE` int(10) unsigned DEFAULT NULL,
  `SUMMARY` bit(1) DEFAULT b'0',
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryby` varchar(36) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `FLDNAME` varchar(20) DEFAULT NULL,
  `LEDGERBALTYPE` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `FORMULA` varchar(500) DEFAULT NULL,
  `upto` int(11) DEFAULT '0',
  `descn1` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `riskpercent` decimal(18,2) DEFAULT NULL,
  `formulafornet` bit(1) DEFAULT b'0',
  `GROUPSUMMARY` bit(1) DEFAULT NULL,
  `showdrsign` bit(1) DEFAULT b'0',
  `formulaseqnce` int(11) DEFAULT NULL,
  `grprid` varchar(10) DEFAULT NULL,
  `remarkfield` bit(1) DEFAULT b'0' COMMENT 'to display below the report as remarks swapnil',
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`recno`),
  KEY `fst01akey` (`REFID`,`PARENT`,`NODEID`,`LEDGERBALTYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Statements field and formula';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cimsfields`
--

LOCK TABLES `cimsfields` WRITE;
/*!40000 ALTER TABLE `cimsfields` DISABLE KEYS */;
/*!40000 ALTER TABLE `cimsfields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cimsfldmast`
--

DROP TABLE IF EXISTS `cimsfldmast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cimsfldmast` (
  `tenant` varchar(36) DEFAULT NULL,
  `Seqnce` int(11) NOT NULL,
  `Code` int(11) NOT NULL,
  `Descn` varchar(100) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`Seqnce`),
  UNIQUE KEY `Code` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fields used in CIMS statements';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cimsfldmast`
--

LOCK TABLES `cimsfldmast` WRITE;
/*!40000 ALTER TABLE `cimsfldmast` DISABLE KEYS */;
/*!40000 ALTER TABLE `cimsfldmast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ckycbatch`
--

DROP TABLE IF EXISTS `ckycbatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ckycbatch` (
  `tenant` varchar(36) DEFAULT NULL,
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `trdate` int(11) DEFAULT NULL,
  `batchno` int(11) DEFAULT NULL,
  PRIMARY KEY (`recno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ckyc batch no date wise';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ckycbatch`
--

LOCK TABLES `ckycbatch` WRITE;
/*!40000 ALTER TABLE `ckycbatch` DISABLE KEYS */;
/*!40000 ALTER TABLE `ckycbatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ckyctable`
--

DROP TABLE IF EXISTS `ckyctable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ckyctable` (
  `o_cin` varchar(16) DEFAULT NULL,
  `o_fullname` varchar(100) DEFAULT NULL,
  `o_firstname` varchar(100) DEFAULT NULL,
  `o_middlename` varchar(100) DEFAULT NULL,
  `o_lastname` varchar(100) DEFAULT NULL,
  `o_fathername` varchar(100) DEFAULT NULL,
  `o_mothername` varchar(100) DEFAULT NULL,
  `o_pan` varchar(10) DEFAULT NULL,
  `o_adhar` varchar(12) DEFAULT NULL,
  `o_gender` varchar(20) DEFAULT NULL,
  `o_dob` int(11) DEFAULT NULL,
  `o_savacctcode` varchar(16) DEFAULT NULL,
  `o_ucic` varchar(100) DEFAULT NULL,
  `o_address1` varchar(100) DEFAULT NULL,
  `o_address2` varchar(100) DEFAULT NULL,
  `o_address3` varchar(100) DEFAULT NULL,
  `o_pin` varchar(10) DEFAULT NULL,
  `o_occupation` varchar(100) DEFAULT NULL,
  `o_maritalstatus` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table for ckyc export from cbs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ckyctable`
--

LOCK TABLES `ckyctable` WRITE;
/*!40000 ALTER TABLE `ckyctable` DISABLE KEYS */;
/*!40000 ALTER TABLE `ckyctable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clgholidays`
--

DROP TABLE IF EXISTS `clgholidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clgholidays` (
  `RecNo` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `Descn` varchar(100) DEFAULT NULL,
  `TRDate` int(11) DEFAULT NULL,
  `ACTIVE` bit(1) DEFAULT NULL,
  `holidaytype` int(11) DEFAULT '3',
  PRIMARY KEY (`RecNo`),
  UNIQUE KEY `Code` (`TRDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Clearing holidays';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clgholidays`
--

LOCK TABLES `clgholidays` WRITE;
/*!40000 ALTER TABLE `clgholidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `clgholidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comitymaster`
--

DROP TABLE IF EXISTS `comitymaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comitymaster` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `guid` varchar(36) NOT NULL,
  `code` varchar(5) NOT NULL,
  `descn` varchar(50) DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` char(10) DEFAULT NULL,
  `entryby` char(36) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  UNIQUE KEY `GUIDKEY` (`guid`),
  KEY `CODEKEY` (`code`),
  KEY `DESCNKEY` (`descn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='comittee master ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comitymaster`
--

LOCK TABLES `comitymaster` WRITE;
/*!40000 ALTER TABLE `comitymaster` DISABLE KEYS */;
/*!40000 ALTER TABLE `comitymaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comitymember`
--

DROP TABLE IF EXISTS `comitymember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comitymember` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `guid` varchar(36) NOT NULL COMMENT 'guid from committee master(ms152)',
  `direguid` varchar(36) NOT NULL COMMENT 'guid from director master(ms151)',
  `chairman` bit(1) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` char(10) DEFAULT NULL,
  `entryby` char(36) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  UNIQUE KEY `GUIDKEY` (`guid`,`direguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='comittee member ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comitymember`
--

LOCK TABLES `comitymember` WRITE;
/*!40000 ALTER TABLE `comitymember` DISABLE KEYS */;
/*!40000 ALTER TABLE `comitymember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `counterdevice`
--

DROP TABLE IF EXISTS `counterdevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counterdevice` (
  `tenant` varchar(36) DEFAULT NULL,
  `Domain` char(36) NOT NULL COMMENT 'branch from branch master guid from ms100',
  `GUID` char(36) NOT NULL,
  `Counter` char(20) DEFAULT NULL COMMENT 'shortname of the computer',
  `Descn` varchar(45) DEFAULT NULL COMMENT 'name of the counter',
  `MachineID` varchar(45) DEFAULT NULL COMMENT 'Computer address',
  `CashRectLimit` decimal(18,2) DEFAULT NULL,
  `CashPaytLimit` decimal(18,2) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `otp` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`Domain`,`GUID`),
  KEY `CODE` (`Domain`,`Counter`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='machine  counter';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `counterdevice`
--

LOCK TABLES `counterdevice` WRITE;
/*!40000 ALTER TABLE `counterdevice` DISABLE KEYS */;
/*!40000 ALTER TABLE `counterdevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `croprate`
--

DROP TABLE IF EXISTS `croprate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `croprate` (
  `tenant` varchar(36) DEFAULT NULL,
  `guid` char(36) NOT NULL,
  `crop` char(36) NOT NULL COMMENT 'guid from ms001 with method ms78',
  `croptype` char(36) NOT NULL COMMENT 'guid from ms001 with method ms71',
  `season` char(36) NOT NULL COMMENT 'guid from ms001 with method ms74',
  `soiltype` char(36) NOT NULL COMMENT 'guid from ms001 with method ms79',
  `landtype` char(36) DEFAULT NULL COMMENT 'guid from ms001 with method ms79',
  `hangam` char(36) NOT NULL COMMENT 'guid from ms001 with method ms79',
  `rate` decimal(18,2) DEFAULT '0.00',
  `fromdate` int(11) DEFAULT '0',
  `todate` int(11) DEFAULT '0',
  `period` int(11) DEFAULT '0',
  `expdate` int(11) DEFAULT '0',
  `ENTRYDATE` int(11) DEFAULT NULL,
  `ENTRYTIME` char(8) DEFAULT NULL,
  `ENTRYBY` char(36) DEFAULT NULL,
  PRIMARY KEY (`guid`),
  UNIQUE KEY `ms250key` (`hangam`,`crop`,`croptype`,`season`,`soiltype`,`landtype`),
  KEY `cropkey` (`crop`,`croptype`,`season`,`soiltype`,`hangam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='croprate ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `croprate`
--

LOCK TABLES `croprate` WRITE;
/*!40000 ALTER TABLE `croprate` DISABLE KEYS */;
/*!40000 ALTER TABLE `croprate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directors`
--

DROP TABLE IF EXISTS `directors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `directors` (
  `tenant` varchar(36) DEFAULT NULL,
  `GUID` char(36) NOT NULL COMMENT 'used in ms2013 for ref-director or sanctionby',
  `CustGUID` char(36) DEFAULT NULL COMMENT 'GUID from ms101 customer master',
  `AsonDate` int(11) DEFAULT NULL,
  `TenureFrom` int(11) DEFAULT NULL,
  `TenureTo` int(11) DEFAULT NULL,
  `RetireDate` int(11) DEFAULT NULL,
  `DireType` smallint(6) DEFAULT NULL COMMENT '0-director,1-chairman',
  `Active` bit(1) DEFAULT NULL,
  `Entrydate` int(11) DEFAULT NULL,
  `EntryTime` varchar(8) DEFAULT NULL,
  `EntryBy` char(36) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `retirereason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`GUID`),
  KEY `CustCode` (`CustGUID`),
  KEY `Code` (`AsonDate`,`CustGUID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='director master ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directors`
--

LOCK TABLES `directors` WRITE;
/*!40000 ALTER TABLE `directors` DISABLE KEYS */;
/*!40000 ALTER TABLE `directors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ecsmandate`
--

DROP TABLE IF EXISTS `ecsmandate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ecsmandate` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `ACCTGUID` varchar(36) DEFAULT NULL,
  `trDate` int(11) DEFAULT NULL,
  `startdate` int(11) DEFAULT NULL,
  `enddate` int(11) DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `pert` varchar(100) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `EntryDATE` int(11) DEFAULT NULL,
  `EntryTIME` varchar(10) DEFAULT NULL,
  `EntryBy` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  KEY `acct` (`ACCTGUID`,`trDate`),
  KEY `datekey` (`trDate`,`recno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ECS mandate ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ecsmandate`
--

LOCK TABLES `ecsmandate` WRITE;
/*!40000 ALTER TABLE `ecsmandate` DISABLE KEYS */;
/*!40000 ALTER TABLE `ecsmandate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailconfig`
--

DROP TABLE IF EXISTS `emailconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emailconfig` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `emailhost` varchar(500) DEFAULT NULL,
  `emailport` varchar(10) DEFAULT NULL,
  `senderid` varchar(100) DEFAULT NULL,
  `senderpassword` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  UNIQUE KEY `key1` (`emailhost`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='email configuration';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailconfig`
--

LOCK TABLES `emailconfig` WRITE;
/*!40000 ALTER TABLE `emailconfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empledu`
--

DROP TABLE IF EXISTS `empledu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empledu` (
  `tenant` varchar(36) DEFAULT NULL,
  `guid` char(36) NOT NULL DEFAULT '',
  `emplguid` char(36) DEFAULT NULL,
  `qualguid` char(36) DEFAULT NULL COMMENT 'GUID from ms001',
  `TrDate` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `ENTRYDATE` int(11) DEFAULT NULL,
  `ENTRYTIME` char(8) DEFAULT NULL,
  `ENTRYby` char(36) DEFAULT NULL,
  PRIMARY KEY (`guid`),
  KEY `EmplKey` (`emplguid`,`TrDate`),
  KEY `datekey` (`TrDate`,`emplguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='empl education details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empledu`
--

LOCK TABLES `empledu` WRITE;
/*!40000 ALTER TABLE `empledu` DISABLE KEYS */;
/*!40000 ALTER TABLE `empledu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exceldetail`
--

DROP TABLE IF EXISTS `exceldetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exceldetail` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `mainguid` char(36) DEFAULT NULL COMMENT 'guid from ms185',
  `headerrow` smallint(6) DEFAULT NULL COMMENT '1 if header , mainrow, 3 footer',
  `colname` varchar(50) DEFAULT NULL COMMENT ' column name',
  `startposition` int(11) DEFAULT NULL COMMENT 'start position / excelcolumn no',
  `width` int(11) DEFAULT NULL COMMENT 'width of column',
  `response` bit(1) DEFAULT NULL COMMENT 'true if want to write in response file',
  PRIMARY KEY (`recno`),
  UNIQUE KEY `excelfooterkey1` (`mainguid`,`headerrow`,`recno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='excel for ETL details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exceldetail`
--

LOCK TABLES `exceldetail` WRITE;
/*!40000 ALTER TABLE `exceldetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `exceldetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `excelmast`
--

DROP TABLE IF EXISTS `excelmast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `excelmast` (
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `tenant` varchar(36) DEFAULT NULL,
  `guid` char(36) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `descn` varchar(45) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `sheetname` varchar(45) DEFAULT NULL,
  `crdrtype` smallint(6) DEFAULT NULL COMMENT '1-Multiple crdr\n2-Single Dr-Multiple CR\n3-Single Cr-Multiple DR',
  `glguid` char(36) DEFAULT NULL COMMENT 'if crdrtype = 2 or 3 then glguid',
  `acctguid` char(36) DEFAULT NULL COMMENT 'crdrtype = 2 or 3 then acctguid',
  `genacctcode` bit(1) DEFAULT NULL COMMENT 'true then generate account code else full acctcode is in the excel sheet',
  `headerrows` smallint(6) DEFAULT NULL COMMENT 'no of header rows',
  `footerrows` smallint(6) DEFAULT NULL COMMENT 'no of footer rows',
  `headercols` smallint(6) DEFAULT NULL COMMENT 'no of header cols',
  `footercols` smallint(6) DEFAULT NULL COMMENT 'no of footer cols',
  `mainrowcols` smallint(6) DEFAULT NULL COMMENT 'no of mainrow cols',
  `filetype` smallint(6) DEFAULT NULL COMMENT '1-excel, 2 text file',
  `dateformat` smallint(6) DEFAULT NULL COMMENT '1-ddmmyyyy\n2-yyyymmdd\n3-dd-mm-yyyy\n4-yyyy-mm-dd\n',
  `amtwithdecimal` bit(1) DEFAULT NULL COMMENT 'if . available in amount then true\nelse false then amount with00 eg. 1250.25 true 125025 false',
  `headerdate` varchar(50) DEFAULT NULL COMMENT 'headerdate column name from ms1851',
  `headertotal` varchar(50) DEFAULT NULL COMMENT 'header total column name from ms1851',
  `headercount` varchar(50) DEFAULT NULL,
  `glcode` varchar(50) DEFAULT NULL,
  `brcode` varchar(50) DEFAULT NULL,
  `productcode` varchar(50) DEFAULT NULL,
  `acctcode` varchar(50) DEFAULT NULL,
  `acctname` varchar(50) DEFAULT NULL,
  `respcode` varchar(50) DEFAULT NULL,
  `cramt` varchar(50) DEFAULT NULL,
  `dramt` varchar(50) DEFAULT NULL,
  `particular` varchar(50) DEFAULT NULL,
  `adhar` varchar(50) DEFAULT NULL,
  `charges` decimal(18,2) DEFAULT NULL,
  `servicetax` decimal(18,2) DEFAULT NULL,
  `chargesglguid` char(36) DEFAULT NULL,
  `serviceglguid` char(36) DEFAULT NULL,
  `sgstglguid` char(36) DEFAULT NULL,
  `cgstglguid` char(36) DEFAULT NULL,
  `sourcefilepath` varchar(200) DEFAULT NULL,
  `responsefilepath` varchar(200) DEFAULT NULL,
  `resonsefilename` varchar(200) DEFAULT NULL,
  `ifsccode` varchar(25) DEFAULT NULL,
  `ifscacno` varchar(25) DEFAULT NULL,
  `ifscacname` varchar(50) DEFAULT NULL,
  `intflag` varchar(50) DEFAULT NULL,
  `responsefilename` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  UNIQUE KEY `excelkey1` (`guid`),
  UNIQUE KEY `excelkey2` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='excel for ETL ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `excelmast`
--

LOCK TABLES `excelmast` WRITE;
/*!40000 ALTER TABLE `excelmast` DISABLE KEYS */;
/*!40000 ALTER TABLE `excelmast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goldrate`
--

DROP TABLE IF EXISTS `goldrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goldrate` (
  `RecNo` int(11) NOT NULL AUTO_INCREMENT,
  `Tenant` char(36) NOT NULL,
  `TrDate` int(11) NOT NULL,
  `ProdGuid` char(36) NOT NULL,
  `MarketRate` decimal(18,2) DEFAULT NULL COMMENT 'rate for 10 gms',
  `BankRate` decimal(18,2) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `entryDate` int(11) DEFAULT NULL,
  `EntryTime` varchar(10) DEFAULT NULL,
  `EntryBy` char(36) DEFAULT NULL,
  `InsuRate` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`RecNo`),
  UNIQUE KEY `Code` (`Tenant`,`TrDate`,`ProdGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Gold rates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goldrate`
--

LOCK TABLES `goldrate` WRITE;
/*!40000 ALTER TABLE `goldrate` DISABLE KEYS */;
/*!40000 ALTER TABLE `goldrate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupinstr`
--

DROP TABLE IF EXISTS `groupinstr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupinstr` (
  `tenant` varchar(36) DEFAULT NULL,
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `domain` char(36) DEFAULT NULL,
  `groupguid` char(36) DEFAULT NULL COMMENT 'guid from ms001 method = ms47',
  `guid` char(36) DEFAULT NULL,
  `drglguid` char(36) DEFAULT NULL COMMENT 'guid from ms900',
  `dracctguid` char(36) DEFAULT NULL COMMENT 'guid frm ms201 e.g. saving',
  `dramt` decimal(18,2) DEFAULT NULL,
  `crglguid1` char(36) DEFAULT NULL,
  `cracctguid1` char(36) DEFAULT NULL,
  `cramt1` decimal(18,2) DEFAULT NULL,
  `crglguid2` char(36) DEFAULT NULL,
  `cracctguid2` char(36) DEFAULT NULL,
  `cramt2` decimal(18,2) DEFAULT NULL,
  `givendate` int(11) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `canceldate` int(11) DEFAULT NULL,
  `fullamt` bit(1) DEFAULT NULL COMMENT 'debit full balance to dracctguid',
  `entryby` char(36) DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` char(8) DEFAULT NULL,
  `cractualint1` bit(1) DEFAULT b'0',
  `cractualint2` bit(1) DEFAULT b'0',
  PRIMARY KEY (`recno`),
  UNIQUE KEY `ms223key1` (`guid`),
  KEY `ms223key2` (`groupguid`,`recno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='group standing instructions ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupinstr`
--

LOCK TABLES `groupinstr` WRITE;
/*!40000 ALTER TABLE `groupinstr` DISABLE KEYS */;
/*!40000 ALTER TABLE `groupinstr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupinstrexec`
--

DROP TABLE IF EXISTS `groupinstrexec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupinstrexec` (
  `tenant` varchar(36) DEFAULT NULL,
  `RecNo` int(11) NOT NULL AUTO_INCREMENT,
  `Guid` char(36) DEFAULT NULL COMMENT 'guid from ms223',
  `Postdate` int(11) DEFAULT NULL,
  `DueDate` int(11) DEFAULT NULL,
  `ExecuteFlag` bit(1) DEFAULT NULL,
  `DrAmt` decimal(18,2) DEFAULT NULL,
  `CrAmt1` decimal(18,2) DEFAULT NULL,
  `CrAmt2` decimal(18,2) DEFAULT NULL,
  `EntryBy` char(36) DEFAULT NULL,
  `Entrydate` int(11) DEFAULT NULL,
  `entrytime` char(10) DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`RecNo`),
  KEY `PostKey` (`Postdate`,`RecNo`),
  KEY `Instr` (`Guid`,`Postdate`,`RecNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='group standing instructions executions ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupinstrexec`
--

LOCK TABLES `groupinstrexec` WRITE;
/*!40000 ALTER TABLE `groupinstrexec` DISABLE KEYS */;
/*!40000 ALTER TABLE `groupinstrexec` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grpcoll`
--

DROP TABLE IF EXISTS `grpcoll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grpcoll` (
  `tenant` varchar(36) DEFAULT NULL,
  `recno` int(11) NOT NULL AUTO_INCREMENT,
  `groupguid` char(36) DEFAULT NULL COMMENT 'GUID from ms001 method = ms48',
  `acctguid` char(36) DEFAULT NULL,
  `amt` decimal(18,2) DEFAULT NULL,
  `entryby` char(36) DEFAULT NULL,
  `entrydate` int(11) DEFAULT NULL,
  `entrytime` char(8) DEFAULT NULL,
  `cdflag` int(11) DEFAULT NULL,
  `domain` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`recno`),
  UNIQUE KEY `groupkey1` (`groupguid`,`acctguid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='group collection ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grpcoll`
--

LOCK TABLES `grpcoll` WRITE;
/*!40000 ALTER TABLE `grpcoll` DISABLE KEYS */;
/*!40000 ALTER TABLE `grpcoll` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-26 14:05:23
