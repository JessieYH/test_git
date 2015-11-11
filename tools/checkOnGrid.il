Grid = 0.005
LayersOnTop = list(list("M1" "drawing") list("C" "drawing"))

procedure(CheckOffGrid(value)
    let((ongrid flatReturn)
        ongrid = round(value / Grid) * Grid
        flagReturn = if(abs(ongrid - value) < 0.0001 nil t)
    )
)

saveFlag = nil
cvID = dbOpenCellViewByType("SLOT_R01C031_PAIR" "JCSLOT_R01C031_C_2" "layout" "" "r")
bkID = dbOpenCellViewByType(cvID~>libName "JC_CheckOnGrid" "layout" "maskLayout" "w")
logID = outfile("working_yihsuan/logCheckOffGrid.csv")
fprintf(logID "LayerName,ObjType,Coord\n")

foreach(layer LayersOnTop
    LayerObj = dbGetTrueOverlaps(cvID cvID~>bBox layer)
    sizedObj = dbLayerSize(bkID layer LayerObj 0.0 99999)
    ;if(LayerObj ObjList = append(ObjList LayerObj))
    foreach(obj sizedObj
        
        case(obj~>objType
            ("rect"
                objPoints = obj~>bBox
            )
            ("polygon"
                objPoints = obj~>points
            )
            ("path"
                objPoints = dbConvertPathToPolygon(obj)~>points
            )
            (t error("Can't defined objType. bBox:%L objType:%s\n" obj~>bBox obj~>objType))
        ) ;end case
        
        foreach(point objPoints
            if(CheckOffGrid(nth(0 point)) || CheckOffGrid(nth(1 point)) then
                fprintf(logID "%L,%s,%L\n" layer obj~>objType point)
                dbCopyFig(obj bkID list(0:0 "R0"))
                saveFlag = t
            )
        ) 
        dbDeleteObject(obj)
    )
)


close(logID)
dbClose(cvID)
if(saveFlag dbSave(bkID))
dbClose(bkID)
