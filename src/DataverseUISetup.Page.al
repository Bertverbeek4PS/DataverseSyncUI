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
                field(WebApiEndpoint; Rec."Web API endpoint")
                {
                    Tooltip = 'Specifies the Web API endpoint base url of the Dataverse Environemnt. format https://xxxx.api.crm4.dynamics.com';
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

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Web API endpoint" := 'https://xxxx.api.crm4.dynamics.com';
            Rec."Version API" := '9.2';
            Rec.Insert();
        end else begin
            ClientSecret := Rec.GetClientSecret();
        end;
    end;
}