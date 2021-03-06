//+------------------------------------------------------------------+
//|                                                 Ard_Logic_AO.mq4 |
//|                                    Copyright © 2007 Ariadna Ltd. |
//|                                              revision 06.10.2007 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Ariadna Ltd."
#property link      "revision 06.10.2007"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 Green
#property indicator_color4 Red
#property indicator_width3 2
#property indicator_width4 2
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double buff_buy_signals[];
double buff_sell_signals[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,ExtMapBuffer2);
   
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2, SYMBOL_ARROWUP);
   SetIndexBuffer(2,buff_buy_signals);   
   
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3, SYMBOL_ARROWDOWN);
   SetIndexBuffer(3,buff_sell_signals);      
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start(){
   
   int limit = Bars - IndicatorCounted();
   
   int shift_basic_period;
   int basic_period = PERIOD_D1;
   double AO_basic_0, AO_basic_1;
   int break_ao_basic = 0; 
   //тренд 1 пробив нагоре
   //тренд -1 пробив надолу
   
   int shift_secondary_period;
   int secondary_period = PERIOD_H4;
   double AO_secondary_0, AO_secondary_1, AO_secondary_2;
   int signal_1_secondary;
   //сигнал  = 1 екстремум под нулата
   //сигнал  = -1 екстремум над нулата
   int break_ao_secondary = 0; 
   //тренд 1 пробив нагоре
   //тренд -1 пробив надолу   
   
   
   int shift_third_period;
   int third_period = PERIOD_H1;
   double AO_third_0, AO_third_1, AO_third_2;
   int signal_1_third;
   //сигнал  = 1 екстремум под нулата
   //сигнал  = -1 екстремум над нулата   
   
   
   double offset_arraw_signal;
   
   for (int i = limit - 1; i >= 0; i--){
      
      offset_arraw_signal = iATR(NULL, 0, 21, i) * 0.45;
      
      //Определяме Пробив на Нулева линия за нагоре
      shift_basic_period = iBarShift(NULL, basic_period, Time[i]);   
      AO_basic_0 = iAO(NULL, basic_period, shift_basic_period); 
      AO_basic_1 = iAO(NULL, basic_period, shift_basic_period+1); 
      if (AO_basic_0 > 0 && AO_basic_1 < 0){
         break_ao_basic = 1;
      }      
      if (AO_basic_0 < 0 && AO_basic_1 > 0){
         break_ao_basic = -1;
      }     
      //----------------------------------------------------------------------------
      
      //Определяме Пробив на Нулева линия за нагоре
      shift_secondary_period = iBarShift(NULL, secondary_period, Time[i]);   
      AO_secondary_0 = iAO(NULL, secondary_period, shift_secondary_period); 
      AO_secondary_1 = iAO(NULL, secondary_period, shift_secondary_period+1);                   
      AO_secondary_2 = iAO(NULL, secondary_period, shift_secondary_period+2);                
      
      if (AO_secondary_0 > 0 && AO_secondary_1 < 0){
         break_ao_secondary = 1;
      }      
      if (AO_secondary_0 < 0 && AO_secondary_1 > 0){
         break_ao_secondary = -1;
      }           
      //----------------------------------------------------------------------------
      
      
      //Определяме Пробив на Нулева линия за нагоре
      shift_third_period = iBarShift(NULL, third_period, Time[i]);   
      AO_third_0 = iAO(NULL, third_period, shift_third_period); 
      AO_third_1 = iAO(NULL, third_period, shift_third_period+1);                   
      AO_third_2 = iAO(NULL, third_period, shift_third_period+2);    
      
      //----------------------------------------------------------------------------     
      
      switch (break_ao_basic){
         case 1:{
            //ExtMapBuffer1[i] = Low[i];
            //ExtMapBuffer2[i] = High[i];              
            
            
            if (AO_secondary_0 < 0){ //break_ao_secondary == 1){
            
               //Сигнали КУПУВА-----------------------------------------------------------------
               //Signal 1 - под нулева линия
               if (AO_third_0 < 0 && AO_third_1 <= 0 && 
                  AO_third_0 > AO_third_1 && 
                  AO_third_1 < AO_third_2) {
                  signal_1_third = 1; 
               }else{     
                  //Signal 1 - над нулевата линия 
                  //if (AO_third_0 > 0 && AO_third_1 > 0 && AO_third_2 > 0
                  //   && AO_third_0 > AO_third_1 && AO_third_1 < AO_third_2) {
                  //   signal_1_third = 2; 
                  //}else{
                     signal_1_third = 0; 
                  //}      
               }         
               //--------------------------------------------------------------------------------            
            
               if (signal_1_third == 1 || signal_1_third == 2) buff_buy_signals[i] = Low[i] - offset_arraw_signal;            
            }
            break;}
         case -1:{
            ExtMapBuffer1[i] = High[i];
            ExtMapBuffer2[i] = Low[i];    
            
            //Сигнали ПРОДАВА-----------------------------------------------------------------
            //Signal 1 - Над нулева линия
            if (AO_secondary_0 > 0 && AO_secondary_1 >= 0 && 
               AO_secondary_0 < AO_secondary_1 && 
               AO_secondary_1 > AO_secondary_2) {
               signal_1_secondary = -1; 
            }else{
               //Signal 1 - под нулевата линия 
               if (AO_secondary_0 < 0 && AO_secondary_1 < 0 && AO_secondary_2 < 0
                  && AO_secondary_0 < AO_secondary_1 && AO_secondary_1 > AO_secondary_2) {
                  signal_1_secondary = -2; 
               }else{
                  signal_1_secondary = 0; 
               } 
            }      
            //--------------------------------------------------------------------------------            
                  
            if (signal_1_secondary == -1 || signal_1_secondary == -2) buff_sell_signals[i] = High[i] + offset_arraw_signal;            
            break;}             
      }                       
      
   }

   return(0);
}
//+------------------------------------------------------------------+