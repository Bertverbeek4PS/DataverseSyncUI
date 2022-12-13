page 70100 "Dataverse Tables"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dataverse Table";

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field("Mapping Name"; rec."Mapping Name")
                {
                }
                field("BC Table"; rec."BC Table")
                {
                }
                field("BC Table Caption"; rec."BC Table Caption")
                {
                }
                field("Dataverse Table"; rec."Dataverse Table")
                {
                }
                field("Dataverse Table Caption"; rec."Dataverse Table Caption")
                {
                }
                field("Table Name Dataverse"; rec."Table Name Dataverse")
                {
                }
                field("Sync Direction"; rec."Sync Direction")
                {
                }
                field("Dataverse UID"; rec."Dataverse UID")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, rec."Dataverse Table");
                        if FieldSelection.Open(Field) then begin
                            rec."Dataverse UID" := Field."No.";
                        end;
                    end;
                }
                field("Modified Field"; rec."Modified Field")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, rec."Dataverse Table");
                        if FieldSelection.Open(Field) then begin
                            rec."Modified Field" := Field."No.";
                        end;
                    end;
                }
                field("Sync Only Coupled Records"; rec."Sync Only Coupled Records")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ResetConfiguration)
            {
                ApplicationArea = Suite;
                Caption = 'Use Default Synchronization Setup';
                Image = ResetStatus;
                ToolTip = 'Resets the integration table mappings and synchronization jobs to the default values for a connection with Dataverse. All current mappings are deleted.', Comment = 'Dataverse is the name of a Microsoft Service and should not be translated.';

                trigger OnAction()
                var
                    CDSSetupDefaults: Codeunit "CDS Setup Defaults";
                    CDSConnectionSetup: Record "CDS Connection Setup";
                begin
                    if Confirm(ResetIntegrationTableMappingConfirmQst, false) then begin
                        if CDSConnectionSetup.Get() then begin
                            CDSSetupDefaults.ResetConfiguration(CDSConnectionSetup);
                            Message(SetupSuccessfulMsg);
                        end;
                    end;
                end;
            }
            action(CreateTableMapping)
            {
                ApplicationArea = Suite;
                Caption = 'Create Integration Table Mapping';
                Image = Insert;
                ToolTip = 'Creates the Integration Table Mapping for the selected record.';

                trigger OnAction()
                var
                    DataverseIntegrations: Codeunit "Dataverse integrations";
                    IntegrationTableMapping: Record "Integration Table Mapping";
                begin
                    //Delete IntegrationFieldMapping
                    IntegrationTableMapping.Reset;
                    IntegrationTableMapping.SetRange(Name, Rec."Mapping Name");
                    if not IntegrationTableMapping.IsEmpty then
                        IntegrationTableMapping.Delete(true);

                    DataverseIntegrations.InsertIntegrationMapping(Rec."Mapping Name");
                    Message(CreateTableMappingMsg);
                end;
            }
            action(CreateJobQueue)
            {
                ApplicationArea = Suite;
                Caption = 'Create Job Queue';
                Image = Insert;
                ToolTip = 'Creates a Job Queue of the selected entry';

                trigger OnAction()
                var
                    CDSSetupDefaults: Codeunit "CDS Setup Defaults";
                    IntegrationTableMapping: Record "Integration Table Mapping";
                    DataverseTables: Record "Dataverse Table";
                    JobQueueEntryNameTok: Label ' %1 - %2 synchronization job.', Comment = '%1 = The Integration Table Name to synchronized (ex. CUSTOMER), %2 = CRM product name';
                begin
                    IntegrationTableMapping.Reset;
                    IntegrationTableMapping.SetRange(Name, Rec."Mapping Name");
                    If IntegrationTableMapping.FindFirst() then
                        Rec.CreateJobQueueEntry(IntegrationTableMapping, Codeunit::"Integration Synch. Job Runner", StrSubstNo(JobQueueEntryNameTok, IntegrationTableMapping.GetTempDescription()));

                    Message(CreateJobQueue);
                end;
            }
        }
        area(Navigation)
        {
            action(Fields)
            {
                ApplicationArea = All;
                Caption = 'Fields';
                RunObject = Page "Dataverse Fields";
                Image = SelectField;
                RunPageLink = "Mapping Name" = field("Mapping Name"), "BC Table" = field("BC Table"), "Dataverse Table" = field("Dataverse Table");
            }
            action(IntegrationTableMapping)
            {
                ApplicationArea = All;
                Caption = 'Integration Table Mapping';
                RunObject = Page "Integration Table Mapping List";
                Image = MapAccounts;
            }
        }
    }
    var
        ResetIntegrationTableMappingConfirmQst: Label 'This will restore the default integration table mappings and synchronization jobs for Dataverse. All customizations to mappings and jobs will be deleted. The default mappings and jobs will be used the next time data is synchronized. Do you want to continue?';
        SetupSuccessfulMsg: Label 'The default setup for Dataverse synchronization has completed successfully.';
        CreateTableMappingMsg: Label 'The Integration Table Mapping is succesfully created.';
        CreateJobQueue: Label 'The Job Queue is succesfully created.';

}