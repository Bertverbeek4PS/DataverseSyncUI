page 70100 "Dataverse UI Setup"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Dataverse UI Setup';
    Editable = true;
    UsageCategory = Administration;
    SourceTable = "Dataverse UI Setup";
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(TenantId; Rec."Tenant ID")
                {
                    Tooltip = 'Specifies the Tenant id for the Azure App Registration that accesses Dataverse.';
                }
                field(ClientId; Rec."Client ID")
                {
                    Tooltip = 'Specifies the client id for the Azure App Registration that accesses Dataverse.';
                }
                field("Client Secret"; ClientSecret)
                {
                    ExtendedDatatype = Masked;
                    Tooltip = 'Specifies the client secret for the Azure App Registration that accesses Dataverse.';

                    trigger OnValidate()
                    begin
                        Rec.SetClientSecret(ClientSecret);
                    end;
                }
                field(WebApiEndpoint; EnvironmentUrl)
                {
                    Tooltip = 'Specifies the URL of the Dataverse environment that you want to connect to.';
                    Editable = false;
                    Caption = 'Environment URL';
                }
                field(VersionApi; Rec."Version API")
                {
                    Tooltip = 'Specifies the version of the web API of the Dataverse Environemnt. Format 9.2';
                }
                field(PrefixDataverse; Rec."Prefix Dataverse")
                {
                    Tooltip = 'Specifies the prefix in Dataverse for table and fields. Format xxx';
                }

            }
            part(Tables; "Dataverse UI Tables")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Integration Table Mapping';
                RunObject = Page "Integration Table Mapping List";
                Image = MapAccounts;
            }
        }
    }
    var
        [NonDebuggable]
        ClientSecret: Text;
        EnvironmentUrl: Text;
        DataverseSetupErr: Label 'Please setup the connection of Dataverse first.';

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