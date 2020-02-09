pageextension 50171 "Resource Card Cognitive" extends "Resource Card" //MyTargetPageId
{
    layout
    {
        addlast(General)
        {
            field("Cognitive Group ID"; "Cognitive Group ID")
            {
                ApplicationArea = All;
            }
            field("Cognitive Person ID"; "Cognitive Person ID")
            {
                ApplicationArea = All;
            }
        }
    }

}