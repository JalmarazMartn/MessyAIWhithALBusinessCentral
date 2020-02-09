page 50170 "Natural Language CloudMersive"
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
                field("NL Method"; GenericNLMethod)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Method to Apply';
                }

                field("Picture 1"; BufferImage1.Image)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    CaptionML = ENU = 'Picture';
                }
                field("Picture 2"; BufferImage2.Image)
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
            action("Apply Generic Method")
            {
                Caption = 'Apply Generic Method CloudMersive';
                ApplicationArea = All;
                Image = AlternativeAddress;
                trigger OnAction()
                var
                    JSONBuffer: Record "JSON Buffer" Temporary;
                    CloudMersiveNL: Codeunit "Cloudmersive Natural Language";
                begin
                    message(CloudMersiveNL.CallCloudMersiveNL(NatualLenguageText,
                                Format(GenericNLMethod)));
                end;
            }
            action("Compare Faces")
            {
                Caption = 'Compare faces';
                ApplicationArea = All;
                Image = AlternativeAddress;
                trigger OnAction()
                var
                    JSONBuffer: Record "JSON Buffer" Temporary;
                    CloudMersiveImage: Codeunit "Cloudmersive Face";
                begin
                    message(CloudMersiveImage.GetCompareFaces(BufferImage1, BufferImage2));
                end;
            }
            action("Detect Age")
            {
                Caption = 'Detect Age';
                ApplicationArea = All;
                Image = AlternativeAddress;
                trigger OnAction()
                var
                    CloudMersiveImage: Codeunit "Cloudmersive Face";
                begin
                    message(CloudMersiveImage.GetDetectAge(BufferImage1));
                end;
            }
            action("Get Resource No.")
            {
                Caption = 'Get Resource No.';
                ApplicationArea = All;
                Image = Resource;
                trigger OnAction()
                var
                    CloudMersiveNL: Codeunit "Cloudmersive Natural Language";
                begin
                    message(CloudMersiveNL.GetResourceNo(NatualLenguageText));
                end;
            }
            action("Get Work Type Code")
            {
                Caption = 'Get Work Type Code';
                ApplicationArea = All;
                Image = Resource;
                trigger OnAction()
                var
                    CloudMersiveNL: Codeunit "Cloudmersive Natural Language";
                begin
                    message(CloudMersiveNL.GetWorkTypeCode(NatualLenguageText));
                end;
            }
            action(ResourceJournal)
            {
                Caption = 'Open Resource Journal';
                ApplicationArea = All;
                RunObject = page "Resource Journal";
                Image = ResourceJournal;
            }
        }
    }

    var
        NatualLenguageText: Text;
        GenericNLMethod: Option ,ParseString,"language/detect","get/words/verbs/string","get/words/properNouns/string","get/words/nouns/string","get/words/adverbs/string","get/words/pronouns/string","get/words/adjectives/string";
        BufferImage1: Record "Buffer image" temporary;
        BufferImage2: Record "Buffer image" temporary;
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