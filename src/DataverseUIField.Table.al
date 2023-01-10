table 70101 "Dataverse UI Field"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Mapping Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse UI Table"."Mapping Name";
            Caption = 'Mapping Name';
        }
        field(20; "BC Table"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse UI Table"."BC Table";
            Caption = 'BC Table';
        }
        field(30; "BC Table Caption"; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" Where("Object ID" = Field("BC Table")));
            Caption = 'BC Table Caption';
            FieldClass = FlowField;
        }
        field(40; "BC Field"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("BC Table"));
            Caption = 'BC Field';

            trigger OnValidate()
            var
                Fld: Record Field;
                DataverseUITable: Record "Dataverse UI Table";
            begin
                DataverseUITable.Get("Mapping Name");
                rec."Dataverse Table" := DataverseUITable."Dataverse Table";
                Fld.Get(Rec."BC Table", Rec."BC Field");
                CheckFieldTypeForSync(Fld);
            end;
        }
        field(50; "BC Field Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" Where(TableNo = Field("BC Table"),
                                                             "No." = Field("BC Field")));
            Caption = 'BC Field Caption';
            FieldClass = FlowField;
        }
        field(60; "Dataverse Table"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse UI Table"."Dataverse Table";
            Caption = 'Dataverse Table';
        }
        field(70; "Dataverse Table Caption"; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" Where("Object ID" = Field("Dataverse Table")));
            Caption = 'Dataverse Table Caption';
            FieldClass = FlowField;
        }
        field(80; "Dataverse Field"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse Table"));
            Caption = 'Dataverse Field';

            trigger OnValidate()
            var
                FldBC: Record Field;
                FldDataverse: Record Field;
            begin
                FldBC.Get(Rec."BC Table", Rec."BC Field");
                FldDataverse.Get(Rec."Dataverse Table", Rec."Dataverse Field");

                CompareFieldType(FldBC, FldDataverse);

                rec."Dataverse Field Added" := true;
            end;
        }
        field(90; "Dataverse Field Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" Where(TableNo = Field("Dataverse Table"),
                                                             "No." = Field("Dataverse Field")));
            Caption = 'Dataverse Field Caption';
            FieldClass = FlowField;
        }
        field(100; "Sync Direction"; Enum "Dataverse UI Sync Direct.")
        {
            DataClassification = ToBeClassified;
            Caption = 'Sync Direction';
        }
        field(110; "Const Value"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Const Value';
        }
        field(120; "Validate Field"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Validate Field';
        }
        field(130; "Validate Integr Table Field"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Validate Integration Table Field';
        }
        field(140; "Field on CDS Page"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field where(TableNo = const(70105));
            Caption = 'Field on CDS Page';
        }
        field(150; "Dataverse Field Added"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Dataverse Field Added';
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
        FieldTypeNotSupportedErr: Label 'The field %1 of type %2 is not supported.', Comment = '%1 = field name, %2 = field type';
        FieldTypeNotTheSameErr: label 'The field %1 with type %2 must be the same as type %3.';
        FieldClassNormalErr: label 'Only fields with class normal can be added.';

    internal procedure CompareFieldType(FldBC: Record Field; FldDataverse: Record Field)
    begin
        if (FldBC.Type = FldBC.Type::Code) and (FldDataverse.Type = FldDataverse.Type::Text) then
            exit;
        if FldBC.Type <> FldDataverse.Type then
            Error(FieldTypeNotTheSameErr, FldDataverse."Field Caption", FldDataverse.Type, FldBC.Type);
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
            Fld.Type::Guid,
            Fld.Type::Integer,
            Fld.Type::Option,
            Fld.Type::Text:
                exit;
        end;
        Error(FieldTypeNotSupportedErr, Fld."Field Caption", Fld.Type);
    end;

    [TryFunction]
    internal procedure CanFieldBeInserted(Fld: Record Field)
    begin
        CheckFieldTypeForSync(Fld);
    end;

    internal procedure MapFields(MappingName: Code[20]; BCTable: Integer; DataverseTable: Integer)
    var
        lDataverseUIField: Record "Dataverse UI Field";
        DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
        Fld: Record Field;
    begin
        if DataverseTable = 0 then
            exit;

        lDataverseUIField.Reset;
        lDataverseUIField.SetRange("Mapping Name", MappingName);
        lDataverseUIField.SetRange("BC Table", BCTable);
        if lDataverseUIField.FindSet() then
            repeat
                lDataverseUIField.CalcFields("BC Field Caption");

                Fld.Reset;
                Fld.SetRange(TableNo, DataverseTable);
                Fld.SetFilter(FieldName, '%1', '*' + DataverseUIDataverseIntegr.GetDataverseCompliantName(lDataverseUIField."BC Field Caption"));
                if Fld.FindFirst() then
                    lDataverseUIField."Dataverse Field" := Fld."No.";
                lDataverseUIField.Modify(true);
            until lDataverseUIField.Next = 0;
    end;
}