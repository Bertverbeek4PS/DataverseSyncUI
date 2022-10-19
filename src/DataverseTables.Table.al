table 70100 "Dataverse Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Mapping Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Mapping Name';
        }
        field(2; "BC Table"; integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = CONST(Table), "Object Subtype" = CONST('Normal'));
            Caption = 'BC Table';
        }
        field(3; "BC Table Caption"; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object ID" = FIELD("BC Table")));
            Caption = 'BC Table Caption';
            FieldClass = FlowField;
        }
        field(4; "Dataverse Table"; integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = CONST(Table), "Object Subtype" = CONST('CRM'));
            Caption = 'Dataverse Table';
        }
        field(5; "Dataverse Table Caption"; Text[100])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object ID" = FIELD("Dataverse Table")));
            Caption = 'Dataverse Table Caption';
            FieldClass = FlowField;
        }
        field(6; "Dataverse UID"; integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse table"));
            Caption = 'Dataverse UID';
        }
        field(7; "Dataverse UID Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Dataverse Table"),
                                                              "No." = FIELD("Dataverse UID")));
            Caption = 'Dataverse UID Caption';
            FieldClass = FlowField;
        }
        field(8; "Modified Field"; integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse table"));
            Caption = 'Modified Field';
        }
        field(9; "Modified Field Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Dataverse Table"),
                                                              "No." = FIELD("Modified Field")));
            Caption = 'Modified Field Caption';
            FieldClass = FlowField;
        }
        field(10; "Sync Only Coupled Records"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sync Only Coupled Records';
        }
        field(11; "Table Name Dataverse"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Table Name Dataverse';
        }
        field(12; "Sync Direction"; Enum "Sync Direction")
        {
            DataClassification = ToBeClassified;
            Caption = 'Sync Direction';
        }
    }

    keys
    {
        key(Key1; "Mapping Name")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        DataverseField: Record "Dataverse Field";
    begin
        DataverseField.Reset;
        DataverseField.SetRange("Mapping Name", "Mapping Name");
        DataverseField.DeleteAll();
    end;
}