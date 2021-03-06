//+------------------------------------------------------------------+
//|                                               Ard_AO_Signals.mq4 |
//|                                    Copyright © 2007 Ariadna Ltd. |
//|                                              revision 08.09.2007 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Ariadna Ltd."
#property link      "revision 08.09.2007"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 ForestGreen
#property indicator_color3 Blue
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
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
   SetIndexArrow(2,159);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexEmptyValue(2,0.0);
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
   
   int    limit = Bars - IndicatorCounted();
   double AO, AO1, AO2;
   
   for(int i = limit - 1; i >= 0; i--){
      AO = iAO(NULL, 0, i);
      AO1 = iAO(NULL, 0, i + 1);
      AO2 = iAO(NULL, 0, i + 2);
      if ((AO < 0 && AO1 < 0 && AO2 < 0) && (AO > AO1 && AO1 < AO2)){
         ExtMapBuffer1[i] = Low[i];
         ExtMapBuffer2[i] = High[i];
         ExtMapBuffer3[i] = Low[i];
      }
      
      if ((AO > 0 && AO1 > 0 && AO2 > 0) && (AO < AO1 && AO1 > AO2)){
         ExtMapBuffer1[i] = High[i];
         ExtMapBuffer2[i] = Low[i];
         ExtMapBuffer3[i] = High[i];
      }      
      
   }
   return(0);
  }
//+------------------------------------------------------------------+