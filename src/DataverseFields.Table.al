table 70101 "Dataverse Field"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Mapping Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse Table"."Mapping Name";
            Caption = 'Mapping Name';
        }
        field(2; "BC Table"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse Table"."BC Table";
            Caption = 'BC Table';
        }
        field(3; "BC Table Caption"; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object ID" = FIELD("BC Table")));
            Caption = 'BC Table Caption';
            FieldClass = FlowField;
        }
        field(4; "BC Field"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("BC Table"));
            Caption = 'BC Field';

            trigger OnValidate()
            var
                Fld: Record Field;
            begin
                Fld.Get(Rec."BC Table", Rec."BC Field");
                CheckFieldTypeForSync(Fld);
            end;
        }
        field(5; "BC Field Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("BC Table"),
                                                              "No." = FIELD("BC Field")));
            Caption = 'BC Field Caption';
            FieldClass = FlowField;
        }
        field(6; "Dataverse Table"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dataverse Table"."Dataverse Table";
            Caption = 'Dataverse Table';
        }
        field(7; "Dataverse Table Caption"; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object ID" = FIELD("Dataverse Table")));
            Caption = 'Dataverse Table Caption';
            FieldClass = FlowField;
        }
        field(8; "Dataverse Field"; Integer)
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
            end;
        }
        field(9; "Dataverse Field Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Dataverse Table"),
                                                              "No." = FIELD("Dataverse Field")));
            Caption = 'Dataverse Field Caption';
            FieldClass = FlowField;
        }
        field(10; "Sync Direction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Bidirectional,ToIntegrationTable,FromIntegrationTable;
            Caption = 'Sync Direction';
        }
        field(11; "Const Value"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Const Value';
        }
        field(12; "Validate Field"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Validate Field';
        }
        field(13; "Validate Integr Table Field"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Validate Integration Table Field';
        }
        field(14; "Field on CDS Page"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field where(TableNo = const(70105));
            Caption = 'Field on CDS Page';
        }
    }

    keys
    {
        key(Key1; "Mapping Name", "BC Table", "BC Field", "Dataverse Table", "Dataverse Field")
        {
            Clustered = true;
        }
    }

    var
        FieldTypeNotSupportedErr: Label 'The field %1 of type %2 is not supported.', Comment = '%1 = field name, %2 = field type';
        FieldTypeNotTheSameErr: label 'The field %1 with type %2 must be the same as type %3';
        FieldClassNormalErr: label 'Only fields with class normal can be added.';

    procedure CompareFieldType(FldBC: Record Field; FldDataverse: Record Field)
    begin
        if (FldBC.Type = FldBC.Type::Code) and (FldDataverse.Type = FldDataverse.Type::Text) then
            exit;
        if FldBC.Type <> FldDataverse.Type then
            Error(FieldTypeNotTheSameErr, FldDataverse."Field Caption", FldDataverse.Type, FldBC.Type);
    end;

    procedure CheckFieldTypeForSync(Fld: Record Field)
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
            Fld.Type::Text,
            Fld.Type::Time:
                exit;
        end;
        Error(FieldTypeNotSupportedErr, Fld."Field Caption", Fld.Type);
    end;

}