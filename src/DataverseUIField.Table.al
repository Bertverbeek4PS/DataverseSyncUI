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
        field(15; "Order No."; Integer)
        {
            Caption = 'Order No.';
            DataClassification = ToBeClassified;
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
        field(35; "Primary Key"; Boolean)
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(40; "BC Field"; Integer)
        {
            Caption = 'BC Field';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("BC Table"),
                                                type = filter(BigInteger | Boolean | Code | Date | DateFormula | DateFormula | Decimal | Duration | GUID | Integer | Option | Text));

            trigger OnValidate()
            var
                DataverseUITable: Record "Dataverse UI Table";
                DataverseUIField: Record "Dataverse UI Field";
                Fld: Record Field;
            begin
                DataverseUITable.Get("Mapping Name");
                Rec."Dataverse Table" := DataverseUITable."Dataverse Table";
                Fld.Get(Rec."BC Table", Rec."BC Field");
                CheckFieldTypeForSync(Fld);

                if Fld.IsPartOfPrimaryKey then
                    Rec."Primary Key" := true;

                //Sets order
                DataverseUIField.SetCurrentKey("Order No.", "Mapping Name", "BC Table", "BC Field");
                DataverseUIField.SetRange("Mapping Name", Rec."Mapping Name");
                DataverseUIField.SetRange("BC Table", Rec."BC Table");
                If DataverseUIField.FindLast() then
                    Rec."Order No." := DataverseUIField."Order No." + 1
                else
                    Rec."Order No." := 1;
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
        key(Key2; "Order No.", "Mapping Name", "BC Table", "BC Field")
        {
        }
    }

    var
        FieldClassNormalErr: Label 'Only fields with class normal can be added.';
        FieldTypeNotSupportedErr: Label 'The field %1 of type %2 is not supported.', Comment = '%1 = field name, %2 = field type';
        FieldTypeNotTheSameErr: Label 'The field %1 with type %2 must be the same as type %3.', Comment = '%1 = field name, %2 = field type, %3 = field type';

    [TryFunction]
    internal procedure CanFieldBeInserted(FieldRec: Record Field)
    begin
        CheckFieldTypeForSync(FieldRec);
    end;

    internal procedure CheckFieldTypeForSync(FieldRec: Record Field)
    begin
        if FieldRec.Class <> FieldRec.Class::Normal then
            Error(FieldClassNormalErr);

        case FieldRec.Type of
            FieldRec.Type::BigInteger,
            FieldRec.Type::Boolean,
            FieldRec.Type::Code,
            FieldRec.Type::Date,
            FieldRec.Type::DateFormula,
            FieldRec.Type::DateTime,
            FieldRec.Type::Decimal,
            FieldRec.Type::Duration,
            FieldRec.Type::GUID,
            FieldRec.Type::Integer,
            FieldRec.Type::Option,
            FieldRec.Type::Text:
                exit;
        end;
        Error(FieldTypeNotSupportedErr, FieldRec."Field Caption", FieldRec.Type);
    end;

    internal procedure CompareFieldType(FieldBC: Record Field; FieldDataverse: Record Field)
    begin
        if (FieldBC.Type = FieldBC.Type::Code) and (FieldDataverse.Type = FieldDataverse.Type::Text) then
            exit;
        if FieldBC.Type <> FieldDataverse.Type then
            Error(FieldTypeNotTheSameErr, FieldDataverse."Field Caption", FieldDataverse.Type, FieldBC.Type);
    end;

    [TryFunction]
    local procedure TryCompareFieldType(FieldBC: Record Field; FieldDataverse: Record Field)
    begin
        CompareFieldType(FieldBC, FieldDataverse);
    end;

    internal procedure MapFields(MappingName: Code[20]; BCTable: Integer; DataverseTable: Integer)
    var
        DataverseUIFieldsMap: Record "Dataverse UI Field";
        FieldRec: Record Field;
        FieldName: Record Field;
        DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
    begin
        if DataverseTable = 0 then
            exit;

        DataverseUIFieldsMap.Reset();
        DataverseUIFieldsMap.SetRange("Mapping Name", MappingName);
        DataverseUIFieldsMap.SetRange("BC Table", BCTable);
        DataverseUIFieldsMap.SetRange("Dataverse Field", 0);
        if DataverseUIFieldsMap.FindSet() then
            repeat
                FieldName.Get(DataverseUIFieldsMap."BC Table", DataverseUIFieldsMap."BC Field");

                FieldRec.Reset();
                FieldRec.SetRange(TableNo, DataverseTable);
                FieldRec.SetFilter(FieldName, '%1', '*' + DataverseUIDataverseIntegr.GetDataverseCompliantName(FieldName.FieldName) + '*');
                if FieldRec.FindFirst() then
                    if TryCompareFieldType(FieldName, FieldRec) then begin
                        DataverseUIFieldsMap.Validate("Dataverse Field", FieldRec."No.");
                        DataverseUIFieldsMap.Modify(true);
                    end;
            until DataverseUIFieldsMap.Next() = 0;
    end;
}