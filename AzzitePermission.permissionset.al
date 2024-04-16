permissionset 50200 AzzitePermission
{
    Assignable = true;
    Permissions = tabledata "Distribution Header" = RIMD,
        tabledata "Distribution Line" = RIMD,
        tabledata "Distribution Project" = RIMD,
        tabledata "Distribution Rule" = RIMD,
        tabledata "Distribution Rule Filter" = RIMD,
        tabledata "Reference Data" = RIMD,
        table "Distribution Header" = X,
        table "Distribution Line" = X,
        table "Distribution Project" = X,
        table "Distribution Rule" = X,
        table "Distribution Rule Filter" = X,
        table "Reference Data" = X,
        report "Distribution Analysis" = X,
        report "Sales Invoice Report" = X,
        codeunit "Text File Manage" = X,
        codeunit "User Customize Manage" = X,
        page "Distribution Entries" = X,
        page "Distribution Project" = X,
        page "Distribution Rule" = X,
        page "Distribution Rule Filter" = X,
        page "Distribution Setup" = X,
        page "Distribution Subfrom" = X,
        page "Month Setup" = X,
        page "Reference Data List" = X,
        page "Year Setup" = X;
}