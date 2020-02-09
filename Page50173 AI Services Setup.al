page 50173 "AI Services Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AI Services Setup";
    layout
    {
        area(Content)
        {
            group(Apikeys)
            {
                field("Watson Image Apikey"; "Watson Image Apikey")
                {
                    ApplicationArea = All;

                }
                field("Watson Syntax Apikey"; "Watson Syntax Apikey")
                {
                    ApplicationArea = All;

                }
                field("CloudMersive ApiKey"; "CloudMersive ApiKey")
                {
                    ApplicationArea = All;

                }
                field("Azure vision ApiKey"; "Azure vision ApiKey")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Get() then
            Insert();
    end;
}