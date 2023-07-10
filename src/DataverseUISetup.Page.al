page 70100 "Dataverse UI Setup"
{
    ApplicationArea = All;
    Caption = 'Dataverse UI Setup';
    Editable = true;
    PageType = Card;
    SourceTable = "Dataverse UI Setup";
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(TenantId; Rec."Tenant ID")
                {
                    ToolTip = 'Specifies the Tenant id for the Azure App Registration that accesses Dataverse.';
                }
                field(ClientId; Rec."Client ID")
                {
                    ToolTip = 'Specifies the client id for the Azure App Registration that accesses Dataverse.';
                }
                field("Client Secret"; ClientSecret)
                {
                    Caption = 'Client Secret';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the client secret for the Azure App Registration that accesses Dataverse.';

                    trigger OnValidate()
                    begin
                        Rec.SetClientSecret(ClientSecret);
                    end;
                }
                field(WebApiEndpoint; EnvironmentUrl)
                {
                    Caption = 'Environment URL';
                    Editable = false;
                    ToolTip = 'Specifies the URL of the Dataverse environment that you want to connect to.';
                }
                field(VersionApi; Rec."Version API")
                {
                    ToolTip = 'Specifies the version of the web API of the Dataverse Environemnt. Format 9.2';
                }
                field(PrefixDataverse; Rec."Prefix Dataverse")
                {
                    ToolTip = 'Specifies the prefix in Dataverse for table and fields. Format xxx';
                }
                field(Debugmode; Rec."Debug mode")
                {
                    Caption = 'Debug mode';
                    ToolTip = 'Turn this on if you want to enter debug mode.';
                }
            }
            part(Tables; "Dataverse UI Tables")
            {
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(IntegrationTableMapping)
            {
                Caption = 'Integration Table Mapping';
                Image = MapAccounts;
                RunObject = page "Integration Table Mapping List";
                ToolTip = 'Executes the Integration Table Mapping action.';
            }
        }
    }
    var
        DataverseSetupErr: Label 'Please setup the connection of Dataverse first.';
        [NonDebuggable]
        ClientSecret: Text;
        EnvironmentUrl: Text;

    trigger OnOpenPage()
    var
        CDSConnectionSetup: Record "CDS Connection Setup";
        FeatureTelemetry: Codeunit "Feature Telemetry";
        FeatureUptakeStatus: Enum "Feature Uptake Status";
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Version API" := '9.2';
            Rec.Insert();

            if CDSConnectionSetup.Get() then
                EnvironmentUrl := CDSConnectionSetup."Server Address"
            else
                EnvironmentUrl := DataverseSetupErr;
        end else begin
            ClientSecret := Rec.GetClientSecret();

            if CDSConnectionSetup.Get() then
                EnvironmentUrl := CDSConnectionSetup."Server Address"
            else
                EnvironmentUrl := DataverseSetupErr;
        end;

        FeatureTelemetry.LogUptake('DVUI010', 'Dataverse UI', FeatureUptakeStatus::Discovered);
    end;
}