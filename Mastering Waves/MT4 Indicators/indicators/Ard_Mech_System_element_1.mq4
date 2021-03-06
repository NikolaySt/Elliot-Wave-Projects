//+------------------------------------------------------------------+
//|                                    Ard_Mech_System_element_1.mq4 |
//|                                    Copyright © 2007 Ariadna Ltd. |
//|                                              revision 06.09.2007 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Ariadna Ltd."
#property link      "revision 06.09.2007"

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
int start(){
   int limit = Bars - IndicatorCounted();
   
   // Shift index - H4
   int shift_h4;
   //
   
   // Aligator Line H4
   double Red_Line_h4;
   //
   
   // Fractals
   double value;
   double up_fractal_h4, up_fractal_h4_old_1, up_fractal_h4_old_2;
   double down_fractal_h4, down_fractal_h4_old_1, down_fractal_h4_old_2;
   //
   
   //Bars Extremum
   double curr_bar_high_h4, curr_bar_low_h4;
   //
   
   // Diraction Change
   int direction_up_down = 0; 
      //-1 движение надолу
      //+1 движение нагоре      
   //
  
   int period = PERIOD_D1;
   for (int i = limit - 1; i >= 0; i--){
   
      shift_h4 = iBarShift(NULL, period, Time[i]);      
      Red_Line_h4 = iMA(NULL, period, 8, 5, MODE_SMMA, PRICE_MEDIAN, shift_h4);       
               
      curr_bar_high_h4 = iHigh(NULL, period, shift_h4);
      curr_bar_low_h4 = iLow(NULL, period, shift_h4);
         
      value = iFractals(NULL, period, MODE_UPPER, shift_h4+1);
      if (value != 0) { 
         up_fractal_h4 = value; 
         up_fractal_h4_old_2 = up_fractal_h4_old_1;
         up_fractal_h4_old_1 = up_fractal_h4;          
      } 

      value = iFractals(NULL, period, MODE_LOWER, shift_h4+1);
      if (value != 0) { 
         down_fractal_h4 = value; 
         down_fractal_h4_old_2 = down_fractal_h4_old_1;
         down_fractal_h4_old_1 = down_fractal_h4; 
      }
      
      if (direction_up_down == 0){
         if (curr_bar_high_h4 > up_fractal_h4 && up_fractal_h4 >= Red_Line_h4){
            direction_up_down = +1;
         }
         
         if (curr_bar_low_h4 < down_fractal_h4 && down_fractal_h4 <= Red_Line_h4){
            direction_up_down = -1;
         }         
      }else{
         switch (direction_up_down){
            case 1:
               {
                  if (curr_bar_low_h4 < down_fractal_h4 && down_fractal_h4 <= Red_Line_h4 && down_fractal_h4 != 0 ){
                     direction_up_down = -1;
                  }
                  if (curr_bar_low_h4 < down_fractal_h4_old_1 && down_fractal_h4_old_1 <= Red_Line_h4 && down_fractal_h4_old_1 != 0 ){
                     direction_up_down = -1;
                  }         
                  if (curr_bar_low_h4 < down_fractal_h4_old_2 && down_fractal_h4_old_2 <= Red_Line_h4 && down_fractal_h4_old_2 != 0 ){
                     direction_up_down = -1;
                  }  
                  
                  //Пробит фрактал който си губи силата
                  if (curr_bar_low_h4 < down_fractal_h4) {down_fractal_h4 = 0;}                                              
                  if (curr_bar_low_h4 < down_fractal_h4_old_1) {down_fractal_h4_old_1 = 0;}                            
                  if (curr_bar_low_h4 < down_fractal_h4_old_2) {down_fractal_h4_old_2 = 0;}                                              
               break;}
            case -1: 
               {
                  if (curr_bar_high_h4 > up_fractal_h4 && up_fractal_h4 >= Red_Line_h4 && up_fractal_h4 != 0){
                     direction_up_down = +1;
                  }   
                  if (curr_bar_high_h4 > up_fractal_h4_old_1 && up_fractal_h4_old_1 >= Red_Line_h4 && up_fractal_h4_old_1 != 0){
                     direction_up_down = +1;
                  }
                  if (curr_bar_high_h4 > up_fractal_h4_old_2 && up_fractal_h4_old_2 >= Red_Line_h4 && up_fractal_h4_old_2 != 0){
                     direction_up_down = +1;
                  }             
                  
                  //Пробит фрактал който си губи силата
                  if (curr_bar_high_h4 > up_fractal_h4) {up_fractal_h4 = 0;}                                              
                  if (curr_bar_high_h4 > up_fractal_h4_old_1) {up_fractal_h4_old_1 = 0;}                            
                  if (curr_bar_high_h4 > up_fractal_h4_old_2) {up_fractal_h4_old_2 = 0;}  
                                                                       
               break;}            
         }      
      }                
      
      switch (direction_up_down){
         case 1:
            {
               ExtMapBuffer1[i] = Low[i];
               ExtMapBuffer2[i] = High[i];              
            break;}
         case -1: 
            {
               ExtMapBuffer1[i] = High[i];
               ExtMapBuffer2[i] = Low[i];            
            break;}            
      } 
   
   }

   return(0);
}
//+------------------------------------------------------------------+