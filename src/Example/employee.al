table 70102 "CDS new_employee"
{
    ExternalName = 'new_employee';
    TableType = CDS;
    Description = '';

    fields
    {
        field(1; new_employeeId; GUID)
        {
            ExternalName = 'new_employeeid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'Unieke id van entiteitsexemplaren';
            Caption = 'employee';
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
            Description = 'De unieke id van de gebruiker die de record heeft gemaakt.';
            Caption = 'Created By';
            TableRelation = "CDS SystemUser".SystemUserId;
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
            Description = 'De unieke id van de gebruiker die de record heeft gewijzigd.';
            Caption = 'Modified By';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(6; CreatedOnBehalfBy; GUID)
        {
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gemachtigde gebruiker die de record heeft gemaakt.';
            Caption = 'Created By (Delegate)';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(7; ModifiedOnBehalfBy; GUID)
        {
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'De unieke id van de gemachtigde gebruiker die de record heeft gewijzigd.';
            Caption = 'Modified By (Delegate)';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(8; CreatedByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(CreatedBy)));
            ExternalName = 'createdbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(10; CreatedOnBehalfByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(CreatedOnBehalfBy)));
            ExternalName = 'createdonbehalfbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(12; ModifiedByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ModifiedBy)));
            ExternalName = 'modifiedbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(14; ModifiedOnBehalfByName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CDS SystemUser".FullName where(SystemUserId = field(ModifiedOnBehalfBy)));
            ExternalName = 'modifiedonbehalfbyname';
            ExternalType = 'String';
            ExternalAccess = Read;
        }
        field(22; OwningUser; GUID)
        {
            ExternalName = 'owninguser';
            ExternalType = 'Lookup';
            ExternalAccess = Read;
            Description = 'Unieke id van de gebruiker die eigenaar is van de record.';
            Caption = 'Owning User';
            TableRelation = "CDS SystemUser".SystemUserId;
        }
        field(24; statecode; Option)
        {
            ExternalName = 'statecode';
            ExternalType = 'State';
            ExternalAccess = Modify;
            Description = 'Status van de/het employee';
            Caption = 'Status';
            InitValue = " ";
            OptionMembers = " ",Active,Inactive;
            OptionOrdinalValues = -1, 0, 1;
        }
        field(26; statuscode; Option)
        {
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            Description = 'De reden van de status van de employee';
            Caption = 'Status Reason';
            InitValue = " ";
            OptionMembers = " ",Active,Inactive;
            OptionOrdinalValues = -1, 1, 2;
        }
        field(28; VersionNumber; BigInteger)
        {
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
            ExternalAccess = Read;
            Description = 'Versienummer';
            Caption = 'Version Number';
        }
        field(29; ImportSequenceNumber; Integer)
        {
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
            ExternalAccess = Insert;
            Description = 'Volgnummer van de import waarmee deze record is gemaakt.';
            Caption = 'Import Sequence Number';
        }
        field(30; OverriddenCreatedOn; Date)
        {
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
            ExternalAccess = Insert;
            Description = 'Datum en tijdstip waarop de record is gemigreerd.';
            Caption = 'Record Created On';
        }
        field(31; TimeZoneRuleVersionNumber; Integer)
        {
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            Description = 'Alleen voor intern gebruik.';
            Caption = 'Time Zone Rule Version Number';
        }
        field(32; UTCConversionTimeZoneCode; Integer)
        {
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            Description = 'Tijdzonecode die werd gebruikt toen de record werd gemaakt.';
            Caption = 'UTC Conversion Time Zone Code';
        }
        field(33; new_Name; Text[100])
        {
            ExternalName = 'new_name';
            ExternalType = 'String';
            Description = 'Required name field';
            Caption = 'Name';
        }
        field(34; new_No; Text[100])
        {
            ExternalName = 'new_no';
            ExternalType = 'String';
            Description = '';
            Caption = 'No';
        }
        field(35; new_LastName; Text[100])
        {
            ExternalName = 'new_lastname';
            ExternalType = 'String';
            Description = '';
            Caption = 'Last Name';
        }
        field(36; new_FirstName; Text[100])
        {
            ExternalName = 'new_firstname';
            ExternalType = 'String';
            Description = '';
            Caption = 'First Name';
        }
    }
    keys
    {
        key(PK; new_employeeId)
        {
            Clustered = true;
        }
        key(Name; new_Name)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; new_Name)
        {
        }
    }
}