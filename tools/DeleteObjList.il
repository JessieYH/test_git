;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Delete the objects in the list
procedure( DeleteObjList(
          ObjList
         )
   /*foreach( fig  ObjList
      dbDeleteObject(fig)
   )*/
    deleteObjs(ObjList)
); procedure

procedure(deleteObjs(@rest args)
    let(()
        foreach(elem args
            if(listp(elem) setof(i elem deleteObjs(i)))
            if(dbValidP(elem) dbDeleteObject(elem))
        )
    )
)
