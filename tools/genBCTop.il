let((keyword intLibName instObjList origin_x origin_y row_count instObj)
        keyword = "ROUTED"
        instLibName = "LOGICPAIR"
        topCV = dbOpenCellViewByType(instLibName "Jessie_TOP" "layout" "maskLayout" "w")
        origin_x = 0
        origin_y = 0
        row_count = 0
        for(i 33 60
            foreach(lr list("L" "R")
                if(row_count > 10 then
                    row_count = 0
                    origin_y = 0
                    origin_x = rightEdge(instObj~>bBox) + 3.0
                    instObjList = nil
                  )
                if(row_count <= 10 then
                    cell_route = sprintf(nil "PAIR%d_%s_ROUTED" i lr)
                    printf("Insert %s cell.\n" cell_route)
                    instObj = dbCreateInstByMasterName(topCV "LOGICPAIR" cell_route  "layout" "" list(origin_x origin_y) "R0" 1)
                    origin_y = origin_y + topEdge(instObj) - bottomEdge(instObj) + 3.0
                    row_count++
                  )
                )
           )
    dbSave(topCV)
    dbClose(topCV)
)
