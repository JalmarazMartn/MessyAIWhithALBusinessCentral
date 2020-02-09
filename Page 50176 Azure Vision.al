page 50176 "Azure Vision API"
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
                field("Method"; MethodText)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Vision Method';
                }
                field(IDFace1; IDFace1)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'IDFace1';
                }
                field(IDFace2; IDFace2)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'IDFace2';
                }
                field("Lot No."; LotNumber)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Lot No.';
                }

                field("Picture"; BufferImage.Image)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    CaptionML = ENU = 'Picture';
                }
                field("Picture To Compare"; BufferImage."Image To Compare")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    CaptionML = ENU = 'Picture To Compare';
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

            action("Image")
            {
                Caption = 'Process Image';
                ApplicationArea = All;
                Image = Segment;
                trigger OnAction()
                var
                    AzureVision: Codeunit "Azure Vision";
                    InStream: InStream;
                begin
                    BufferImage.Image.CreateInStream(InStream);
                    LastRetrievedText := AzureVision.GetAzureImageResp(MethodText, InStream);
                    message(LastRetrievedText);
                end;
            }
            action("Get Temporal FaceID")
            {
                Caption = 'Get Temporal FaceID';
                ApplicationArea = All;
                Image = Segment;
                trigger OnAction()
                var
                    AzureVision: Codeunit "Azure Vision";
                    InStream: InStream;
                begin
                    BufferImage.Image.CreateInStream(InStream);
                    LastRetrievedText := AzureVision.GetTempFaceID(InStream);
                    message(LastRetrievedText);
                end;
            }
            action("Get Resources In Picture")
            {
                Caption = 'Get Resources In Picture';
                ApplicationArea = All;
                Image = Journal;
                trigger OnAction()
                var
                    LoadResourceJournal: Codeunit "Load Resource Journal";
                    InStream: InStream;
                begin
                    BufferImage.Image.CreateInStream(InStream);
                    LoadResourceJournal.WriteResJournalFromPicture(InStream);
                end;
            }

            action("Verify Faces")
            {
                Caption = 'Verify Faces';
                ApplicationArea = All;
                Image = Segment;
                trigger OnAction()
                var
                    AzureVision: Codeunit "Azure Vision";
                    InStream: InStream;
                begin
                    LastRetrievedText := AzureVision.VerifyFace(IDFace1, IDFace2);
                    message(LastRetrievedText);
                end;
            }

            action("GetLot")
            {
                Caption = 'Get Lot Number From Image';
                ApplicationArea = All;
                Image = Lot;
                trigger OnAction()
                var
                    AzureVision: Codeunit "Azure Vision";
                    InStream: InStream;
                begin
                    BufferImage.Image.CreateInStream(InStream);
                    LotNumber := AzureVision.GetLotNoFromImage(InStream);
                end;
            }
            action("Camera Image Process")
            {
                Caption = 'Camera Image Process';
                ApplicationArea = All;
                Image = Camera;
                trigger OnAction()
                var
                    CameraPage: page "Camera Interaction";
                    InStream: InStream;
                    AzureVision: Codeunit "Azure Vision";
                begin
                    if not CameraPage.GetPicture(InStream) then
                        Error('Camera is rubish');
                    LastRetrievedText := AzureVision.GetAzureImageResp(MethodText, InStream);
                    Message(LastRetrievedText);
                end;
            }

        }
    }

    var
        MethodText: Text;
        BufferImage: Record "Buffer image" temporary;
        LastRetrievedText: Text;
        LotNumber: text;
        IDFace1: text[100];
        IDFace2: text[100];

    local procedure SohwLastResponseJSON()
    var
        JSONBuffer: Record "JSON Buffer" Temporary;
    begin
        JSONBuffer.ReadFromText(LastRetrievedText);
        if JSONBuffer.FindFirst() then
            page.RunModal(page::"JSON Buffer", JSONBuffer);
    end;
}