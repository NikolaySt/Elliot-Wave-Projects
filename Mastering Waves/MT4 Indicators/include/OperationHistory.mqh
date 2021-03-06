void History_OpenPosition_Print(){
   int i, hstTotal = HistoryTotal();
   for(i = 0; i < hstTotal; i++){
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)){     
         if ((OrderType() == OP_BUY) || (OrderType() == OP_SELL)){
            Print(
               OrderTicket(),", ", 
               TimeToStr(OrderOpenTime()),", " ,
               OrderSymbol(),", ",
               OrderLots(),", ",
               OrderOpenPrice(),", " ,
               OrderClosePrice(),", " ,
               TimeToStr(OrderCloseTime()),", " ,
               OrderProfit());
         }            
      }
   }
}

bool History_OpenPosition_SaveToFile(string FileName =  "history.txt"){
   int i, hstTotal = HistoryTotal();
   string Pos;
   int file;
   
   //FileDelete(FileName);
   file = FileOpen(FileName, FILE_WRITE, ',');
   
   if (file < 1){
     //Print("File " + FileName + ", the last error is ", ViewLastError(GetLastError()));
     return(false);   
   }
 
   for(i = 0; i < hstTotal; i++){
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)){     
         if ((OrderType() == OP_BUY) || (OrderType() == OP_SELL)){
            Pos = 
               OrderTicket() + ", " + 
               TimeToStr(OrderOpenTime()) + ", " + 
               OrderSymbol() + ", " + 
               DoubleToStr(OrderLots(),2) + ", " + 
               DoubleToStr(OrderOpenPrice(),4) + ", " + 
               DoubleToStr(OrderClosePrice(),4) + ", " + 
               TimeToStr(OrderCloseTime()) + ", " + 
               DoubleToStr(OrderProfit(),2);
            FileWrite(file, Pos);            
         }            
      }
   }

   FileClose(file);
   return(true);
}

string RR_string_value = "";
string Cognoscibility_string_value = "";

double Clac_PMO(bool ValueProfit = false, bool print = true){
   int i, hstTotal = HistoryTotal();
   int cound_all_position, count_profit, count_loss, count_zero = 0;
   double sum_loss, sum_profit = 0;
   double profit_loss;
   for(i = 0; i < hstTotal; i++){
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)){     
         if ((OrderType() == OP_BUY) || (OrderType() == OP_SELL)){
            cound_all_position++;
            if (ValueProfit){
               profit_loss = OrderProfit();   
            }else{
               profit_loss = (OrderOpenPrice() - OrderClosePrice())*(1/Point);
            }
            if (OrderProfit() >= 0){
               profit_loss = MathAbs(profit_loss);
            }else{
               if (profit_loss > 0 ){
                  profit_loss = -1*profit_loss;
               }
            }            
            if (profit_loss > 0){
               count_profit++;
               sum_profit = sum_profit + MathAbs(profit_loss);
               
            }
            if (profit_loss < 0){
               count_loss++;
               sum_loss = sum_loss + MathAbs(profit_loss);
            }
            if (profit_loss == 0){count_zero++;}
         }            
      }
   }

   double RR = NormalizeDouble((sum_profit/count_profit) / (sum_loss/count_loss), 5);
   double cognoscibility = NormalizeDouble(count_profit, 0)/NormalizeDouble(cound_all_position, 0); 
   double PMO = ((1 + RR) * cognoscibility) - 1;  
   
   RR_string_value = DoubleToStr(RR, 2);
   Cognoscibility_string_value = DoubleToStr(NormalizeDouble(cognoscibility*100,2),2);
   
   if (print){
      Print("All: ", cound_all_position, ", ", 
      "count_profit: ", count_profit, ", ", 
      "sum_profit: ", sum_profit, ", ", 
      "count_loss: ", count_loss, ", ",
      "sum_loss: ", sum_loss);   
      Print("Risk/Return = 1/", 
      NormalizeDouble(1/( (sum_loss/count_loss)/(sum_profit/count_profit)), 2), ", ", 
         "Познаваемост = ", NormalizeDouble(cognoscibility*100,2), "%");
      Print("PMO = ", NormalizeDouble(PMO*100, 2), "%");
   }
   return (PMO);
}

