
int Rule_5_b(){
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//������� �b�: ��������� �� m0 e �� ��-����� �� 100%, �� ��-����� �� 161.8% �� ��������� m1
////////////////////////////////////////////////////////////////////////////////////////////////////////////  
   InfoParagraph = "5-b:1";
   Rule_5_b_paragraph_1();
   InfoParagraph = "5-b:2";
   Rule_5_b_paragraph_2();
   InfoParagraph = "5-b:3";
   Rule_5_b_paragraph_3();
   InfoParagraph = "5-b:4";
   Rule_5_b_paragraph_4();
   InfoParagraph = "5-b:5";
   Rule_5_b_paragraph_5();
   InfoParagraph = "5-b:6";
   Rule_5_b_paragraph_6();
   InfoParagraph = "5-b:7";
   Rule_5_b_paragraph_7();
   InfoParagraph = "5-b:8";
   Rule_5_b_paragraph_8();
   InfoParagraph = "5-b:9";
   Rule_5_b_paragraph_9();
     
}

int Rule_5_b_paragraph_1(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� m3 � ��-����� �� m2, � ��������� �� m0 e � ��������� �� 100% �� 161.8% �� m1 
� ��������� �� m0 � ��-������ �� 100% ��������� �� 161.8% �� m1, ��������� � ���� �� m1 ����������� �:�3�. 
��� m(-1) � �� ����� �� m0, � ������������ �� ����� ������������� �:�3�, 
�������� ����� �b� ���� ����������� �� �� �������� �b:�3�. ���� ��������, 
�� m1 � b-����� �� ������ ��������. ��� m(-1) � �� ������ �� m0, 
�� m1 ���� �� ���� �-����� �� ������ ��������, ������ ��������� ��� ���� ����������� �:�3�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
      
   double ratio_p = ComparePriceDirection(3, 2);      
   if (Large_100(ratio_p)){  
      ratio_p = ComparePriceDirection(0, 1);      
      if (Large_100(ratio_p) && Small_130(ratio_p)){           
      
         
         
         ratio_p = ComparePriceDirection(-1, 0);      
         if (Large_100(ratio_p)){
            AddDesignation(desig_bc3, "");
         }else{
            AddDesignation(desig_xc3, "");
         }
      
      }      
   }
   return(0);   
} 

int Rule_5_b_paragraph_2(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� m3 � ��-����� �� m2, � ��������� �� m0 e � ��������� �� 100% �� 161.8% �� m1 
� ��������� �� m0 � ��-������ �� 161.8%  ��������� �� 100% �� m1 ��������� � ���� �� m1, ����������� �:F3�. 
��� m(-1) � ��-����� �� m0, �� m2 ���� �� �������� ������. ��� m(-1) � ��-������ �� m0, 
�� m1 ���� �� ���� �-�����  �� ������ ��������, ���������� � ����� m4.  
�� ���� ��� ������������ �������� �������� � ���� �� m1 ����������� � �b:c3�, � �x:c3�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
      
   double ratio_p = ComparePriceDirection(3, 2);      
   if (Large_100(ratio_p)){  
      ratio_p = ComparePriceDirection(0, 1);      
      if (Large_130(ratio_p) && Small_161(ratio_p)){
      
         AddDesignation(desig_F3, "");
         
         ratio_p = ComparePriceDirection(-1, 0);      
         if (Large_100(ratio_p)){
            AddDesignation(desig_bc3, "");   
         }else{
            
            AddDesignation(desig_xc3, "");
         }
      
      }      
   }
   return(0);   
}

int Rule_5_b_paragraph_3(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� ��������� �� m3 � ������� 61.8% �� ��������� �� m1, � ���� ���� ���� �� m3 �� ������� �������� ���� �� m2, 
� ��������� �� m2 � ������ �� 61.8% �� ��������� �� m0, �� m1 ���� �� ���� ����� ���� �� ������ ���������� ���������; 
�������� � ������� �� m1 ����������� �:F3�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   double ratio_p = ComparePriceDirection(3, 1);      
   if (Large_061(ratio_p)){        
      if (!BreakEndToFormationDirection(2, 3)){
            
         ratio_p = ComparePriceDirection(2, 0);      
         if (Equal_061(ratio_p)){          
            AddDesignation(desig_F3, "");  
         }
      }
   }
   return(0);   
}

