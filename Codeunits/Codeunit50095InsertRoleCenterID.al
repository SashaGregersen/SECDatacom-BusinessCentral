codeunit 50095 "Create Role Center"
{
    trigger OnRun()
    var
        AllProfile: record "All Profile";
        Guid: guid;
    begin
        AllProfile.Init();
        AllProfile.validate("App ID", '{00000000-0000-0000-0000-000000000000}');
        AllProfile.validate("Profile ID", 'PM');
        AllProfile.validate(Scope, AllProfile.Scope::System);
        AllProfile.validate(Description, 'Payment Management');
        AllProfile.validate("Role Center ID", 6016930);
        AllProfile.Insert(true);

        AllProfile.Init();
        AllProfile.validate("App ID", '{00000000-0000-0000-0000-000000000000}');
        AllProfile.validate("Profile ID", 'DCO');
        AllProfile.validate(Scope, AllProfile.Scope::System);
        AllProfile.validate(Description, 'Document Output');
        AllProfile.validate("Role Center ID", 6175300);
        AllProfile.Insert(true);
    end;


}