//+------------------------------------------------------------------+
//|                                          Ard_Alligator_Cross.mq4 |
//|                                    Copyright © 2007 Ariadna Ltd. |
//|                                              revision 02.10.2007 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Ariadna Ltd."
#property link      "revision 02.10.2007"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Green
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
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
int start()
  {
   int  limit = Bars - IndicatorCounted();
   double trend = 1;
   for (int i = limit - 1; i >= 0; i--){  
      
      if (Close[i] < Low[i+1] && Close[i] < Low[i+2] &&
         Close[i] < Low[i+3] &&  Close[i] < Low[i+4] &&
         trend == -1){
         
         trend = 1;
      }

      if (Close[i] > High[i+1] && Close[i] > High[i+2] &&
         Close[i] > High[i+3] && Close[i] > High[i+4] &&
         trend == 1){
         
         trend = -1;
      }      
      
      
      if (trend == 1){

         ExtMapBuffer1[i] = High[i];
         ExtMapBuffer2[i] = Low[i];         
      }
      
      if (trend == -1){
         ExtMapBuffer1[i] = Low[i];
         ExtMapBuffer2[i] = High[i];
      }   
   }         
   return(0);
  }
//+------------------------------------------------------------------+