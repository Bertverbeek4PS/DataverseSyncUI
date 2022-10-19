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
        }
    }
    var
        ResetIntegrationTableMappingConfirmQst: Label 'This will restore the default integration table mappings and synchronization jobs for Dataverse. All customizations to mappings and jobs will be deleted. The default mappings and jobs will be used the next time data is synchronized. Do you want to continue?';
        SetupSuccessfulMsg: Label 'The default setup for Dataverse synchronization has completed successfully.';

}