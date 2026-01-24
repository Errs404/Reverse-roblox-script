local function jN(jO,jP)local e1=table.create(#jO)for J,K in ipairs(jO)do e1[J]=jP(K,J-1,jO)end;local jQ={}for ev,K in ipairs(e1)do jQ[K[1]]=K[2]
