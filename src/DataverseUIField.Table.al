table 70101 "Dataverse UI Field"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Mapping Name"; Code[20])
        {
            Caption = 'Mapping Name';
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse UI Table"."Mapping Name";
        }
        field(20; "BC Table"; Integer)
        {
            Caption = 'BC Table';
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse UI Table"."BC Table";
        }
        field(30; "BC Table Caption"; Text[100])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("BC Table")));
            Caption = 'BC Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "BC Field"; Integer)
        {
            Caption = 'BC Field';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("BC Table"));

            trigger OnValidate()
            var
                DataverseUITable: Record "Dataverse UI Table";
                Fld: Record Field;
            begin
                DataverseUITable.Get("Mapping Name");
                Rec."Dataverse Table" := DataverseUITable."Dataverse Table";
                Fld.Get(Rec."BC Table", Rec."BC Field");
                CheckFieldTypeForSync(Fld);
            end;
        }
        field(50; "BC Field Caption"; Text[100])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("BC Table"),
                                                             "No." = field("BC Field")));
            Caption = 'BC Field Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Dataverse Table"; Integer)
        {
            Caption = 'Dataverse Table';
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse UI Table"."Dataverse Table";
        }
        field(70; "Dataverse Table Caption"; Text[100])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("Dataverse Table")));
            Caption = 'Dataverse Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Dataverse Field"; Integer)
        {
            Caption = 'Dataverse Field';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse Table"));

            trigger OnValidate()
            var
                FldBC: Record Field;
                FldDataverse: Record Field;
            begin
                FldBC.Get(Rec."BC Table", Rec."BC Field");
                FldDataverse.Get(Rec."Dataverse Table", Rec."Dataverse Field");

                CompareFieldType(FldBC, FldDataverse);

                Rec."Dataverse Field Added" := true;
            end;
        }
        field(90; "Dataverse Field Caption"; Text[100])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Dataverse Table"),
                                                             "No." = field("Dataverse Field")));
            Caption = 'Dataverse Field Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Sync Direction"; Enum "Dataverse UI Sync Direct.")
        {
            Caption = 'Sync Direction';
            DataClassification = ToBeClassified;
        }
        field(110; "Const Value"; Text[50])
        {
            Caption = 'Const Value';
            DataClassification = ToBeClassified;
        }
        field(120; "Validate Field"; Boolean)
        {
            Caption = 'Validate Field';
            DataClassification = ToBeClassified;
        }
        field(130; "Validate Integr Table Field"; Boolean)
        {
            Caption = 'Validate Integration Table Field';
            DataClassification = ToBeClassified;
        }
        field(140; "Field on CDS Page"; Integer)
        {
            Caption = 'Field on CDS Page';
            DataClassification = ToBeClassified;
            TableRelation = Field where(TableNo = const(70105));
        }
        field(150; "Dataverse Field Added"; Boolean)
        {
            Caption = 'Dataverse Field Added';
            DataClassification = ToBeClassified;
        }
        field(160; "Dataverse Lookup Table"; Integer)
        {
            Caption = 'Dataverse Lookup Table';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object Subtype" = const('CRM'));

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
            begin
                if Rec."Dataverse Lookup Table" <> 0 then begin
                    if xRec."Dataverse Lookup Table" <> Rec."Dataverse Lookup Table" then begin
                        AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, Rec."Dataverse Lookup Table");
                        Rec."Dataverse Lookup Table Caption" := DelChr(LowerCase(AllObjWithCaption."Object Name"), '<>', 'cds ');
                    end;
                end else
                    Rec."Dataverse Lookup Field" := 0;
            end;
        }
        field(165; "Dataverse Lookup Table Caption"; Text[30])
        {
            Caption = 'Dataverse Lookup Table Caption';
            DataClassification = ToBeClassified;
        }
        field(170; "Dataverse Lookup Field"; Integer)
        {
            Caption = 'Dataverse Lookup Field';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse Lookup Table"));

            trigger OnValidate()
            var
                Fld: Record Field;
            begin
                if xRec."Dataverse Lookup Field" <> Rec."Dataverse Lookup Field" then begin
                    Fld.Get(Rec."Dataverse Lookup Table", Rec."Dataverse Lookup Field");
                    Rec."Dataverse Lookup Field Caption" := LowerCase(Fld.FieldName);
                end;
            end;
        }
        field(180; "Dataverse Lookup Field Caption"; Text[100])
        {
            Caption = 'Dataverse Lookup Field Caption';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Mapping Name", "BC Table", "BC Field")
        {
            Clustered = true;
        }
    }

    var
        FieldClassNormalErr: Label 'Only fields with class normal can be added.';
        FieldTypeNotSupportedErr: Label 'The field %1 of type %2 is not supported.', Comment = '%1 = field name, %2 = field type';
        FieldTypeNotTheSameErr: Label 'The field %1 with type %2 must be the same as type %3.';

    [TryFunction]
    internal procedure CanFieldBeInserted(Fld: Record Field)
    begin
        CheckFieldTypeForSync(Fld);
    end;

    internal procedure CheckFieldTypeForSync(Fld: Record Field)
    begin
        if Fld.Class <> Fld.Class::Normal then
            Error(FieldClassNormalErr);

        case Fld.Type of
            Fld.Type::BigInteger,
            Fld.Type::Boolean,
            Fld.Type::Code,
            Fld.Type::Date,
            Fld.Type::DateFormula,
            Fld.Type::DateTime,
            Fld.Type::Decimal,
            Fld.Type::Duration,
            Fld.Type::GUID,
            Fld.Type::Integer,
            Fld.Type::Option,
            Fld.Type::Text:
                exit;
        end;
        Error(FieldTypeNotSupportedErr, Fld."Field Caption", Fld.Type);
    end;

    internal procedure CompareFieldType(FldBC: Record Field; FldDataverse: Record Field)
    begin
        if (FldBC.Type = FldBC.Type::Code) and (FldDataverse.Type = FldDataverse.Type::Text) then
            exit;
        if FldBC.Type <> FldDataverse.Type then
            Error(FieldTypeNotTheSameErr, FldDataverse."Field Caption", FldDataverse.Type, FldBC.Type);
    end;

    internal procedure MapFields(MappingName: Code[20]; BCTable: Integer; DataverseTable: Integer)
    var
        DataverseUIFieldsMap: Record "Dataverse UI Field";
        Fld: Record Field;
        FldName: Record Field;
        DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
    begin
        if DataverseTable = 0 then
            exit;

        DataverseUIFieldsMap.Reset;
        DataverseUIFieldsMap.SetRange("Mapping Name", MappingName);
        DataverseUIFieldsMap.SetRange("BC Table", BCTable);
        if DataverseUIFieldsMap.FindSet() then
            repeat
                FldName.Get(DataverseUIFieldsMap."BC Table", DataverseUIFieldsMap."BC Field");

                Fld.Reset;
                Fld.SetRange(TableNo, DataverseTable);
                Fld.SetFilter(FieldName, '%1', '*' + DataverseUIDataverseIntegr.GetDataverseCompliantName(FldName.FieldName));
                if Fld.FindFirst() then
                    DataverseUIFieldsMap."Dataverse Field" := Fld."No.";
                DataverseUIFieldsMap.Modify(true);
            until DataverseUIFieldsMap.Next = 0;
    end;
}