int Rule_5_b_paragraph_4(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� ��������� �� m3 � ��-����� �� 100% �� ��������� �� m2, � �� ��-����� �� 61.8% �� ��������� �� m1, 
� ���� ���� ���� �� ����� m3 �� ������� ���� �� m2, ��������� � ���� �� m1 ����������� �:F3�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   double ratio_p = ComparePriceDirection(3, 2);      
   if (Small_100(ratio_p)){  
      ratio_p = ComparePriceDirection(3, 1);      
      if (Large_061(ratio_p)){  
         if (!BreakEndToFormationDirection(2, 3)){      
            AddDesignation(desig_F3, "");  
         }
      }      
   }
   return(0);   
}


int Rule_5_b_paragraph_5(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� ��������� �� m3 � ��-����� �� 61.8% �� ��������� �� m2, � ����� m1 � m3 �� �����������, 
� ��������� �� m4 �� ��������� 261.8% ��������� �� m2 � m2 � ��-����� �� m0 �/��� �� m4, 
� ��������� ���� �� m4 (���� ���� ������� �����) �� ������� �� ������, ��-����� �� �������� ���������������, 
� ��� ���� ��������� ���� �� m0 �� ������� �� ����� �� ������ �� 50% �� ������� � ��������������� 
�� �������� �� m0 �� ���� �� m4, �� ����� m4 ���� �� ������� ���������� ������; 
��������� � ���� �� m1 ����������� �:c3�. 
(��� � ������� �� m1 ��������� ����������� �:F3�, ��������� �� � ��������� �����, 
����� ������� ��-�������� ���������� �� ���������� �� �������� �:�3�).
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   double ratio_p = ComparePriceDirection(3, 2);      
   if (Small_061(ratio_p)){  
      if (OverlapDirection(1, 3)){

         ratio_p = ComparePriceDirection(4, 2);      
         if (Small_261(ratio_p)){          
            
            if (NoSmallerDirection(2, 0, 4)){
               

               if (BreakBeginingLevel(4, /*(���� ���� ������� �����)*/1)){  
                
                  if (CheckTimeGoToBeginning(0, DirectionSumTimeLength(0, 4)*0.6, 4)){
                     AddDesignation(desig_c3, ""); 
                     
                     int index = FindDesignation("F3"); 
                     if (index != -1 ){
                        ReplaceDesignation(index, desig_F3, "[]");
                     }
                     
                  }
               }              
               
            }
         }
      }
   }
   return(0);   
}

int Rule_5_b_paragraph_6(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� ��������� ���� �� m1 (���� ���� ������� �����) �� ������� �� ����� �� ����������� ������� �� ������� ���������, 
� ��������� �� m2 � ����� 161.8% �� ��������� �� m1, � ��������� �� m3 � ��-����� �� 61.8% �� ��������� �� m2, 
� ��������� �� m(-1) � ������� 61.8% �� ��������� �� m0, 
� ��������� �� m(-2) �� ������ � ��������� 61.8% - 161.8% �� ��������� �� m(-1), 
� ��������� �� m(-3) � � ��������� 61.8% - 161.8% �� ��������� �� m(-2), 
� ��������� �� ������� �� ����� m2-m4 � ��-������ �� m0, 
�� � m1 ���� �� �������� ������ ����������; ��� ������� �� m1 �������� ����������� �:L3�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   if (BreakBeginingLevel(1, /*(���� ���� ������� �����)*/1)){
      
      double ratio_p = ComparePriceDirection(2, 1);      
      if (Large_161(ratio_p)){
      
         ratio_p = ComparePriceDirection(3, 2);      
         if (Small_061(ratio_p)){ 
                  
            ratio_p = ComparePriceDirection(-1, 0);      
            if (Large_061(ratio_p)){ 
              
               ratio_p = ComparePriceDirection(-2, -1);      
               if (Large_061(ratio_p) && Small_161(ratio_p)){ 
              
                  ratio_p = ComparePriceDirection(-3, -2);      
                  if (Large_061(ratio_p) && Small_161(ratio_p)){ 
              
                     ratio_p = ComparePrice(DirectionSumPriceLength(2, 4), DirectionPriceLenght(0));      
                     if (Large_100(ratio_p)){               
                     
                        AddDesignation(desig_L3, ""); 
                     
                     }
              
                  }                
              
               }               
              
            }                                      
         }
      }
   }
   return(0);   
}

