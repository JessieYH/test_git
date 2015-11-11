load("Base/Utility/readRecToList.il")
load("Base/Sram/utility.il")
procedure(makeTableFromCSV(InputFile @optional ( PilotKeyInd 0 ))
    let((readData headInd DataTable)
        readData = readRecToList(InputFile t)
        headInd = mktable(car(readData))

        DataTable = makeTable("DATA" nil)
        foreach(lndata cdr(readData)
            foreach(key headInd~>?
                DataTable[strcat(nth(PilotKeyInd lndata) "_" key)] = nth(headInd[key] lndata)
            ) ;gets head ex."pairID","pairCell","vtType",... 
        )
        DataTable
    )
) ;end procedure


