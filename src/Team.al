table 70104 "CDS Team"
{
    ExternalName = 'team';
    TableType = CDS;
    Description = 'Een verzameling systeemgebruikers die routinematig samenwerken. Teams kunnen worden gebruikt voor het vereenvoudigen van het delen van records, en hiermee kunnen teamleden gemeenschappelijke toegang krijgen tot organisatiegegevens als ze deel uitmaken van verschillende business units.';

    fields
    {
        field(1; TeamId; GUID)
        {
            ExternalName = 'teamid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'De unieke id voor het team.';
            Caption = 'Team';
        }
        field(3; OrganizationId; GUID)
        {
            ExternalName = 'organizationid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Read;
            Description = 'De unieke id van de organisatie die aan het team is gekoppeld.';
            Caption = 'Organization ';
        }
        field(5; Name; Text[160])
        {
            ExternalName = 'name';
            ExternalType = 'String';
            Description = 'De naam van het team.';
            Caption = 'Team Name';
        }
        field(6; Description; BLOB)
        {
            ExternalName = 'description';
            ExternalType = 'Memo';
            Description = 'De beschrijving van het team.';
            Caption = 'Description';
            Subtype = Memo;
        }
        field(7; EMailAddress; Text[100])
        {
            ExternalName = 'emailaddress';
            ExternalType = 'String';
            Description = 'Het e-mailadres voor het team.';
            Caption = 'Email';
        }
        field(8; CreatedOn; Datetime)
        {
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'De datum en het tijdstip waarop het team is gemaakt.';
            Caption = 'Created On';
        }
        field(9; ModifiedOn; Datetime)
        {
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'De datum en het tijdstip waarop het team het laatst is gewijzigd.';
            Caption = 'Modified On';
        }
        field(10; CreatedBy; GUID)
        {
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gebruiker die het team heeft gemaakt.';
            Caption = 'Created By';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(12; ModifiedBy; GUID)
        {
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gebruiker die het team het laatst heeft gewijzigd.';
            Caption = 'Modified By';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(14; VersionNumber; BigInteger)
        {
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
            ExternalAccess = Read;
            Description = 'Het versienummer van het team.';
            Caption = 'Version number';
        }
        field(15; CreatedByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(CreatedBy)));
            ExternalName = 'createdbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(17; ModifiedByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ModifiedBy)));
            ExternalName = 'modifiedbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(23; ImportSequenceNumber; Integer)
        {
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
            ExternalAccess = Insert;
            Description = 'Unieke id van de gegevensimport of -migratie waarmee deze record is gemaakt.';
            Caption = 'Import Sequence Number';
        }
        field(24; OverriddenCreatedOn; Date)
        {
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
            ExternalAccess = Insert;
            Description = 'De datum en het tijdstip waarop de record is gemigreerd.';
            Caption = 'Record Created On';
        }
        field(27; AdministratorId; GUID)
        {
            ExternalName = 'administratorid';
            ExternalType = 'Lookup';
            Description = 'De unieke id van de gebruiker die de hoofdverantwoordelijke is voor het team.';
            Caption = 'Administrator';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(28; IsDefault; Boolean)
        {
            ExternalName = 'isdefault';
            ExternalType = 'Boolean';
            ExternalAccess = Read;
            Description = 'Geeft aan of het team een standaardteam is voor de business unit.';
            Caption = 'Is Default';
        }
        field(31; AdministratorIdName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(AdministratorId)));
            ExternalName = 'administratoridname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(34; YomiName; Text[160])
        {
            ExternalName = 'yominame';
            ExternalType = 'String';
            Description = 'Uitspraak van de volledige naam van het team, geschreven in fonetische hiragana- of katakanatekens.';
            Caption = 'Yomi Name';
        }
        field(35; CreatedOnBehalfBy; GUID)
        {
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gemachtigde gebruiker die het team heeft gemaakt.';
            Caption = 'Created By (Delegate)';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(37; CreatedOnBehalfByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(CreatedOnBehalfBy)));
            ExternalName = 'createdonbehalfbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(39; ModifiedOnBehalfBy; GUID)
        {
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gemachtigde gebruiker die het team het laatst heeft gewijzigd.';
            Caption = 'Modified By (Delegate)';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(41; ModifiedOnBehalfByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ModifiedOnBehalfBy)));
            ExternalName = 'modifiedonbehalfbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(43; TraversedPath; Text[1250])
        {
            ExternalName = 'traversedpath';
            ExternalType = 'String';
            Description = 'Alleen voor intern gebruik.';
            Caption = '(Deprecated) Traversed Path';
        }
        field(44; AzureActiveDirectoryObjectId; GUID)
        {
            ExternalName = 'azureactivedirectoryobjectid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'Het object-id voor een groep in Azure Active Directory.';
            Caption = 'Azure AD Object Id for a group';
        }
        field(100; ExchangeRate; Decimal)
        {
            ExternalName = 'exchangerate';
            ExternalType = 'Decimal';
            ExternalAccess = Read;
            Description = 'Wisselkoers van de valuta die is gekoppeld aan het team ten aanzien van de basisvaluta.';
            Caption = 'Exchange Rate';
        }
        field(102; TeamType; Option)
        {
            ExternalName = 'teamtype';
            ExternalType = 'Picklist';
            ExternalAccess = Insert;
            Description = 'Selecteer het teamtype.';
            Caption = 'Team Type';
            InitValue = Owner;
            OptionMembers = Owner,Access,AADSecurityGroup,AADOfficeGroup;
            OptionOrdinalValues = 0, 1, 2, 3;
        }
        field(106; SystemManaged; Boolean)
        {
            ExternalName = 'systemmanaged';
            ExternalType = 'Boolean';
            ExternalAccess = Read;
            Description = 'Selecteer of het team door het systeem zal worden beheerd.';
            Caption = 'Is System Managed';
        }
        field(109; StageId; GUID)
        {
            ExternalName = 'stageid';
            ExternalType = 'Uniqueidentifier';
            Description = 'Toont de id van de fase.';
            Caption = '(Deprecated) Process Stage';
        }
        field(110; ProcessId; GUID)
        {
            ExternalName = 'processid';
            ExternalType = 'Uniqueidentifier';
            Description = 'Toont de id van het proces.';
            Caption = 'Process';
        }
        field(10000; MembershipType; Option)
        {
            ExternalName = 'membershiptype';
            ExternalType = 'Picklist';
            ExternalAccess = Insert;
            Caption = 'Membership Type';
            InitValue = MembersAndGuests;
            OptionMembers = MembersAndGuests,Members,Owners,Guests;
            OptionOrdinalValues = 0, 1, 2, 3;
        }
        field(10002; ShareLinkQualifier; Text[1250])
        {
            ExternalName = 'sharelinkqualifier';
            ExternalType = 'String';
            ExternalAccess = Read;
            Description = 'For internal use only.';
            Caption = 'Share Link Qualifier';
        }
        field(10004; IsSasTokenSet; Boolean)
        {
            ExternalName = 'issastokenset';
            ExternalType = 'Boolean';
            ExternalAccess = Read;
        }
    }
    keys
    {
        key(PK; TeamId)
        {
            Clustered = true;
        }
        key(Name; Name)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Name)
        {
        }
    }
}