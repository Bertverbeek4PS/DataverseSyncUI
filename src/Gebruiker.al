table 70103 "CDS SystemUser"
{
    ExternalName = 'systemuser';
    TableType = CDS;
    Description = 'Een persoon die toegang heeft tot het Microsoft CRM-systeem en eigenaar is van objecten in de Microsoft CRM-database.';

    fields
    {
        field(1; SystemUserId; GUID)
        {
            ExternalName = 'systemuserid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'De unieke id voor de gebruiker.';
            Caption = 'User';
        }
        field(4; OrganizationId; GUID)
        {
            ExternalName = 'organizationid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Read;
            Description = 'De unieke id van de organisatie die aan de gebruiker is gekoppeld.';
            Caption = 'Organization ';
        }
        field(6; ParentSystemUserId; GUID)
        {
            ExternalName = 'parentsystemuserid';
            ExternalType = 'Lookup';
            Description = 'De unieke id van de manager van de gebruiker.';
            Caption = 'Manager';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(7; FirstName; Text[256])
        {
            ExternalName = 'firstname';
            ExternalType = 'String';
            Description = 'De voornaam van de gebruiker.';
            Caption = 'First Name';
        }
        field(8; Salutation; Text[20])
        {
            ExternalName = 'salutation';
            ExternalType = 'String';
            Description = 'De aanspreektitel voor correspondentie met de gebruiker.';
            Caption = 'Salutation';
        }
        field(9; MiddleName; Text[50])
        {
            ExternalName = 'middlename';
            ExternalType = 'String';
            Description = 'De middelste naam van de gebruiker.';
            Caption = 'Middle Name';
        }
        field(10; LastName; Text[256])
        {
            ExternalName = 'lastname';
            ExternalType = 'String';
            Description = 'De achternaam van de gebruiker.';
            Caption = 'Last Name';
        }
        field(11; PersonalEMailAddress; Text[100])
        {
            ExternalName = 'personalemailaddress';
            ExternalType = 'String';
            Description = 'Het persoonlijke e-mailadres van de gebruiker.';
            Caption = 'Email 2';
        }
        field(12; FullName; Text[200])
        {
            ExternalName = 'fullname';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = 'De volledige naam van de gebruiker.';
            Caption = 'Full Name';
        }
        field(13; NickName; Text[50])
        {
            ExternalName = 'nickname';
            ExternalType = 'String';
            Description = 'De bijnaam van de gebruiker.';
            Caption = 'Nickname';
        }
        field(14; Title; Text[128])
        {
            ExternalName = 'title';
            ExternalType = 'String';
            Description = 'De titel van de gebruiker.';
            Caption = 'Title';
        }
        field(15; InternalEMailAddress; Text[100])
        {
            ExternalName = 'internalemailaddress';
            ExternalType = 'String';
            Description = 'Het interne e-mailadres voor de gebruiker.';
            Caption = 'Primary Email';
        }
        field(16; JobTitle; Text[100])
        {
            ExternalName = 'jobtitle';
            ExternalType = 'String';
            Description = 'De functie van de gebruiker.';
            Caption = 'Job Title';
        }
        field(17; MobileAlertEMail; Text[100])
        {
            ExternalName = 'mobilealertemail';
            ExternalType = 'String';
            Description = 'Het e-mailadres voor SMS-alerts op de mobiele telefoon voor de gebruiker.';
            Caption = 'Mobile Alert Email';
        }
        field(18; PreferredEmailCode; Option)
        {
            ExternalName = 'preferredemailcode';
            ExternalType = 'Picklist';
            Description = 'Het e-mailadres met voorkeur voor de gebruiker.';
            Caption = 'Preferred Email';
            InitValue = DefaultValue;
            OptionMembers = DefaultValue;
            OptionOrdinalValues = 1;
        }
        field(19; HomePhone; Text[50])
        {
            ExternalName = 'homephone';
            ExternalType = 'String';
            Description = 'Het telefoonnummer thuis voor de gebruiker.';
            Caption = 'Home Phone';
        }
        field(20; MobilePhone; Text[64])
        {
            ExternalName = 'mobilephone';
            ExternalType = 'String';
            Description = 'Het mobiele telefoonnummer voor de gebruiker.';
            Caption = 'Mobile Phone';
        }
        field(21; PreferredPhoneCode; Option)
        {
            ExternalName = 'preferredphonecode';
            ExternalType = 'Picklist';
            Description = 'Het telefoonnummer met voorkeur voor de gebruiker.';
            Caption = 'Preferred Phone';
            InitValue = MainPhone;
            OptionMembers = MainPhone,OtherPhone,HomePhone,MobilePhone;
            OptionOrdinalValues = 1, 2, 3, 4;
        }
        field(22; PreferredAddressCode; Option)
        {
            ExternalName = 'preferredaddresscode';
            ExternalType = 'Picklist';
            Description = 'Het voorkeursadres voor de gebruiker.';
            Caption = 'Preferred Address';
            InitValue = MailingAddress;
            OptionMembers = MailingAddress,OtherAddress;
            OptionOrdinalValues = 1, 2;
        }
        field(23; PhotoUrl; Text[200])
        {
            ExternalName = 'photourl';
            ExternalType = 'String';
            Description = 'De URL voor de website waarop zich een foto van de gebruiker bevindt.';
            Caption = 'Photo URL';
        }
        field(24; DomainName; Text[1024])
        {
            ExternalName = 'domainname';
            ExternalType = 'String';
            Description = 'Het Active Directory-domein waarvan de gebruiker deel uitmaakt.';
            Caption = 'User Name';
        }
        field(25; PassportLo; Integer)
        {
            ExternalName = 'passportlo';
            ExternalType = 'Integer';
            Description = 'Uitsluitend voor intern gebruik.';
            Caption = 'Passport Lo';
        }
        field(26; CreatedOn; Datetime)
        {
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'De datum en het tijdstip waarop de gebruiker is gemaakt.';
            Caption = 'Created On';
        }
        field(27; PassportHi; Integer)
        {
            ExternalName = 'passporthi';
            ExternalType = 'Integer';
            Description = 'Uitsluitend voor intern gebruik.';
            Caption = 'Passport Hi';
        }
        field(28; DisabledReason; Text[500])
        {
            ExternalName = 'disabledreason';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = 'De reden voor het uitschakelen van de gebruiker.';
            Caption = 'Disabled Reason';
        }
        field(29; ModifiedOn; Datetime)
        {
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'De datum en het tijdstip waarop de gebruiker het laatst is gewijzigd.';
            Caption = 'Modified On';
        }
        field(31; CreatedBy; GUID)
        {
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gebruiker die de gebruiker heeft gemaakt.';
            Caption = 'Created By';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(32; EmployeeId; Text[100])
        {
            ExternalName = 'employeeid';
            ExternalType = 'String';
            Description = 'De werknemers-id voor de gebruiker.';
            Caption = 'Employee';
        }
        field(33; ModifiedBy; GUID)
        {
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gebruiker die de gebruiker het laatst heeft gewijzigd.';
            Caption = 'Modified By';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(34; IsDisabled; Boolean)
        {
            ExternalName = 'isdisabled';
            ExternalType = 'Boolean';
            ExternalAccess = Modify;
            Description = 'Gegevens over de vraag of de gebruiker wordt ingeschakeld.';
            Caption = 'Status';
        }
        field(35; GovernmentId; Text[100])
        {
            ExternalName = 'governmentid';
            ExternalType = 'String';
            Description = 'Overheids-id voor de gebruiker.';
            Caption = 'Government';
        }
        field(36; VersionNumber; BigInteger)
        {
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
            ExternalAccess = Read;
            Description = 'Het versienummer van de gebruiker.';
            Caption = 'Version number';
        }
        field(37; ParentSystemUserIdName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ParentSystemUserId)));
            ExternalName = 'parentsystemuseridname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(41; Address1_AddressId; GUID)
        {
            ExternalName = 'address1_addressid';
            ExternalType = 'Uniqueidentifier';
            Description = 'De unieke id voor adres 1.';
            Caption = 'Address 1: ID';
        }
        field(42; Address1_AddressTypeCode; Option)
        {
            ExternalName = 'address1_addresstypecode';
            ExternalType = 'Picklist';
            Description = 'Het type adres voor adres 1, bijvoorbeeld factuuradres, verzendadres of hoofdadres.';
            Caption = 'Address 1: Address Type';
            InitValue = DefaultValue;
            OptionMembers = DefaultValue;
            OptionOrdinalValues = 1;
        }
        field(43; Address1_Name; Text[100])
        {
            ExternalName = 'address1_name';
            ExternalType = 'String';
            Description = 'De naam die moet worden ingevoerd voor adres 1.';
            Caption = 'Address 1: Name';
        }
        field(44; Address1_Line1; Text[1024])
        {
            ExternalName = 'address1_line1';
            ExternalType = 'String';
            Description = 'De eerste regel voor het invoeren van gegevens voor adres 1.';
            Caption = 'Street 1';
        }
        field(45; Address1_Line2; Text[1024])
        {
            ExternalName = 'address1_line2';
            ExternalType = 'String';
            Description = 'De tweede regel voor het invoeren van gegevens voor adres 1.';
            Caption = 'Street 2';
        }
        field(46; Address1_Line3; Text[1024])
        {
            ExternalName = 'address1_line3';
            ExternalType = 'String';
            Description = 'De derde regel voor het invoeren van gegevens voor adres 1.';
            Caption = 'Street 3';
        }
        field(47; Address1_City; Text[128])
        {
            ExternalName = 'address1_city';
            ExternalType = 'String';
            Description = 'De plaatsnaam in adres 1.';
            Caption = 'City';
        }
        field(48; Address1_StateOrProvince; Text[128])
        {
            ExternalName = 'address1_stateorprovince';
            ExternalType = 'String';
            Description = 'De provincie in adres 1.';
            Caption = 'State/Province';
        }
        field(49; Address1_County; Text[128])
        {
            ExternalName = 'address1_county';
            ExternalType = 'String';
            Description = 'De provincienaam in adres 1.';
            Caption = 'Address 1: County';
        }
        field(50; Address1_Country; Text[128])
        {
            ExternalName = 'address1_country';
            ExternalType = 'String';
            Description = 'De land/regionaam in adres 1.';
            Caption = 'Country/Region';
        }
        field(51; Address1_PostOfficeBox; Text[40])
        {
            ExternalName = 'address1_postofficebox';
            ExternalType = 'String';
            Description = 'Het postbusnummer in adres 1.';
            Caption = 'Address 1: Post Office Box';
        }
        field(52; Address1_PostalCode; Text[40])
        {
            ExternalName = 'address1_postalcode';
            ExternalType = 'String';
            Description = 'De postcode voor adres 1.';
            Caption = 'ZIP/Postal Code';
        }
        field(53; Address1_UTCOffset; Integer)
        {
            ExternalName = 'address1_utcoffset';
            ExternalType = 'Integer';
            Description = 'De UTC-afwijking voor adres 1. Dit is het verschil tussen de lokale tijd en de standaard UTC (Coordinated Universal Time).';
            Caption = 'Address 1: UTC Offset';
        }
        field(54; Address1_UPSZone; Text[4])
        {
            ExternalName = 'address1_upszone';
            ExternalType = 'String';
            Description = 'De UPS-zone (United Parcel Service) voor adres 1.';
            Caption = 'Address 1: UPS Zone';
        }
        field(55; Address1_Latitude; Decimal)
        {
            ExternalName = 'address1_latitude';
            ExternalType = 'Double';
            Description = 'De geografische breedte voor adres 1.';
            Caption = 'Address 1: Latitude';
        }
        field(56; Address1_Telephone1; Text[64])
        {
            ExternalName = 'address1_telephone1';
            ExternalType = 'String';
            Description = 'Het eerste telefoonnummer dat is gekoppeld aan adres 1.';
            Caption = 'Main Phone';
        }
        field(57; Address1_Longitude; Decimal)
        {
            ExternalName = 'address1_longitude';
            ExternalType = 'Double';
            Description = 'De geografische lengte voor adres 1.';
            Caption = 'Address 1: Longitude';
        }
        field(58; Address1_ShippingMethodCode; Option)
        {
            ExternalName = 'address1_shippingmethodcode';
            ExternalType = 'Picklist';
            Description = 'De verzendwijze voor adres 1.';
            Caption = 'Address 1: Shipping Method';
            InitValue = DefaultValue;
            OptionMembers = DefaultValue;
            OptionOrdinalValues = 1;
        }
        field(59; Address1_Telephone2; Text[50])
        {
            ExternalName = 'address1_telephone2';
            ExternalType = 'String';
            Description = 'Het tweede telefoonnummer dat is gekoppeld aan adres 1.';
            Caption = 'Other Phone';
        }
        field(60; Address1_Telephone3; Text[50])
        {
            ExternalName = 'address1_telephone3';
            ExternalType = 'String';
            Description = 'Het derde telefoonnummer dat is gekoppeld aan adres 1.';
            Caption = 'Pager';
        }
        field(61; Address1_Fax; Text[64])
        {
            ExternalName = 'address1_fax';
            ExternalType = 'String';
            Description = 'Het faxnummer voor adres 1.';
            Caption = 'Address 1: Fax';
        }
        field(62; Address2_AddressId; GUID)
        {
            ExternalName = 'address2_addressid';
            ExternalType = 'Uniqueidentifier';
            Description = 'De unieke id voor adres 2.';
            Caption = 'Address 2: ID';
        }
        field(63; Address2_AddressTypeCode; Option)
        {
            ExternalName = 'address2_addresstypecode';
            ExternalType = 'Picklist';
            Description = 'Het type adres voor adres 2, bijvoorbeeld factuuradres, verzendadres of hoofdadres.';
            Caption = 'Address 2: Address Type';
            InitValue = DefaultValue;
            OptionMembers = DefaultValue;
            OptionOrdinalValues = 1;
        }
        field(64; Address2_Name; Text[100])
        {
            ExternalName = 'address2_name';
            ExternalType = 'String';
            Description = 'De naam die moet worden ingevoerd voor adres 2.';
            Caption = 'Address 2: Name';
        }
        field(65; Address2_Line1; Text[1024])
        {
            ExternalName = 'address2_line1';
            ExternalType = 'String';
            Description = 'De eerste regel voor het invoeren van gegevens van adres 2.';
            Caption = 'Other Street 1';
        }
        field(66; Address2_Line2; Text[1024])
        {
            ExternalName = 'address2_line2';
            ExternalType = 'String';
            Description = 'De tweede regel voor het invoeren van gegevens voor adres 2.';
            Caption = 'Other Street 2';
        }
        field(67; Address2_Line3; Text[1024])
        {
            ExternalName = 'address2_line3';
            ExternalType = 'String';
            Description = 'De derde regel voor het invoeren van gegevens van adres 2.';
            Caption = 'Other Street 3';
        }
        field(68; Address2_City; Text[128])
        {
            ExternalName = 'address2_city';
            ExternalType = 'String';
            Description = 'De plaatsnaam in adres 2.';
            Caption = 'Other City';
        }
        field(69; Address2_StateOrProvince; Text[128])
        {
            ExternalName = 'address2_stateorprovince';
            ExternalType = 'String';
            Description = 'De provincie in adres 2.';
            Caption = 'Other State/Province';
        }
        field(70; Address2_County; Text[128])
        {
            ExternalName = 'address2_county';
            ExternalType = 'String';
            Description = 'De provincienaam in adres 2.';
            Caption = 'Address 2: County';
        }
        field(71; Address2_Country; Text[128])
        {
            ExternalName = 'address2_country';
            ExternalType = 'String';
            Description = 'De land/regionaam in adres 2.';
            Caption = 'Other Country/Region';
        }
        field(72; Address2_PostOfficeBox; Text[40])
        {
            ExternalName = 'address2_postofficebox';
            ExternalType = 'String';
            Description = 'Het postbusnummer in adres 2.';
            Caption = 'Address 2: Post Office Box';
        }
        field(73; Address2_PostalCode; Text[40])
        {
            ExternalName = 'address2_postalcode';
            ExternalType = 'String';
            Description = 'De postcode in adres 2.';
            Caption = 'Other ZIP/Postal Code';
        }
        field(74; Address2_UTCOffset; Integer)
        {
            ExternalName = 'address2_utcoffset';
            ExternalType = 'Integer';
            Description = 'De UTC-afwijking voor adres 2. Dit is het verschil tussen de lokale tijd en de standaard UTC (Coordinated Universal Time).';
            Caption = 'Address 2: UTC Offset';
        }
        field(75; Address2_UPSZone; Text[4])
        {
            ExternalName = 'address2_upszone';
            ExternalType = 'String';
            Description = 'De UPS-zone (United Parcel Service) voor adres 2.';
            Caption = 'Address 2: UPS Zone';
        }
        field(76; Address2_Latitude; Decimal)
        {
            ExternalName = 'address2_latitude';
            ExternalType = 'Double';
            Description = 'De geografische breedte voor adres 2.';
            Caption = 'Address 2: Latitude';
        }
        field(77; Address2_Telephone1; Text[50])
        {
            ExternalName = 'address2_telephone1';
            ExternalType = 'String';
            Description = 'Het eerste telefoonnummer dat is gekoppeld aan adres 2.';
            Caption = 'Address 2: Telephone 1';
        }
        field(78; Address2_Longitude; Decimal)
        {
            ExternalName = 'address2_longitude';
            ExternalType = 'Double';
            Description = 'De geografische lengte voor adres 2.';
            Caption = 'Address 2: Longitude';
        }
        field(79; Address2_ShippingMethodCode; Option)
        {
            ExternalName = 'address2_shippingmethodcode';
            ExternalType = 'Picklist';
            Description = 'De verzendwijze voor adres 2.';
            Caption = 'Address 2: Shipping Method';
            InitValue = DefaultValue;
            OptionMembers = DefaultValue;
            OptionOrdinalValues = 1;
        }
        field(80; Address2_Telephone2; Text[50])
        {
            ExternalName = 'address2_telephone2';
            ExternalType = 'String';
            Description = 'Het tweede telefoonnummer dat is gekoppeld aan adres 2.';
            Caption = 'Address 2: Telephone 2';
        }
        field(81; Address2_Telephone3; Text[50])
        {
            ExternalName = 'address2_telephone3';
            ExternalType = 'String';
            Description = 'Het derde telefoonnummer dat is gekoppeld aan adres 2.';
            Caption = 'Address 2: Telephone 3';
        }
        field(82; Address2_Fax; Text[50])
        {
            ExternalName = 'address2_fax';
            ExternalType = 'String';
            Description = 'Het faxnummer voor adres 2.';
            Caption = 'Address 2: Fax';
        }
        field(83; CreatedByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(CreatedBy)));
            ExternalName = 'createdbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(85; ModifiedByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ModifiedBy)));
            ExternalName = 'modifiedbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(99; Skills; Text[100])
        {
            ExternalName = 'skills';
            ExternalType = 'String';
            Description = 'De vaardigheden van de gebruiker.';
            Caption = 'Skills';
        }
        field(100; DisplayInServiceViews; Boolean)
        {
            ExternalName = 'displayinserviceviews';
            ExternalType = 'Boolean';
            Description = 'Of de gebruiker in serviceweergaven moet worden weergegeven.';
            Caption = 'Display in Service Views';
        }
        field(103; SetupUser; Boolean)
        {
            ExternalName = 'setupuser';
            ExternalType = 'Boolean';
            Description = 'Controleren of de gebruiker een setup-gebruiker is.';
            Caption = 'Restricted Access Mode';
        }
        field(109; WindowsLiveID; Text[1024])
        {
            ExternalName = 'windowsliveid';
            ExternalType = 'String';
            Description = 'Windows Live ID';
            Caption = 'Windows Live ID';
        }
        field(110; IncomingEmailDeliveryMethod; Option)
        {
            ExternalName = 'incomingemaildeliverymethod';
            ExternalType = 'Picklist';
            Description = 'Bezorgmethode van binnenkomende e-mail voor de gebruiker.';
            Caption = 'Incoming Email Delivery Method';
            InitValue = MicrosoftDynamics365ForOutlook;
            OptionMembers = None,MicrosoftDynamics365ForOutlook,"Server-SideSynchronizationOrEmailRouter",ForwardMailbox;
            OptionOrdinalValues = 0, 1, 2, 3;
        }
        field(111; OutgoingEmailDeliveryMethod; Option)
        {
            ExternalName = 'outgoingemaildeliverymethod';
            ExternalType = 'Picklist';
            Description = 'Bezorgmethode van uitgaande e-mail voor de gebruiker.';
            Caption = 'Outgoing Email Delivery Method';
            InitValue = MicrosoftDynamics365ForOutlook;
            OptionMembers = None,MicrosoftDynamics365ForOutlook,"Server-SideSynchronizationOrEmailRouter";
            OptionOrdinalValues = 0, 1, 2;
        }
        field(112; ImportSequenceNumber; Integer)
        {
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
            ExternalAccess = Insert;
            Description = 'Unieke id van de gegevensimport of -migratie waarmee deze record is gemaakt.';
            Caption = 'Import Sequence Number';
        }
        field(113; AccessMode; Option)
        {
            ExternalName = 'accessmode';
            ExternalType = 'Picklist';
            Description = 'Type gebruiker.';
            Caption = 'Access Mode';
            InitValue = "Read-Write";
            OptionMembers = "Read-Write",Administrative,Read,SupportUser,"Non-interactive",DelegatedAdmin;
            OptionOrdinalValues = 0, 1, 2, 3, 4, 5;
        }
        field(114; InviteStatusCode; Option)
        {
            ExternalName = 'invitestatuscode';
            ExternalType = 'Picklist';
            Description = 'Status van de uitnodiging voor de gebruiker.';
            Caption = 'Invitation Status';
            InitValue = InvitationNotSent;
            OptionMembers = InvitationNotSent,Invited,InvitationNearExpired,InvitationExpired,InvitationAccepted,InvitationRejected,InvitationRevoked;
            OptionOrdinalValues = 0, 1, 2, 3, 4, 5, 6;
        }
        field(116; OverriddenCreatedOn; Date)
        {
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
            ExternalAccess = Insert;
            Description = 'De datum en het tijdstip waarop de record is gemigreerd.';
            Caption = 'Record Created On';
        }
        field(117; UTCConversionTimeZoneCode; Integer)
        {
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            Description = 'Tijdzonecode die is gebruikt toen de record werd gemaakt.';
            Caption = 'UTC Conversion Time Zone Code';
        }
        field(118; TimeZoneRuleVersionNumber; Integer)
        {
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            Description = 'Uitsluitend voor intern gebruik.';
            Caption = 'Time Zone Rule Version Number';
        }
        field(124; YomiFullName; Text[200])
        {
            ExternalName = 'yomifullname';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = 'Uitspraak van de volledige naam van de gebruiker, geschreven in fonetische hiragana- of katakanatekens.';
            Caption = 'Yomi Full Name';
        }
        field(126; YomiLastName; Text[64])
        {
            ExternalName = 'yomilastname';
            ExternalType = 'String';
            Description = 'Uitspraak van de achternaam van de gebruiker, geschreven in fonetische hiragana- of katakanatekens.';
            Caption = 'Yomi Last Name';
        }
        field(128; YomiMiddleName; Text[50])
        {
            ExternalName = 'yomimiddlename';
            ExternalType = 'String';
            Description = 'Uitspraak van de tweede voornaam van de gebruiker, geschreven in fonetische hiragana- of katakanatekens.';
            Caption = 'Yomi Middle Name';
        }
        field(129; YomiFirstName; Text[64])
        {
            ExternalName = 'yomifirstname';
            ExternalType = 'String';
            Description = 'Uitspraak van de voornaam van de gebruiker, geschreven in fonetische hiragana- of katakanatekens.';
            Caption = 'Yomi First Name';
        }
        field(130; IsIntegrationUser; Boolean)
        {
            ExternalName = 'isintegrationuser';
            ExternalType = 'Boolean';
            Description = 'Controleer of de gebruiker een Integration-gebruiker is.';
            Caption = 'Integration user mode';
        }
        field(131; DefaultFiltersPopulated; Boolean)
        {
            ExternalName = 'defaultfilterspopulated';
            ExternalType = 'Boolean';
            ExternalAccess = Read;
            Description = 'Geeft aan of de standaardfilters voor Outlook zijn ingevuld.';
            Caption = 'Default Filters Populated';
        }
        field(133; CreatedOnBehalfBy; GUID)
        {
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gemachtigde gebruiker die de systeemgebruiker heeft gemaakt.';
            Caption = 'Created By (Delegate)';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(137; ModifiedOnBehalfBy; GUID)
        {
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gemachtigde gebruiker die de systeemgebruiker het laatst heeft gewijzigd.';
            Caption = 'Modified By (Delegate)';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(139; ModifiedOnBehalfByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ModifiedOnBehalfBy)));
            ExternalName = 'modifiedonbehalfbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(141; CreatedOnBehalfByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(CreatedOnBehalfBy)));
            ExternalName = 'createdonbehalfbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(143; EmailRouterAccessApproval; Option)
        {
            ExternalName = 'emailrouteraccessapproval';
            ExternalType = 'Picklist';
            ExternalAccess = Modify;
            Description = 'Geeft de status weer van het primaire e-mailadres.';
            Caption = 'Primary Email Status';
            InitValue = Empty;
            OptionMembers = Empty,Approved,PendingApproval,Rejected;
            OptionOrdinalValues = 0, 1, 2, 3;
        }
        field(147; ExchangeRate; Decimal)
        {
            ExternalName = 'exchangerate';
            ExternalType = 'Decimal';
            ExternalAccess = Read;
            Description = 'Wisselkoers van de valuta die is gekoppeld aan de systeemgebruiker ten aanzien van de basisvaluta.';
            Caption = 'Exchange Rate';
        }
        field(148; CALType; Option)
        {
            ExternalName = 'caltype';
            ExternalType = 'Picklist';
            Description = 'Het licentietype van de gebruiker.';
            Caption = 'License Type';
            InitValue = Professional;
            OptionMembers = Professional,Administrative,Basic,DeviceProfessional,DeviceBasic,Essential,DeviceEssential,Enterprise,DeviceEnterprise,Sales,Service,FieldService,ProjectService;
            OptionOrdinalValues = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;
        }
        field(150; IsLicensed; Boolean)
        {
            ExternalName = 'islicensed';
            ExternalType = 'Boolean';
            Description = 'Gegevens over de vraag of een gebruiker een licentie heeft.';
            Caption = 'User Licensed';
        }
        field(151; IsSyncWithDirectory; Boolean)
        {
            ExternalName = 'issyncwithdirectory';
            ExternalType = 'Boolean';
            Description = 'Gegevens over de vraag of de gebruiker is gesynchroniseerd met de map.';
            Caption = 'User Synced';
        }
        field(152; YammerEmailAddress; Text[200])
        {
            ExternalName = 'yammeremailaddress';
            ExternalType = 'String';
            Description = 'E-mailadres voor Yammer-aanmelding van gebruiker';
            Caption = 'Yammer Email';
        }
        field(154; YammerUserId; Text[128])
        {
            ExternalName = 'yammeruserid';
            ExternalType = 'String';
            Description = 'Yammer-id van gebruiker';
            Caption = 'Yammer User ID';
        }
        field(156; UserLicenseType; Integer)
        {
            ExternalName = 'userlicensetype';
            ExternalType = 'Integer';
            Description = 'Toont het licentietype van de gebruiker.';
            Caption = 'User License Type';
        }
        field(157; EntityImageId; GUID)
        {
            ExternalName = 'entityimageid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Read;
            Description = 'Uitsluitend voor intern gebruik.';
            Caption = 'Entity Image Id';
        }
        field(160; Address2_Composite; BLOB)
        {
            ExternalName = 'address2_composite';
            ExternalType = 'Memo';
            ExternalAccess = Read;
            Description = 'Toont het volledige secundaire adres.';
            Caption = 'Other Address';
            Subtype = Memo;
        }
        field(161; Address1_Composite; BLOB)
        {
            ExternalName = 'address1_composite';
            ExternalType = 'Memo';
            ExternalAccess = Read;
            Description = 'Toont het volledige primaire adres.';
            Caption = 'Address';
            Subtype = Memo;
        }
        field(162; ProcessId; GUID)
        {
            ExternalName = 'processid';
            ExternalType = 'Uniqueidentifier';
            Description = 'Toont de id van het proces.';
            Caption = 'Process';
        }
        field(163; StageId; GUID)
        {
            ExternalName = 'stageid';
            ExternalType = 'Uniqueidentifier';
            Description = 'Toont de id van de fase.';
            Caption = '(Deprecated) Process Stage';
        }
        field(165; IsEmailAddressApprovedByO365Admin; Boolean)
        {
            ExternalName = 'isemailaddressapprovedbyo365admin';
            ExternalType = 'Boolean';
            ExternalAccess = Read;
            Description = 'Toont de goedkeuringsstatus van het e-mailadres door O365 Admin.';
            Caption = 'Email Address O365 Admin Approval Status';
        }
        field(172; TraversedPath; Text[1250])
        {
            ExternalName = 'traversedpath';
            ExternalType = 'String';
            Description = 'Alleen voor intern gebruik.';
            Caption = '(Deprecated) Traversed Path';
        }
        field(173; SharePointEmailAddress; Text[1024])
        {
            ExternalName = 'sharepointemailaddress';
            ExternalType = 'String';
            Description = 'Zakelijk SharePoint-mailadres';
            Caption = 'SharePoint Email Address';
        }
        field(181; DefaultOdbFolderName; Text[200])
        {
            ExternalName = 'defaultodbfoldername';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = 'Typ een standaard mapnaam voor de locatie van OneDrive voor Bedrijven van de gebruiker.';
            Caption = 'Default OneDrive for Business Folder Name';
        }
        field(182; ApplicationId; GUID)
        {
            ExternalName = 'applicationid';
            ExternalType = 'Uniqueidentifier';
            Description = 'De id voor de toepassing. Deze wordt gebruikt om toegang te krijgen tot gegevens in een andere toepassing.';
            Caption = 'Application ID';
        }
        field(183; ApplicationIdUri; Text[1024])
        {
            ExternalName = 'applicationiduri';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = 'De URI die wordt gebruikt als unieke logische id voor de externe app. Deze kan worden gebruikt voor het valideren van de toepassing.';
            Caption = 'Application ID URI';
        }
        field(184; AzureActiveDirectoryObjectId; GUID)
        {
            ExternalName = 'azureactivedirectoryobjectid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Read;
            Description = 'Dit is de id voor het directory-object van de toepassing.';
            Caption = 'Azure AD Object ID';
        }
        field(185; IdentityId; Integer)
        {
            ExternalName = 'identityid';
            ExternalType = 'Integer';
            ExternalAccess = Read;
            Description = 'Uitsluitend voor intern gebruik.';
            Caption = 'Unique user identity id';
        }
        field(187; UserPuid; Text[100])
        {
            ExternalName = 'userpuid';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = ' Door gebruiker identificeerbare gegevens in gebruikers-PUID';
            Caption = 'User PUID';
        }
        field(10004; DeletedState; Option)
        {
            ExternalName = 'deletedstate';
            ExternalType = 'Picklist';
            ExternalAccess = Read;
            Description = 'User delete state';
            Caption = 'Deleted State';
            InitValue = NotDeleted;
            OptionMembers = NotDeleted,SoftDeleted;
            OptionOrdinalValues = 0, 1;
        }
        field(10006; AzureState; Option)
        {
            ExternalName = 'azurestate';
            ExternalType = 'Picklist';
            ExternalAccess = Modify;
            Description = 'Azure state of user';
            Caption = 'Azure State';
            InitValue = Exists;
            OptionMembers = Exists,SoftDeleted,NotFoundOrHardDeleted;
            OptionOrdinalValues = 0, 1, 2;
        }
        field(10008; AzureDeletedOn; Datetime)
        {
            ExternalName = 'azuredeletedon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'Date and time when the user was set as soft deleted in Azure.';
            Caption = 'Azure Deleted On';
        }
    }
    keys
    {
        key(PK; SystemUserId)
        {
            Clustered = true;
        }
        key(Name; FullName)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; FullName)
        {
        }
    }
}