int Rule_5_b_paragraph_7(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� ��������� ���� �� m1 (���� ���� ������� �����) �� ������� �� ����� �� ����������� ������� �� ������� ���������, 
� ��������� �� m1 �� ��������� 161.8%, �� ��������� �� m(-1), � ��������� �� m2 ����� ������� 161.8% ��������� �� m1, 
� ��������� �� m3 � ��-����� �� 61.8% �� ��������� �� m2, � ��������� �� ������� �� ����� m2-m4 � ��-������ m0, 
�� m1 ���� �� �������� ������ ��������; ��� ������� �� m1 �������� ����������� �:L5�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   if (BreakBeginingLevel(1, /*(���� ���� ������� �����)*/1)){
      
      double ratio_p = ComparePriceDirection(1, -1);      
      if (Small_161(ratio_p)){
      
         ratio_p = ComparePriceDirection(2, 1);      
         if (Large_161(ratio_p)){ 
                  
            ratio_p = ComparePriceDirection(3, 2);      
            if (Small_061(ratio_p)){ 
            
               ratio_p = ComparePrice(DirectionSumPriceLength(2, 4), DirectionPriceLenght(0));      
               if (Large_100(ratio_p)){  
               
                  AddDesignation(desig_L5, "");            
                  
               }                  
            }
         }            
      }            
   }            
   return(0);   
}

int Rule_5_b_paragraph_8(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� m(-1) e ��-������ �� m0, � ��������� ���� �� m2 (���� ���� ������� �����) 
�� ������� �� ����� �� ����������� ������� �� ������� ���������, � m0 �� � ���-�������� �� ������� m(-2) � m2, 
� ��������� ���� �� m(-2) �� ������� (��� �������) �� ����� �� ������ �� 50% �� ������� �� �������� �� m(-2) �� ���� �� m2, 
�� � m2 ���� �� �������� ���������� ������; �������� � ���� �� m1 ����������� �(:sL3)�.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   double ratio_p = ComparePriceDirection(-1, 0);      
   if (Small_100(ratio_p)){
   
      if (BreakBeginingLevel(2, /*(���� ���� ������� �����)*/1)){

           
         if (NoSmallerDirection(0, -2, 2)){        
            
            if (CheckTimeGoToBeginning(-2, DirectionSumTimeLength(-2, 2)*0.6, 2)){
             
               AddDesignation(desig_sL3, "()"); 
               
            }
            
         }
        
      }
   }      
      

   return(0);   
}

int Rule_5_b_paragraph_9(){
/* 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
��� ���� ���� �� ��������� ������� �� ����������� �� �������� ��������, � m1 � ���������, 
��������� � ���� �� m1  ������� ��� ������������ ����������� �� ������� 5, � ������ �{:F3/:c3/:5/:L5/(:L3)}�. 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/               
   if (CountArrayDesignations() == 0){
      AddDesignation(desig_F3, ""); 
      AddDesignation(desig_c3, ""); 
      AddDesignation(desig_5, ""); 
      AddDesignation(desig_L5, ""); 
      AddDesignation(desig_L3, "()"); 
   }
   return(0);   
}