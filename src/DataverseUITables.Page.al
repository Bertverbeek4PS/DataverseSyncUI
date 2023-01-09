page 70103 "Dataverse UI Tables"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Dataverse UI Table";

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field("Mapping Name"; Rec."Mapping Name")
                {
                }
                field("BC Table"; Rec."BC Table")
                {
                }
                field("BC Table Caption"; Rec."BC Table Caption")
                {
                }
                field("Dataverse Table"; Rec."Dataverse Table")
                {
                }
                field("Dataverse Table Caption"; Rec."Dataverse Table Caption")
                {
                }
                field("Table Name Dataverse"; Rec."Table Name Dataverse")
                {
                }
                field("Sync Direction"; Rec."Sync Direction")
                {
                }
                field("Dataverse UID"; Rec."Dataverse UID")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, Rec."Dataverse Table");
                        if FieldSelection.Open(Field) then begin
                            Rec."Dataverse UID" := Field."No.";
                        end;
                    end;
                }
                field("Modified Field"; Rec."Modified Field")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, Rec."Dataverse Table");
                        if FieldSelection.Open(Field) then begin
                            Rec."Modified Field" := Field."No.";
                        end;
                    end;
                }
                field("Sync Only Coupled Records"; Rec."Sync Only Coupled Records")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Fields)
            {
                ApplicationArea = All;
                Caption = 'Fields';
                RunObject = Page "Dataverse UI Fields";
                Image = SelectField;
                RunPageLink = "Mapping Name" = field("Mapping Name"), "BC Table" = field("BC Table");
            }
            action(ResetConfiguration)
            {
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
                Caption = 'Create Integration Table Mapping';
                Image = Insert;
                ToolTip = 'Creates the Integration Table Mapping for the selected record.';

                trigger OnAction()
                var
                    DataverseUIEvents: Codeunit "Dataverse UI Events";
                    IntegrationTableMapping: Record "Integration Table Mapping";
                begin
                    //Delete IntegrationFieldMapping
                    IntegrationTableMapping.Reset;
                    IntegrationTableMapping.SetRange(Name, Rec."Mapping Name");
                    if not IntegrationTableMapping.IsEmpty then
                        IntegrationTableMapping.Delete(true);

                    DataverseUIEvents.InsertIntegrationMapping(Rec."Mapping Name");
                    Message(CreateTableMappingMsg);
                end;
            }
            action(CreateDataverseTable)
            {
                Caption = 'Create Dataverse Table';
                Image = Insert;
                ToolTip = 'Creates a Dataverse table inside Dataverse';

                trigger OnAction()
                var
                    DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
                begin
                    DataverseUIDataverseIntegr.CreateTable(rec, false);
                    CurrPage.Update();
                end;
            }
            action(UpdateDataverseTable)
            {
                Caption = 'Update Dataverse Table';
                Image = Insert;
                ToolTip = 'Updates a Dataverse table inside Dataverse';

                trigger OnAction()
                var
                    DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
                begin
                    DataverseUIDataverseIntegr.CreateTable(rec, true);
                end;
            }
            action(CreateJobQueue)
            {
                Caption = 'Create Job Queue';
                Image = Insert;
                ToolTip = 'Creates a Job Queue of the selected entry';

                trigger OnAction()
                var
                    CDSSetupDefaults: Codeunit "CDS Setup Defaults";
                    IntegrationTableMapping: Record "Integration Table Mapping";
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
    }
    var
        ResetIntegrationTableMappingConfirmQst: Label 'This will restore the default integration table mappings and synchronization jobs for Dataverse. All customizations to mappings and jobs will be deleted. The default mappings and jobs will be used the next time data is synchronized. Do you want to continue?';
        SetupSuccessfulMsg: Label 'The default setup for Dataverse synchronization has completed successfully.';
        CreateTableMappingMsg: Label 'The Integration Table Mapping is succesfully created.';
        CreateJobQueue: Label 'The Job Queue is succesfully created.';

}