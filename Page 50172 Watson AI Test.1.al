page 50172 "Watson AI Test"
{
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Input)
            {
                field("Text"; NatualLenguageText)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Natural Language Text';
                }

                field("Picture"; BufferImage.Image)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    CaptionML = ENU = 'Picture';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowJSON)
            {
                Caption = 'Show Last Json Retrieved';
                ApplicationArea = All;
                Image = Filed;
                trigger OnAction()
                begin
                    SohwLastResponseJSON();
                end;
            }
            action("Syntax Tokens Watson")
            {
                Caption = 'Show Syntax Tokens';
                ApplicationArea = All;
                Image = Resource;
                trigger OnAction()
                var
                    WatsonManage: Codeunit "Watson Management";
                    JSONBuffer: Record "JSON Buffer" temporary;
                    SyntaxToken: Record "Syntax Token" temporary;
                begin
                    LastRetrievedText := WatsonManage.GetWatsonNaturalLanguagePost(NatualLenguageText);
                    JSONBuffer.ReadFromText(LastRetrievedText);
                    SyntaxToken.GetWordsFromJSONBuffer(JSONBuffer);
                    Page.Run(page::"Syntax Tokens", SyntaxToken);
                end;
            }
            action("Syntax Tree Watson")
            {
                Caption = 'Message Syntax Tree Watson';
                ApplicationArea = All;
                Image = Resource;
                trigger OnAction()
                var
                    WatsonManage: Codeunit "Watson Management";
                begin
                    LastRetrievedText := WatsonManage.GetWatsonNaturalLanguagePost(NatualLenguageText);
                    message(LastRetrievedText);
                end;
            }
            action("EmotionWatson")
            {
                Caption = 'Get Watson emotions and sentiment in entities and keywords';
                ApplicationArea = All;
                Image = Segment;
                trigger OnAction()
                var
                    WatsonManage: Codeunit "Watson Management";
                begin
                    LastRetrievedText := WatsonManage.GetWatsonEmotionsAndSentiment(NatualLenguageText);
                    message(LastRetrievedText);
                end;
            }
            action("WatsonSemanticRole")
            {
                Caption = 'Get Watson Semantic Role';
                ApplicationArea = All;
                Image = Segment;
                trigger OnAction()
                var
                    WatsonManage: Codeunit "Watson Management";
                begin
                    LastRetrievedText := WatsonManage.GetWatsonSemanticRole(NatualLenguageText);
                    message(LastRetrievedText);
                end;
            }

            action("ImageWatson")
            {
                Caption = 'Detect faces Watson';
                ApplicationArea = All;
                Image = Segment;
                trigger OnAction()
                var
                    WatsonManage: Codeunit "Watson Management";
                begin
                    LastRetrievedText := WatsonManage.GetWatsonImageResponseFromBuffer(BufferImage);
                    message(LastRetrievedText);
                end;
            }
            action("Gender Detection Watson")
            {
                Caption = 'Gender Detection Watson';
                ApplicationArea = All;
                Image = ContactPerson;
                trigger OnAction()
                var
                begin
                    Codeunit.Run(Codeunit::"Gender contact check");
                end;
            }
            action("CheckAllContactsGender")
            {
                Caption = 'Check All Contacts Gender';
                ApplicationArea = All;
                Image = CheckRulesSyntax;
                trigger OnAction()
                var
                    GenderContactCheck: Codeunit "Gender contact check";
                begin
                    GenderContactCheck.CheckAllContactsGender();
                end;
            }
            action(Setup)
            {
                Caption = 'Setup';
                ApplicationArea = All;
                Image = Setup;
                RunObject = page "AI Services Setup";
            }
        }
    }

    var
        NatualLenguageText: Text;
        BufferImage: Record "Buffer image" temporary;
        LastRetrievedText: Text;

    local procedure SohwJSON()
    var
        JSONBuffer: Record "JSON Buffer" Temporary;
        CloudMersiveNL: Codeunit "Cloudmersive Natural Language";
    begin
        CloudMersiveNL.FiilJSONBufferCloudMersiveNL(JSONBuffer, NatualLenguageText, 'ParseString');
        if JSONBuffer.FindFirst() then
            page.RunModal(page::"JSON Buffer", JSONBuffer);
    end;

    local procedure SohwLastResponseJSON()
    var
        JSONBuffer: Record "JSON Buffer" Temporary;
    begin
        JSONBuffer.ReadFromText(LastRetrievedText);
        if JSONBuffer.FindFirst() then
            page.RunModal(page::"JSON Buffer", JSONBuffer);
    end;
}