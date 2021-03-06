//+------------------------------------------------------------------+
//|                                                 Copyright © 2010 |
//|                                                 RIVER TECHNOLOGY |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010"

#property indicator_chart_window
#property indicator_buffers 2

#property indicator_color1 Red
#property indicator_width1 2

#property indicator_color2 Lime
#property indicator_width2 2


double BuffUp[];
double BuffDown[];

extern bool ViewTime = true;
extern bool ViewPrice = true;
extern bool ViewBias = true;
extern bool SmallTimeFrame = true;
extern bool LargeTimeFrame = true;

bool check_trace = false;
bool ActiveSetToChart = false;

#include <NRT\MLArrays.mqh>
#include <NRT\RTMain.mqh>
#include <NRT\RTLogic.mqh>
#include <NRT\BiasLogic.mqh>
#include <NRT\PriceLogic.mqh>
#include <NRT\TimeLogic.mqh>
#include <NRT\ChannelLogic.mqh>
#include <NRT\DrawObj.mqh>
#include <NRT\Utils.mqh>

int CALC_TIMEFRAME;
void SetTimeFrame(int timeframe){ CALC_TIMEFRAME = timeframe;}
int GetTimeFrame(){ return(CALC_TIMEFRAME);}

int CalcUpTimeFrame( int TimeFrame )
{
   switch(TimeFrame){
      case PERIOD_M1: return(PERIOD_M5);
      case PERIOD_M5: return(PERIOD_M15);
      case PERIOD_M15: return(PERIOD_H1);
      case PERIOD_M30: return(PERIOD_H4);
      case PERIOD_H1: return(PERIOD_H4);
      case PERIOD_H4: return(PERIOD_D1);
      case PERIOD_D1: return(PERIOD_W1);
      case PERIOD_W1: return(PERIOD_MN1);
      case PERIOD_MN1: return(PERIOD_MN1);
      default: return(0);
   }  
}


int init() {     
   DeleteObjects();      
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexBuffer(0, BuffUp);         
    
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexBuffer(1, BuffDown);      
   return(0);
}

int deinit()  {
   DeleteObjects();
   return(0);
}

void SetBiasToBuff(int index, double value){ 
   if (ActiveSetToChart) 
      DrawLine("line_point1_" + index + "_" + MathRand(), "Bias", index, index, value, value, DodgerBlue, 8, STYLE_SOLID, true);
}   
void SetPriceToBuff(int index, double value){
   if (ActiveSetToChart)   
      DrawLine("line_point2_" + index + "_" + MathRand(), "Price", index, index, value, value, MediumOrchid, 8, STYLE_SOLID, true);
}
void SetTimeBreakToBuff(int index, double value){
   if (ActiveSetToChart)
      DrawLine("line_point3_" + index + "_" + MathRand(), "Time", index, index, value, value, Brown, 8, STYLE_SOLID, true);
}

void SetControlBuff(int index, int control){
   if (ActiveSetToChart){
      if (control < 0){
         BuffUp[index] = High[index];
         BuffDown[index] = Low[index];
      }
      if (control > 0){
         BuffUp[index] = Low[index];
         BuffDown[index] = High[index];
      }
   }
}

int start(){          
   check_trace = false;
   DeleteObjects();
   
   if (SmallTimeFrame){
      //прави изчисления за SMALL timeframe
      SetTimeFrame(Period());   
      InitArraysParams(); 
      InitBiasParams(); 
      InitPriceParams();     
      InitTimeParams();
       
      ActiveSetToChart = true;  
      RT_Main_Process();
      Draw_MotionLine();
      DrawObj_Process();         
      //Draw_Peaks(); //- само при тестове и проверка работата на индикатора
   }
   
      
   if (LargeTimeFrame){
      //прави изчисления за LARGE timeframe
      SetTimeFrame(CalcUpTimeFrame(Period()));
      InitArraysParams(); 
      InitBiasParams(); 
      InitPriceParams();     
      InitTimeParams();
      
      ActiveSetToChart = false;
      RT_Main_Process();      
               
      Channel_Process();
      DrawObj_Process();
      
      CreateSmallSignal();
   }   
      
   return(0);
}








