codeunit 50173 "Movidas Tere"
{
    trigger OnRun()
    begin

    end;

    var
        CU6520: Codeunit 6520;

    [EventSubscriber(ObjectType::page, Page::"Item Tracing", 'OnAfterGetRecordEvent', '', true, true)]
    local procedure MyProcedure(var Rec: Record "Item Tracing Buffer")
    begin

    end;
}