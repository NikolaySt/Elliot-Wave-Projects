void LongShortCondition(int time, int price, int bias, int shift, double high, double low){
   
   if (time == 1 && price == 1 && bias == 1){
      BuffHigh[shift] = low;
      BuffLow[shift] = high;      
   }else{
      if (time == 2 && price == -1 && bias == -1){
         BuffHigh[shift] = high;
         BuffLow[shift] = low;   
      }
   } 
   
}