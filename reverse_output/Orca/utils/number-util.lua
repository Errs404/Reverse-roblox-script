local function q(kp,kq,kr,ks,kt)return ks+(kp-kq)*(kt-ks)/(kr-kq)end;local function ku(hD,dG,ek)return hD+(dG-hD)*ek end;return{map=q,lerp=ku}
