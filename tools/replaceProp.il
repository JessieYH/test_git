;;; Get list by file
load("Base/Utility/readFileToList.il")
load("Base/Utility/readRecToList.il")
load("Base/Basic/Basic.il")
load("Base/Utility/genHierLayer.il")
load("Base/Utility/genIdutInfo.il")
load("Base/Sram/utility.il")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;check per project
;;;Prefix of project
prefix = "MA"
;;;Input file
readFile = "up-to-date/lpSelectResult.csv"
load("working_ccliu/sram/config/common_config.il")
;;;logFileName path
LogFileName = "working_yihsuan/pair/log/replaceProp_rec.log"
;;;empty cell list path
emptyCell = "working_yihsuan/pair/file/emptyCell.csv"
system(strcat("touch -a " emptyCell))

;;;   propNameList with ACTUAL prop name in the slot
propNameList = list("coreID" "TXID")
;;; the header with slotName, old prop value, modified prop value
logHeader = list("SlotName" "coreID_old" "coreID_new" "TXID_old" "TXID_new")
;;;!!!!!! New data is assigned at line 69 !!!!!! ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

procedure(propReplace_CDSlot()
    let((inputList headerList indexTable emptyList offsetCDtoAB logHeader)
      
        inputList = readRecToList(readFile t)
        headerList = car(inputList)
        indexTable = mktable(headerList)
        emptyList = readRecToList(emptyCell t)
        ;;;the origin offset when creating slot A/B from slot C/D
        offsetCDtoAB = getOriginOffsetSlotCDtoAB()

        LogFileID = outfile(LogFileName "w")
        printListToCSV(LogFileID logHeader)
        count = 1

        foreach(cellPair inputList
            dualSlotName = nth(indexTable["CDSlot"] cellPair)
            if(nth(0 parseString(dualSlotName "_")) == "SLOT" then
                autoFixProp(cellPair dualSlotName indexTable propNameList) t)
        );foreach
        close(LogFileID)
    );let
    );procedure

procedure(autoFixProp(cellPair dualSlotName indexTable propList)
    let((libName cellName data_old propType data_new dataList)

        libName = strcat(nth(0 parseString(dualSlotName "_")) "_" nth(1 parseString(dualSlotName "_")) "_PAIR")

        for(startNum indexTable["ABSlot1"] indexTable["ABSlot2"]
            cellName = strcat(prefix nth(startNum cellPair))
            trgCV = dbOpenCellViewByType(libName cellName "layout" "maskLayout" "a")
            
            ;;; get old prop data and prop value type, same order as propList
            data_old = nil
            propType = nil
            foreach(prop propList
                data_old = append1(data_old car(setof(i trgCV~>prop i~>name == prop))~>value)
                propType = append1(propType car(setof(i trgCV~>prop i~>name == prop))~>valueType)
            )

            ;;; new data to be replaced
            data_new = list(nth(indexTable["CoreID"] cellPair) nth(indexTable["CoreTXID"] cellPair))
            
            dataList = list(cellName)
            for(i 0 length(propList)-1
                dbReplaceProp(trgCV nth(i propList) nth(i propType) nth(i data_new))
            
                ;;; data list recorded in log file
                dataList = append(dataList list(nth(i data_old) nth(i data_new)))
            )

            printf("%d,%s\n" count cellName)
            printListToCSV(stdout dataList)
            printListToCSV(LogFileID dataList)
            dbSave(trgCV)
            dbClose(trgCV)
            count++
            startNum++
       );for
    );let
);procedure

propReplace_CDSlot()
