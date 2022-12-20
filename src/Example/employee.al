table 70102 "CDS fps_Employee"
{
    ExternalName = 'fps_employee';
    TableType = CDS;
    Description = 'An entity to store information about Employee';

    fields
    {
        field(1; fps_EmployeeId; GUID)
        {
            ExternalName = 'fps_employeeid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'Unieke id van entiteitsexemplaren';
            Caption = 'Employee';
        }
        field(2; CreatedOn; Datetime)
        {
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'Datum en tijdstip waarop de record is gemaakt.';
            Caption = 'Created On';
        }
        field(3; CreatedBy; GUID)
        {
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de gebruiker die de record heeft gemaakt.';
            Caption = 'Created By';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(4; ModifiedOn; Datetime)
        {
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'Datum en tijdstip waarop de record is gewijzigd.';
            Caption = 'Modified On';
        }
        field(5; ModifiedBy; GUID)
        {
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de gebruiker die de record heeft gewijzigd.';
            Caption = 'Modified By';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(6; CreatedOnBehalfBy; GUID)
        {
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de gemachtigde gebruiker die de record heeft gemaakt.';
            Caption = 'Created By (Delegate)';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(7; ModifiedOnBehalfBy; GUID)
        {
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de gemachtigde gebruiker die de record heeft gewijzigd.';
            Caption = 'Modified By (Delegate)';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(16; OwnerId; GUID)
        {
            ExternalName = 'ownerid';
            ExternalType = 'Owner';
            Description = 'Eigenaar-id';
            Caption = 'Owner';
        }
        field(21; OwningBusinessUnit; GUID)
        {
            ExternalName = 'owningbusinessunit';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de business unit die eigenaar is van de record';
            Caption = 'Owning Business Unit';
            TableRelation = "CRM Businessunit".BusinessUnitId;
        }
        field(22; OwningUser; GUID)
        {
            ExternalName = 'owninguser';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de gebruiker die eigenaar is van de record.';
            Caption = 'Owning User';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(23; OwningTeam; GUID)
        {
            ExternalName = 'owningteam';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van het team dat eigenaar is van de record.';
            Caption = 'Owning Team';
            TableRelation = "CRM Team".TeamId;
        }
        field(25; statecode; Option)
        {
            ExternalName = 'statecode';
            ExternalType = 'State';
            ExternalAccess = Modify;
            Description = 'Status van de/het Employee';
            Caption = 'Status';
            InitValue = " ";
            OptionMembers = " ",Active,Inactive;
            OptionOrdinalValues = -1, 0, 1;
        }
        field(27; statuscode; Option)
        {
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            Description = 'De reden van de status van de Employee';
            Caption = 'Status Reason';
            InitValue = " ";
            OptionMembers = " ",Active,Inactive;
            OptionOrdinalValues = -1, 1, 2;
        }
        field(29; VersionNumber; BigInteger)
        {
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
            ExternalAccess = Read;
            Description = 'Versienummer';
            Caption = 'Version Number';
        }
        field(30; ImportSequenceNumber; Integer)
        {
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
            ExternalAccess = Insert;
            Description = 'Volgnummer van de import waarmee deze record is gemaakt.';
            Caption = 'Import Sequence Number';
        }
        field(31; OverriddenCreatedOn; Date)
        {
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
            ExternalAccess = Insert;
            Description = 'Datum en tijdstip waarop de record is gemigreerd.';
            Caption = 'Record Created On';
        }
        field(32; TimeZoneRuleVersionNumber; Integer)
        {
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            Description = 'Uitsluitend voor intern gebruik.';
            Caption = 'Time Zone Rule Version Number';
        }
        field(33; UTCConversionTimeZoneCode; Integer)
        {
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            Description = 'Tijdzonecode die is gebruikt bij het maken van de record.';
            Caption = 'UTC Conversion Time Zone Code';
        }
        field(34; fps_No; Text[20])
        {
            ExternalName = 'fps_no';
            ExternalType = 'String';
            Description = 'Type the No. of the Employee';
            Caption = 'No.';
        }
        field(35; fps_FirstName; Text[30])
        {
            ExternalName = 'fps_firstname';
            ExternalType = 'String';
            Description = 'Type the First Name of the Employee';
            Caption = 'First Name';
        }
        field(36; fps_MiddleName; Text[30])
        {
            ExternalName = 'fps_middlename';
            ExternalType = 'String';
            Description = 'Type the Middle Name of the Employee';
            Caption = 'Middle Name';
        }
        field(37; fps_LastName; Text[30])
        {
            ExternalName = 'fps_lastname';
            ExternalType = 'String';
            Description = 'Type the Last Name of the Employee';
            Caption = 'Last Name';
        }
        field(38; fps_Initials; Text[30])
        {
            ExternalName = 'fps_initials';
            ExternalType = 'String';
            Description = 'Type the Initials of the Employee';
            Caption = 'Initials';
        }
        field(39; fps_JobTitle; Text[30])
        {
            ExternalName = 'fps_jobtitle';
            ExternalType = 'String';
            Description = 'Type the Job Title of the Employee';
            Caption = 'Job Title';
        }
        field(40; fps_SearchName; Text[250])
        {
            ExternalName = 'fps_searchname';
            ExternalType = 'String';
            Description = 'Type the Search Name of the Employee';
            Caption = 'Search Name';
        }
        field(41; fps_Address; Text[100])
        {
            ExternalName = 'fps_address';
            ExternalType = 'String';
            Description = 'Type the Address of the Employee';
            Caption = 'Address';
        }
        field(42; fps_Address2; Text[50])
        {
            ExternalName = 'fps_address2';
            ExternalType = 'String';
            Description = 'Type the Address 2 of the Employee';
            Caption = 'Address 2';
        }
        field(43; fps_City; Text[30])
        {
            ExternalName = 'fps_city';
            ExternalType = 'String';
            Description = 'Type the City of the Employee';
            Caption = 'City';
        }
        field(44; fps_PostCode; Text[20])
        {
            ExternalName = 'fps_postcode';
            ExternalType = 'String';
            Description = 'Type the Post Code of the Employee';
            Caption = 'Post Code';
        }
        field(45; fps_County; Text[30])
        {
            ExternalName = 'fps_county';
            ExternalType = 'String';
            Description = 'Type the County of the Employee';
            Caption = 'County';
        }
        field(46; fps_PhoneNo; Text[30])
        {
            ExternalName = 'fps_phoneno';
            ExternalType = 'String';
            Description = 'Type the Phone No. of the Employee';
            Caption = 'Phone No.';
        }
        field(47; fps_MobilePhoneNo; Text[30])
        {
            ExternalName = 'fps_mobilephoneno';
            ExternalType = 'String';
            Description = 'Type the Mobile Phone No. of the Employee';
            Caption = 'Mobile Phone No.';
        }
        field(48; fps_EMail; Text[80])
        {
            ExternalName = 'fps_email';
            ExternalType = 'String';
            Description = 'Type the E-Mail of the Employee';
            Caption = 'E-Mail';
        }
        field(49; fps_AltAddressCode; Text[10])
        {
            ExternalName = 'fps_altaddresscode';
            ExternalType = 'String';
            Description = 'Type the Alt. Address Code of the Employee';
            Caption = 'Alt. Address Code';
        }
        field(50; fps_AltAddressStartDate; Date)
        {
            ExternalName = 'fps_altaddressstartdate';
            ExternalType = 'DateTime';
            Description = 'Type the Alt. Address Start Date of the Employee';
            Caption = 'Alt. Address Start Date';
        }
        field(51; fps_AltAddressEndDate; Date)
        {
            ExternalName = 'fps_altaddressenddate';
            ExternalType = 'DateTime';
            Description = 'Type the Alt. Address End Date of the Employee';
            Caption = 'Alt. Address End Date';
        }
        field(52; fps_BirthDate; Date)
        {
            ExternalName = 'fps_birthdate';
            ExternalType = 'DateTime';
            Description = 'Type the Birth Date of the Employee';
            Caption = 'Birth Date';
        }
        field(53; fps_SocialSecurityNo; Text[30])
        {
            ExternalName = 'fps_socialsecurityno';
            ExternalType = 'String';
            Description = 'Type the Social Security No. of the Employee';
            Caption = 'Social Security No.';
        }
        field(54; fps_UnionCode; Text[10])
        {
            ExternalName = 'fps_unioncode';
            ExternalType = 'String';
            Description = 'Type the Union Code of the Employee';
            Caption = 'Union Code';
        }
        field(55; fps_UnionMembershipNo; Text[30])
        {
            ExternalName = 'fps_unionmembershipno';
            ExternalType = 'String';
            Description = 'Type the Union Membership No. of the Employee';
            Caption = 'Union Membership No.';
        }
        field(56; fps_Gender; Option)
        {
            ExternalName = 'fps_gender';
            ExternalType = 'Picklist';
            Description = 'Type the Gender of the Employee';
            Caption = 'Gender';
            InitValue = " ";
            OptionMembers = " ",,Female,Male;
            OptionOrdinalValues = -1, 100000000, 100000001, 100000002;
        }
        field(58; fps_CountryRegionCode; Text[10])
        {
            ExternalName = 'fps_countryregioncode';
            ExternalType = 'String';
            Description = 'Type the Country/Region Code of the Employee';
            Caption = 'Country/Region Code';
        }
        field(59; fps_ManagerNo; Text[20])
        {
            ExternalName = 'fps_managerno';
            ExternalType = 'String';
            Description = 'Type the Manager No. of the Employee';
            Caption = 'Manager No.';
        }
        field(60; fps_EmplymtContractCode; Text[10])
        {
            ExternalName = 'fps_emplymtcontractcode';
            ExternalType = 'String';
            Description = 'Type the Emplymt. Contract Code of the Employee';
            Caption = 'Emplymt. Contract Code';
        }
        field(61; fps_StatisticsGroupCode; Text[10])
        {
            ExternalName = 'fps_statisticsgroupcode';
            ExternalType = 'String';
            Description = 'Type the Statistics Group Code of the Employee';
            Caption = 'Statistics Group Code';
        }
        field(62; fps_EmploymentDate; Date)
        {
            ExternalName = 'fps_employmentdate';
            ExternalType = 'DateTime';
            Description = 'Type the Employment Date of the Employee';
            Caption = 'Employment Date';
        }
        field(63; fps_Status; Option)
        {
            ExternalName = 'fps_status';
            ExternalType = 'Picklist';
            Description = 'Type the Status of the Employee';
            Caption = 'Status';
            InitValue = " ";
            OptionMembers = " ",Active,Inactive,Terminated;
            OptionOrdinalValues = -1, 100000000, 100000001, 100000002;
        }
        field(65; fps_InactiveDate; Date)
        {
            ExternalName = 'fps_inactivedate';
            ExternalType = 'DateTime';
            Description = 'Type the Inactive Date of the Employee';
            Caption = 'Inactive Date';
        }
        field(66; fps_CauseofInactivityCode; Text[10])
        {
            ExternalName = 'fps_causeofinactivitycode';
            ExternalType = 'String';
            Description = 'Type the Cause of Inactivity Code of the Employee';
            Caption = 'Cause of Inactivity Code';
        }
        field(67; fps_TerminationDate; Date)
        {
            ExternalName = 'fps_terminationdate';
            ExternalType = 'DateTime';
            Description = 'Type the Termination Date of the Employee';
            Caption = 'Termination Date';
        }
        field(68; fps_GroundsforTermCode; Text[10])
        {
            ExternalName = 'fps_groundsfortermcode';
            ExternalType = 'String';
            Description = 'Type the Grounds for Term. Code of the Employee';
            Caption = 'Grounds for Term. Code';
        }
        field(69; fps_GlobalDimension1Code; Text[20])
        {
            ExternalName = 'fps_globaldimension1code';
            ExternalType = 'String';
            Description = 'Type the Global Dimension 1 Code of the Employee';
            Caption = 'Global Dimension 1 Code';
        }
        field(70; fps_GlobalDimension2Code; Text[20])
        {
            ExternalName = 'fps_globaldimension2code';
            ExternalType = 'String';
            Description = 'Type the Global Dimension 2 Code of the Employee';
            Caption = 'Global Dimension 2 Code';
        }
        field(71; fps_ResourceNo; Text[20])
        {
            ExternalName = 'fps_resourceno';
            ExternalType = 'String';
            Description = 'Type the Resource No. of the Employee';
            Caption = 'Resource No.';
        }
        field(72; fps_LastDateModified; Date)
        {
            ExternalName = 'fps_lastdatemodified';
            ExternalType = 'DateTime';
            Description = 'Type the Last Date Modified of the Employee';
            Caption = 'Last Date Modified';
        }
        field(73; fps_Extension; Text[30])
        {
            ExternalName = 'fps_extension';
            ExternalType = 'String';
            Description = 'Type the Extension of the Employee';
            Caption = 'Extension';
        }
        field(74; fps_Pager; Text[30])
        {
            ExternalName = 'fps_pager';
            ExternalType = 'String';
            Description = 'Type the Pager of the Employee';
            Caption = 'Pager';
        }
        field(75; fps_FaxNo; Text[30])
        {
            ExternalName = 'fps_faxno';
            ExternalType = 'String';
            Description = 'Type the Fax No. of the Employee';
            Caption = 'Fax No.';
        }
        field(76; fps_CompanyEMail; Text[80])
        {
            ExternalName = 'fps_companyemail';
            ExternalType = 'String';
            Description = 'Type the Company E-Mail of the Employee';
            Caption = 'Company E-Mail';
        }
        field(77; fps_Title; Text[30])
        {
            ExternalName = 'fps_title';
            ExternalType = 'String';
            Description = 'Type the Title of the Employee';
            Caption = 'Title';
        }
        field(78; fps_SalespersPurchCode; Text[20])
        {
            ExternalName = 'fps_salesperspurchcode';
            ExternalType = 'String';
            Description = 'Type the Salespers./Purch. Code of the Employee';
            Caption = 'Salespers./Purch. Code';
        }
        field(79; fps_NoSeries; Text[20])
        {
            ExternalName = 'fps_noseries';
            ExternalType = 'String';
            Description = 'Type the No. Series of the Employee';
            Caption = 'No. Series';
        }
        field(80; fps_LastModifiedDateTime; Datetime)
        {
            ExternalName = 'fps_lastmodifieddatetime';
            ExternalType = 'DateTime';
            Description = 'Type the Last Modified Date Time of the Employee';
            Caption = 'Last Modified Date Time';
        }
        field(81; fps_EmployeePostingGroup; Text[20])
        {
            ExternalName = 'fps_employeepostinggroup';
            ExternalType = 'String';
            Description = 'Type the Employee Posting Group of the Employee';
            Caption = 'Employee Posting Group';
        }
        field(82; fps_BankBranchNo; Text[20])
        {
            ExternalName = 'fps_bankbranchno';
            ExternalType = 'String';
            Description = 'Type the Bank Branch No. of the Employee';
            Caption = 'Bank Branch No.';
        }
        field(83; fps_BankAccountNo; Text[30])
        {
            ExternalName = 'fps_bankaccountno';
            ExternalType = 'String';
            Description = 'Type the Bank Account No. of the Employee';
            Caption = 'Bank Account No.';
        }
        field(84; fps_IBAN; Text[50])
        {
            ExternalName = 'fps_iban';
            ExternalType = 'String';
            Description = 'Type the IBAN of the Employee';
            Caption = 'IBAN';
        }
        field(85; fps_SWIFTCode; Text[20])
        {
            ExternalName = 'fps_swiftcode';
            ExternalType = 'String';
            Description = 'Type the SWIFT Code of the Employee';
            Caption = 'SWIFT Code';
        }
        field(86; fps_ApplicationMethod; Option)
        {
            ExternalName = 'fps_applicationmethod';
            ExternalType = 'Picklist';
            Description = 'Type the Application Method of the Employee';
            Caption = 'Application Method';
            InitValue = " ";
            OptionMembers = " ",Manual,ApplyToOldest;
            OptionOrdinalValues = -1, 100000000, 100000001;
        }
        field(88; fps_PrivacyBlocked; Boolean)
        {
            ExternalName = 'fps_privacyblocked';
            ExternalType = 'Boolean';
            Description = 'Type the Privacy Blocked of the Employee';
            Caption = 'Privacy Blocked';
        }
        field(90; fps_CostCenterCode; Text[20])
        {
            ExternalName = 'fps_costcentercode';
            ExternalType = 'String';
            Description = 'Type the Cost Center Code of the Employee';
            Caption = 'Cost Center Code';
        }
        field(91; fps_CostObjectCode; Text[20])
        {
            ExternalName = 'fps_costobjectcode';
            ExternalType = 'String';
            Description = 'Type the Cost Object Code of the Employee';
            Caption = 'Cost Object Code';
        }
        field(92; fps_Id; Text[16])
        {
            ExternalName = 'fps_id';
            ExternalType = 'String';
            Description = 'Type the Id of the Employee';
            Caption = 'Id';
        }
        field(93; fps_TransactionModeCode; Text[20])
        {
            ExternalName = 'fps_transactionmodecode';
            ExternalType = 'String';
            Description = 'Type the Transaction Mode Code of the Employee';
            Caption = 'Transaction Mode Code';
        }
        field(94; fps_BankName; Text[100])
        {
            ExternalName = 'fps_bankname';
            ExternalType = 'String';
            Description = 'Type the Bank Name of the Employee';
            Caption = 'Bank Name';
        }
        field(95; fps_BankCity; Text[30])
        {
            ExternalName = 'fps_bankcity';
            ExternalType = 'String';
            Description = 'Type the Bank City of the Employee';
            Caption = 'Bank City';
        }
    }
    keys
    {
        key(PK; fps_EmployeeId)
        {
            Clustered = true;
        }
        key(Name; fps_No)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; fps_No)
        {
        }
    }
}