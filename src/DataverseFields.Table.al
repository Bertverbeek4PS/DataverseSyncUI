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
            TableRelation = Field where(TableNo = field("BC Table"));
            Caption = 'BC Field';
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
            TableRelation = Field where(TableNo = field("Dataverse Table"));
            Caption = 'Dataverse Field';
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

}