//+------------------------------------------------------------------+
//|                                                Ard_TimeFrame.mq4 |
//|                                    Copyright © 2007 Ariadna Ltd. |
//|                                              revision 18.08.2007 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Ariadna Ltd."
#property link      "revision 18.08.2007"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Red
#property indicator_color5 Green
#property indicator_color6 Red

#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 5
#property indicator_width4 5
#property indicator_width5 1
#property indicator_width6 1

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double MABuff1[];
double MABuff2[];

#include <Utils\FloatTimeFrame.mqh>
#include <Utils\MovingAverage.mqh>
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,ExtMapBuffer4);
   
   SetIndexStyle(4,DRAW_SECTION);
   SetIndexShift(4, 3*5);
   SetIndexBuffer(4, MABuff1);   
   
   SetIndexStyle(5,DRAW_SECTION);
   SetIndexShift(5, 5*5);
   SetIndexBuffer(5, MABuff2);     
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
   int    counted_bars=IndicatorCounted();
   Create288Bars (ExtMapBuffer1,  ExtMapBuffer2, ExtMapBuffer4, ExtMapBuffer3, 1000);
   ema(MABuff1, GetBuffPriceCount()-1, 9);
   ema(MABuff2, GetBuffPriceCount()-1, 15);   
   
   return(0);
  }
//+------------------------------------------------------------------+

