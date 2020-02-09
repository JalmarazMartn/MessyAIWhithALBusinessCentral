page 50171 "JSON Buffer"
{
    PageType = List;
    SourceTable = "JSON Buffer";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry no."; "Entry no.")
                {
                    ApplicationArea = All;

                }
                field(Depth; Depth)
                {
                    ApplicationArea = All;

                }
                field("Token type"; "Token type")
                {
                    ApplicationArea = All;

                }
                field(Value; Value)
                {
                    ApplicationArea = All;

                }
                field(Path; Path)
                {
                    ApplicationArea = All;

                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}