page 50174 "Syntax Tokens"
{
    Caption = 'Syntax Tokens';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;

    SourceTable = "Syntax Token";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Part of Speech"; "Part of Speech")
                {
                    ApplicationArea = All;
                }
                field("Token Content"; "Token Content")
                {
                    ApplicationArea = All;
                }
                field(Lemma; Lemma)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}