page 70103 "Dataverse UI Tables"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Dataverse UI Table";

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field("Mapping Name"; Rec."Mapping Name")
                {
                    ToolTip = 'Is the mapping name that is used in the integration table. If you want to expand an excisting integration table use the same mapping name.';
                }
                field("BC Table"; Rec."BC Table")
                {
                    ToolTip = 'Specifies the BC table that you want to sync.';
                }
                field("BC Table Caption"; Rec."BC Table Caption")
                {
                    ToolTip = 'Caption of the Business Central table.';
                }
                field("Dataverse Table"; Rec."Dataverse Table")
                {
                    ToolTip = 'Specify the Dataverse table that you want to map with the Business Central table.';
                }
                field("Dataverse Table Caption"; Rec."Dataverse Table Caption")
                {
                    ToolTip = 'Caption of the Dataverse table.';
                }
                field("Table Name Dataverse"; Rec."Table Name Dataverse")
                {
                    ToolTip = 'Specifies the value of the Table Name Dataverse field.';
                }
                field("Sync Direction"; Rec."Sync Direction")
                {
                    ToolTip = 'Specify the sync direction of the integration.';
                }
                field("Dataverse UID"; Rec."Dataverse UID")
                {
                    ToolTip = 'Specifies the value of the Dataverse UID field.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, Rec."Dataverse Table");
                        if FieldSelection.Open(Field) then
                            Rec."Dataverse UID" := Field."No.";
                    end;
                }
                field("Modified Field"; Rec."Modified Field")
                {
                    ToolTip = 'Specifies the value of the Modified on field.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, Rec."Dataverse Table");
                        if FieldSelection.Open(Field) then
                            Rec."Modified Field" := Field."No.";
                    end;
                }
                field("Sync Only Coupled Records"; Rec."Sync Only Coupled Records")
                {
                    ToolTip = 'Specifies if you only want to sync coupled records or all records.';
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
                Caption = 'Fields';
                Image = SelectField;
                RunObject = page "Dataverse UI Fields";
                RunPageLink = "Mapping Name" = field("Mapping Name"), "BC Table" = field("BC Table");
                ToolTip = 'Executes the Fields action.';
            }
            action(ResetConfiguration)
            {
                Caption = 'Use Default Synchronization Setup';
                Image = ResetStatus;
                ToolTip = 'Resets the integration table mappings and synchronization jobs to the default values for a connection with Dataverse. All current mappings are deleted.', Comment = 'Dataverse is the name of a Microsoft Service and should not be translated.';

                trigger OnAction()
                var
                    CDSConnectionSetup: Record "CDS Connection Setup";
                    CDSSetupDefaults: Codeunit "CDS Setup Defaults";
                begin
                    if Confirm(ResetIntegrationTableMappingConfirmQst, false) then
                        if CDSConnectionSetup.Get() then begin
                            CDSSetupDefaults.ResetConfiguration(CDSConnectionSetup);
                            Message(SetupSuccessfulMsg);
                        end;
                end;
            }
            action(CreateTableMapping)
            {
                Caption = 'Create/Update Integration Table Mapping';
                Image = Insert;
                ToolTip = 'Creates or updates the Integration Table Mapping for the selected record.';

                trigger OnAction()
                var
                    IntegrationTableMapping: Record "Integration Table Mapping";
                    DataverseUIEvents: Codeunit "Dataverse UI Events";
                    FeatureTelemetry: Codeunit "Feature Telemetry";
                    FeatureUptakeStatus: Enum "Feature Uptake Status";
                begin
                    if Rec."Dataverse Table" <> 0 then begin
                        //Delete IntegrationFieldMapping
                        IntegrationTableMapping.Reset();
                        IntegrationTableMapping.SetRange(Name, Rec."Mapping Name");
                        if not IntegrationTableMapping.IsEmpty then begin
                            AnswerUpdate := Confirm(UpdateOrCreateQst, true);
                            if AnswerUpdate then begin
                                DataverseUIEvents.InsertIntegrationMapping(Rec."Mapping Name", true);
                                Message(UpdateTableMappingMsg);
                            end else begin
                                IntegrationTableMapping.Delete(true);
                                DataverseUIEvents.InsertIntegrationMapping(Rec."Mapping Name", false);
                                Message(CreateTableMappingMsg);
                            end;
                        end else begin
                            DataverseUIEvents.InsertIntegrationMapping(Rec."Mapping Name", false);
                            Message(CreateTableMappingMsg);
                        end;
                    end else
                        Message(CreateTableMappingErrorMsg);

                    FeatureTelemetry.LogUptake('DVUI010', 'Dataverse UI', FeatureUptakeStatus::Used);
                end;
            }
            action(CreateDataverseTable)
            {
                Caption = 'Create/Update Dataverse Table';
                Image = Insert;
                ToolTip = 'Creates or updates a Dataverse table inside Dataverse';

                trigger OnAction()
                var
                    DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
                begin
                    DataverseUIDataverseIntegr.CreateTable(Rec);
                    CurrPage.Update();
                end;
            }
            action(CreateJobQueue)
            {
                Caption = 'Create Job Queue';
                Image = Insert;
                ToolTip = 'Creates a Job Queue of the selected entry';

                trigger OnAction()
                var
                    IntegrationTableMapping: Record "Integration Table Mapping";
                    JobQueueEntryNameTok: Label ' %1 - %2 synchronization job.', Comment = '%1 = The Integration Table Name to synchronized (ex. CUSTOMER), %2 = CRM product name';
                begin
                    IntegrationTableMapping.Reset();
                    IntegrationTableMapping.SetRange(Name, Rec."Mapping Name");
                    if IntegrationTableMapping.FindFirst() then
                        Rec.CreateJobQueueEntry(IntegrationTableMapping, Codeunit::"Integration Synch. Job Runner", StrSubstNo(JobQueueEntryNameTok, rec."BC Table Caption", rec."Dataverse Table Caption"));

                    Message(CreateJobQueueMsg);
                end;
            }
        }
    }
    var
        AnswerUpdate: Boolean;
        CreateJobQueueMsg: Label 'The Job Queue is succesfully created.';
        CreateTableMappingErrorMsg: Label 'The Integration Table Mapping could not be created.';
        CreateTableMappingMsg: Label 'The Integration Table Mapping is succesfully created.';
        ResetIntegrationTableMappingConfirmQst: Label 'This will restore the default integration table mappings and synchronization jobs for Dataverse. All customizations to mappings and jobs will be deleted. The default mappings and jobs will be used the next time data is synchronized. Do you want to continue?';
        SetupSuccessfulMsg: Label 'The default setup for Dataverse synchronization has completed successfully.';
        UpdateOrCreateQst: Label 'Do you want to update the Integration Table Mapping?';
        UpdateTableMappingMsg: Label 'The Integration Table Mapping is succesfully updated.';
}