
procedure(LayerSizeHierFigs(srcCV storgCV targetBox srcLayer storgLayer @optional (setwarn t))
    let((jc_objList jc_sizedList)
        jc_objList = dbGetTrueOverlaps(srcCV targetBox srcLayer 32 t)
        jc_sizedList = nil
        if(jc_objList then
            jc_objList = hierCopyFigs(storgCV jc_objList)
            jc_sizedList = dbLayerSize(storgCV storgLayer jc_objList 0.0 4096)
            DeleteObjList(jc_objList)
        else
            if(setwarn warn("LayerSizeHierFigs: no %L objects to sized up.\n" srcLayer))
        )
        jc_sizedList
    )
)

procedure(HierLayerCombine(srcCV trgCV operLayers markLayer bBox)
    let((ORObjects ANDObjects NOTObjects tmpSize resultObjects)
        ;;; operLayers = list(ORLayer ANDLayer NOTLayer)
        ORObjects = nil
        foreach(layer nth(0 operLayers)
            ORObjects = append1(ORObjects JTsizedHierFigs(srcCV trgCV bBox layer layer 32))
        )

        ANDObjects = nil
        foreach(layer nth(1 operLayers)
            ANDObjects = append1(ANDObjects JTsizedHierFigs(srcCV trgCV bBox layer layer 32))
        )

        NOTObjects = nil
        foreach(layer nth(2 operLayers)
            NOTObjects = append1(NOTObjects JTsizedHierFigs(srcCV trgCV bBox layer layer 32))
        )

        if(ORObjects then
            resultObjects = dbLayerSize(trgCV markLayer car(ORObjects) 0.0 99999)
            foreach(objs ORObjects
                tmpSize = resultObjects
                resultObjects = dbLayerOr(trgCV markLayer tmpSize objs 99999)
                DeleteObjList(append(tmpSize objs))
            ) 
        else
            resultObjects = dbLayerSize(trgCV markLayer car(ANDObjects) 0.0 99999)
        ) ;end or
        
        if(ANDObjects then
            foreach(objs ANDObjects
                tmpSize = resultObjects
                resultObjects = dbLayerAnd(trgCV markLayer tmpSize objs 99999)
                DeleteObjList(append(tmpSize objs))
            )
        ) ;end and

        if(NOTObjects then
            foreach(objs NOTObjects
                tmpSize = resultObjects
                resultObjects = dbLayerAndNot(trgCV markLayer tmpSize objs 99999)
                DeleteObjList(append(tmpSize objs))
            )
        ) ;end not
        resultObjects
    );end let
)
