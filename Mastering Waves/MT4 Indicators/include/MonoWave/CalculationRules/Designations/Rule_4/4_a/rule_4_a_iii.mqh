

int Rule_4_a_iii(){
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//????????? ?iii?: ????????? ?? m3 e ?????? ??  261.8% ?? ????????? ?? m2
////////////////////////////////////////////////////////////////////////////////////////////////////////////      
   InfoParagraph = "4-a-iii:1";
   Rule_4_a_iii_paragraph_1();
   InfoParagraph = "4-a-iii:2";
   Rule_4_a_iii_paragraph_2();
   InfoParagraph = "4-a-iii:3";
   Rule_4_a_iii_paragraph_3();
}

int Rule_4_a_iii_paragraph_1(){   
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
??? ????????? ?? m(-1) ????????? 261.8% ????????? ?? m1, 
??????????? ? m1 ?? ???????? ??????? ?????? ?? ????? ? ?????? ?? ????; 
????????? ? ???? ?? m1 ???? ???? ??????????? ?:F3?.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/    
   double ratio_p = ComparePriceDirection(-1, 1);
   if ( Large_261(ratio_p) ){
      AddDesignation(desig_F3, "");  
   }
   return(0);  
} 

int Rule_4_a_iii_paragraph_2(){   
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
??? ????????? ?? m4 ? ??-?????? ??? ????? ?? ????????? ?? m3, 
??????????? ? m1 ?? ???????? ??????? ?????? ?? ????? ? ????? ?????; ????????? ? ???? ?? m1 ??????????? ?:F3?.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/ 
   double ratio_p = ComparePriceDirection(4, 3);
   if ( Large_100(ratio_p) ){
      AddDesignation(desig_F3, ""); 
   }
   return(0);  
} 

int Rule_4_a_iii_paragraph_3(){   
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
??? m4 ? ??-?????? ?? m3, ???????????? m1 ?? ? ?????? ?? ?????? ?????? ?? ????? ? ????? ?????, 
????????? ? ???? ?? m1 ??????????? ?:s5?.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/ 
   double ratio_p = ComparePriceDirection(4, 3);
   if ( Small_100(ratio_p) ){
      AddDesignation(desig_s5, ""); 
   }
   return(0);  
}