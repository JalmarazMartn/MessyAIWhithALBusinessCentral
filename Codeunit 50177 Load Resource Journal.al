codeunit 50177 "Load Resource Journal"
{
    procedure WriteResJournalFromPicture(InsStream: InStream)
    var
        JSONBuffer: Record "JSON Buffer" temporary;
        Resource: Record Resource;
    begin
        UploadImageAndGetAllFaceIds(InsStream, JSONBuffer);
        with JSONBuffer do begin
            repeat
                CompareNewFaceWithResourcesAndMark(Value, Resource);
            until next = 0;
            Resource.MarkedOnly(true);
            Page.RunModal(0, Resource);
            CreateResJournalLines(Resource);
        end;
    end;

    local procedure UploadImageAndGetAllFaceIds(InsStream: InStream; var JSONBuffer: Record "JSON Buffer" temporary)
    var
        AzureVision: Codeunit "Azure Vision";
    begin
        with JSONBuffer do begin
            ReadFromText(AzureVision.GetTempFaceID(InsStream));
            SetRange("Token type", "Token type"::String);
            SetFilter(Path, '*faceId');
            FindSet();
        end;
    end;

    local procedure UploadImageAndGetSingleFaceId(InsStream: InStream): Text[50]
    var
        AzureVision: Codeunit "Azure Vision";
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        with JSONBuffer do begin
            ReadFromText(AzureVision.GetTempFaceID(InsStream));
            SetRange("Token type", "Token type"::String);
            SetFilter(Path, '*faceId');
            if FindFirst() then
                exit(Value);
        end;
    end;

    local procedure CompareNewFaceWithResourcesAndMarkUsingGroups(FaceId: Text[50]; var Resource: Record Resource)
    var
        AzureVision: Codeunit "Azure Vision";
    begin
        with Resource do begin
            SetFilter("Cognitive Group ID", '<>%1', '');
            SetFilter("Cognitive Person ID", '<>%1', '');
            FindSet();
            repeat
                if AzureVision.FaceIdMatchWithGroupPersonID(FaceId, "Cognitive Group ID", "Cognitive Person ID") then begin
                    Mark(true);
                    exit;
                end;
            until next = 0;
        end;
    end;

    local procedure CompareNewFaceWithResourcesAndMark(FaceId: Text[50]; var Resource: Record Resource)
    var
        AzureVision: Codeunit "Azure Vision";
        ResourceFaceId: text[50];
    begin
        with Resource do begin
            setrange(Type, type::Person);
            FindSet();
            repeat
                ResourceFaceId := GetResourceFaceId(Resource);
                if ResourceFaceId <> '' then
                    if AzureVision.MatchTwoFaceIds(FaceId, ResourceFaceId) then begin
                        Mark(true);
                        exit;
                    end;
            until next = 0;
        end;
    end;

    procedure GetResourceFaceId(Resource: record Resource) FaceId: Text[50]
    var
        InStream: InStream;
        OutStream: OutStream;
        BufferImage: Record "Buffer image" temporary;
        TempBlob: Codeunit "Temp Blob";
    begin
        if ResourceFaceIdBuffer.get(Resource."No.") then
            exit(ResourceFaceIdBuffer.FaceId);
        if Resource.Image.HasValue then begin
            TempBlob.CreateOutStream(OutStream);
            Resource.Image.ExportStream(OutStream);
            //CopyStream(OutStream, InStream);
            TempBlob.CreateInStream(InStream);
            faceid := UploadImageAndGetSingleFaceId(InStream);
        end;
        ResourceFaceIdBuffer."Resource No." := Resource."No.";
        ResourceFaceIdBuffer.FaceId := Faceid;
        ResourceFaceIdBuffer.Insert();
    end;

    procedure CreateResJournalLines(var Resource: record resource)
    begin

    end;

    var
        ResourceFaceIdBuffer: Record "Resource FaceId Buffer" temporary;
}