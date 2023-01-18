table 70100 "Dataverse UI Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Mapping Name"; Code[20])
        {
            Caption = 'Mapping Name';
            DataClassification = ToBeClassified;
        }
        field(20; "BC Table"; Integer)
        {
            Caption = 'BC Table';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object Subtype" = const('Normal'));
        }
        field(30; "BC Table Caption"; Text[100])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("BC Table")));
            Caption = 'BC Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Dataverse Table"; Integer)
        {
            Caption = 'Dataverse Table';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object Subtype" = const('CRM'));

            trigger OnValidate()
            var
                DataverseUIField: Record "Dataverse UI Field";
            begin
                DataverseUIField.Reset();
                DataverseUIField.SetRange("Mapping Name", Rec."Mapping Name");
                DataverseUIField.SetRange("BC Table", Rec."BC Table");
                DataverseUIField.SetFilter("Dataverse Field", '<>%1', 0);
                if not DataverseUIField.IsEmpty then
                    Error(ErrorDataverseTableErr);

                DataverseUIField.Reset();
                DataverseUIField.SetRange("Mapping Name", Rec."Mapping Name");
                DataverseUIField.SetRange("BC Table", Rec."BC Table");
                if DataverseUIField.FindSet() then
                    repeat
                        DataverseUIField."Dataverse Table" := Rec."Dataverse Table";
                        DataverseUIField.Modify(true);
                    until DataverseUIField.Next() = 0;
            end;
        }
        field(50; "Dataverse Table Caption"; Text[100])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("Dataverse Table")));
            Caption = 'Dataverse Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Dataverse UID"; Integer)
        {
            Caption = 'Dataverse UID';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse Table"));
        }
        field(70; "Dataverse UID Caption"; Text[100])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Dataverse Table"),
                                                             "No." = field("Dataverse UID")));
            Caption = 'Dataverse UID Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Modified Field"; Integer)
        {
            Caption = 'Modified Field';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." where(TableNo = field("Dataverse Table"));
        }
        field(90; "Modified Field Caption"; Text[100])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Dataverse Table"),
                                                             "No." = field("Modified Field")));
            Caption = 'Modified Field Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Sync Only Coupled Records"; Boolean)
        {
            Caption = 'Sync Only Coupled Records';
            DataClassification = ToBeClassified;
        }
        field(110; "Table Name Dataverse"; Text[100])
        {
            Caption = 'Table Name Dataverse';
            DataClassification = ToBeClassified;
        }
        field(120; "Sync Direction"; Enum "Dataverse UI Sync Direct.")
        {
            Caption = 'Sync Direction';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Mapping Name")
        {
            Clustered = true;
        }
    }
    var
        ErrorDataverseTableErr: Label 'You cannot change the Dataverse table because there are fields assigned.';

    trigger OnDelete()
    var
        DataverseUIField: Record "Dataverse UI Field";
    begin
        DataverseUIField.Reset();
        DataverseUIField.SetRange("Mapping Name", "Mapping Name");
        DataverseUIField.DeleteAll();
    end;

    procedure CreateJobQueueEntry(var IntegrationTableMapping: Record "Integration Table Mapping"; JobCodeunitId: Integer; JobDescription: Text)
    var
        JobQueueEntry: Record "Job Queue Entry";
        StartTime: DateTime;
        JobQueueCategoryLbl: Label 'BCI INTEG', Locked = true;
    begin
        StartTime := CurrentDateTime() + 1000;
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", JobCodeunitId);
        JobQueueEntry.SetRange("Record ID to Process", IntegrationTableMapping.RecordId());
        JobQueueEntry.SetRange("Job Queue Category Code", JobQueueCategoryLbl);
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Ready);
        JobQueueEntry.SetFilter("Earliest Start Date/Time", '<=%1', StartTime);
        if not JobQueueEntry.IsEmpty() then begin
            JobQueueEntry.DeleteTasks();
            Commit();
        end;

        JobQueueEntry.Init();
        Clear(JobQueueEntry.ID); // "Job Queue - Enqueue" is to define new ID
        JobQueueEntry."Earliest Start Date/Time" := StartTime;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := JobCodeunitId;
        JobQueueEntry."Record ID to Process" := IntegrationTableMapping.RecordId();
        JobQueueEntry."Run in User Session" := false;
        JobQueueEntry."Notify On Success" := false;
        JobQueueEntry."Maximum No. of Attempts to Run" := 2;
        JobQueueEntry."Job Queue Category Code" := JobQueueCategoryLbl;
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry."Rerun Delay (sec.)" := 30;
        JobQueueEntry."No. of Minutes between Runs" := 30;
        JobQueueEntry.Description := CopyStr(JobDescription, 1, MaxStrLen(JobQueueEntry.Description));
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Inactivity Timeout Period" := 720;
        JobQueueEntry.Insert(true);
    end;
}