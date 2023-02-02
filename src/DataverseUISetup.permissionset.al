permissionset 70100 DataverseUISetup
{
    Assignable = true;
    Permissions = tabledata "CDS fps_Employee"=RIMD,
        tabledata "CDS SystemUser"=RIMD,
        tabledata "CDS Team"=RIMD,
        tabledata "Dataverse UI Field"=RIMD,
        tabledata "Dataverse UI Setup"=RIMD,
        tabledata "Dataverse UI Table"=RIMD,
        tabledata "Dataverse UI Temp Table"=RIMD,
        table "CDS fps_Employee"=X,
        table "CDS SystemUser"=X,
        table "CDS Team"=X,
        table "Dataverse UI Field"=X,
        table "Dataverse UI Setup"=X,
        table "Dataverse UI Table"=X,
        table "Dataverse UI Temp Table"=X,
        codeunit "Dataverse UI Dataverse Integr."=X,
        codeunit "Dataverse UI Events"=X,
        codeunit "Dataverse UI Telemetry Logger"=X,
        page "Dataverse UI Fields"=X,
        page "Dataverse UI List"=X,
        page "Dataverse UI Setup"=X,
        page "Dataverse UI Tables"=X;
}