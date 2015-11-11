load("Base/Utility/readRecToList.il")
procedure(copyLibsToDest(module inputFile)
    let((inputList info getCellName PGNameList PGName PG_trgDir CellList name)
        
		inputList = readRecToList(inputFile t)
        count_PG = 0
        count_slot = 0
        PGtable = makeTable("PG" nil)
        cds_lib = outfile(strcat("working_yihsuan/cds_tpe/libs_" module "/cds.lib"))
        ;fprintf(cds_lib "#DEFINE PDFTechLib /projects/tc145cv/22lpm/dpgamecv/layout/build/cds_top/PDFTechLib\n")
        for(i 1 1;length(inputList)-1
            info = nth(i inputList)
            getCellName = nth(if(module == "SRAM" 0 1) info)
            println(getCellName)
            PGNameList = parseString(getCellName "_")
            PGName = buildString(list(nth(0 PGNameList) nth(1 PGNameList) module) "_")
            ;;; make directory
            PG_trgDir = strcat("working_yihsuan/cds_tpe/libs_" module "/" PGName)
            if(PGtable[PGName] == nil then
                system(strcat("mkdir " PG_trgDir))
            )

            TopLib = ddGetObj(PGName)
            CellList = TopLib~>cells
            foreach(cell CellList
                name = ddGetObjName(cell)
                if(car(parseString(name "_")) == "SLOT" then
                    if(car(last(parseString(name "_"))) == module && PGtable[PGName] == nil then
                        PGtable[PGName] = 1
                        printf("-- copy %s\n" cell~>name)
                    ;;; copy cells for genTopLayout
                        system(strcat("cp -r " cell~>writePath " " PG_trgDir))
                    ;;; copy file for display
                        if(setof(f TopLib~>files f~>name == "data.dm") then
                            system(strcat("cp " TopLib~>writePath "/data.dm " PG_trgDir))
                        )
                        if(setof(f TopLib~>files f~>name == "cdsinfo.tag") then
                            system(strcat("cp " TopLib~>writePath "/cdsinfo.tag " PG_trgDir))
                        )
                    ;;; Write lib path to cds.lib
                        fprintf(cds_lib "DEFINE %s /projects/tc145cv/22lpm/dpgamecv/layout/build/cds_tpe/%s\n" PGName PG_trgDir)
                        count_PG++
                    else
                    ;;; copy original cell
                        if(name == getCellName then
                            printf("-- copy %s\n" cell~>name)
                            system(strcat("cp -r " cell~>writePath " " PG_trgDir))
                            count_slot++
                        )
                    )
                ) ;get cell we need
            ) ;end foreach cell in lib
            i++
        ) ;end for info
        close(cds_lib)
        printf("total %d cells .\n" length(inputList))
    ) 
)


;;;;;;MAIN ;;;;;;
module = "PAIR"
inputFile = "up-to-date/lpSelectResult_A.csv"
copyLibsToDest(module inputFile)
