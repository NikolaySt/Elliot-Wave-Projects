double GetSizeLot(){ return(Lots);} 
double GetStopLossBuy() { return(Bid - StopLoss*Point);} 
double GetStopLossSell(){ return(Ask + StopLoss*Point);} 
double GetTakeProfitBuy(){ return(Ask + TakeProfit*Point);}
double GetTakeProfitSell() { return(Bid - TakeProfit*Point);}

bool ExistPositions() {
   for (int i=0; i < OrdersTotal() - 1; i++) {      
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
				return(True);
			}
		}else{
		   ViewLastError(GetLastError());		   
		}
	} 
	return(false);
}

bool ExistPositionsOpenBuy() {
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_BUY) { 
				  return(True);
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(false);
}

bool ExistPositionsOpenSell() {
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_SELL) { 
				  return(True);
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(false);
}

void RemoveStopOrder(int FindCount = 10, int Buy_Sell = 0) {
   bool check_exit = false;
   int i = 0;
   while (OrdersTotal() > 0 && !check_exit){      
      
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
         if ((Buy_Sell == 0)||(Buy_Sell == 1)){
	        if (OrderType()==OP_SELLSTOP){ 
	           if (!OrderDelete(OrderTicket())){
	              ViewLastError(GetLastError());
	           }else{
                 i = i - 2;		      
	           }
	        }
         }
         if ((Buy_Sell == 0)||(Buy_Sell == 2)){
		     if (OrderType()==OP_BUYSTOP) { 			      
		       if (!OrderDelete(OrderTicket())){
		          ViewLastError(GetLastError());
		       }else{		          
                i = i - 2;
		       }
		     }
		   }      
		}
      i++;
      if (i > FindCount) {check_exit = true;}      
   }
	return(true);
}

void TrailingPositionsBuy(int trailingStop) { 
   for (int i=0; i<OrdersTotal(); i++) { 
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { 
         if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) { 
            if (OrderType()==OP_BUY) { 
               if (Bid-OrderOpenPrice()>trailingStop*Point) { 
                  if (OrderStopLoss()<Bid-trailingStop*Point) 
                     ModifyStopLoss(Bid-trailingStop*Point); 
               } 
            } 
         } 
      }else{
         ViewLastError(GetLastError());
      }
   } 
}
 
void TrailingPositionsSell(int trailingStop) { 
   int check;
   for (int i=0; i < OrdersTotal(); i++) { 
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { 
         if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) { 
            if (OrderType()==OP_SELL) { 
               if (OrderOpenPrice()-Ask>trailingStop*Point) { 
                  if (OrderStopLoss()>Ask+trailingStop*Point || OrderStopLoss()==0)  
                     ModifyStopLoss(Ask+trailingStop*Point); 
               } 
            } 
         } 
      }else{
         ViewLastError(GetLastError());  
      }
   } 
} 

void ModifyStopLoss(double ldStopLoss) { 
   bool fm;
   fm = OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);       
   if (fm){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
}

void ModifyStopLoss_Buy(double ldStopLoss, int IndexPosition = -1) { 
   bool fm;
   int index = 0;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_BUY) { 
			      index++;
			      if (IndexPosition == -1){
                  fm = OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);  
                  if (fm){      
                     if (UseSound) PlaySound(NameFileSound); 
                  }else{
                     ViewLastError(GetLastError());
                  }	                  
               }else{
                  if (index == IndexPosition){
                     fm = OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);  
                     if (fm){      
                        if (UseSound) PlaySound(NameFileSound); 
                     }else{
                        ViewLastError(GetLastError());
                     }	                  
                  }
               }	     
				  //return(True);
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(false);
}

void ModifyStopLoss_Sell(double ldStopLoss, int IndexPosition = -1) { 
   bool fm;
   int index = 0;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if ((OrderType()==OP_SELL)) { 
			      index++;
			      if (IndexPosition == -1){
                  fm = OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);  
                  if (fm){      
                     if (UseSound) PlaySound(NameFileSound); 
                  }else{
                     ViewLastError(GetLastError());
                  }	                  
               }else{
                  if (index == IndexPosition){
                     fm = OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);  
                     if (fm){      
                        if (UseSound) PlaySound(NameFileSound); 
                     }else{
                        ViewLastError(GetLastError());
                     }	                  
                  }
               }				     
				  //return(True);
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(false);
}

void OpenBuy() { 
   double ldLot, ldStop, ldTake; 
   string lsComm; 
   ldLot = GetSizeLot(); 
   ldStop = GetStopLossBuy(); 
   ldTake = GetTakeProfitBuy(); 
   lsComm = GetCommentForOrder(); 
   int check = OrderSend(Symbol(),OP_BUY,ldLot,Ask,Slippage,ldStop,ldTake,lsComm,MAGIC,0,clOpenBuy); 
   
   if (check != -1){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
} 

void OpenSell() { 
   double ldLot, ldStop, ldTake; 
   string lsComm; 

   ldLot = GetSizeLot(); 
   ldStop = GetStopLossSell(); 
   ldTake = GetTakeProfitSell(); 
   lsComm = GetCommentForOrder(); 
   int check = OrderSend(Symbol(),OP_SELL,ldLot,Bid,Slippage,ldStop,ldTake,lsComm,MAGIC,0,clOpenSell); 
   
   if (check != -1){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
} 

void CloseBuy() { 
   bool fc; 
   fc = OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, clCloseBuy); 
   if (fc){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
} 

void CloseSell() { 
   bool fc; 
   fc = OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, clCloseSell); 
   if (fc){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
} 
int myBars;

bool OpenNewBar()
   {
   if (myBars!=Bars){
      myBars=Bars;
      return(true);
   }
   return(false);   
}

void SetBuyStopOrder(double Price, double StopLoss, double TakeProfit) { 
   double ldLot, ldStop, ldTake; 
   string lsComm; 
   ldLot = GetSizeLot(); 
   ldStop = StopLoss; 
   ldTake = TakeProfit; 
   lsComm = GetCommentForOrder(); 
   int check = OrderSend(Symbol(),OP_BUYSTOP, ldLot, Price, Slippage, ldStop, ldTake, lsComm, MAGIC, 0, clBuyStop); 
   
   if (check != -1){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
} 

void SetSellStopOrder(double Price, double StopLoss,  double TakeProfit) { 
   double ldLot, ldStop, ldTake; 
   string lsComm; 
   ldLot = GetSizeLot(); 
   ldStop = StopLoss; 
   ldTake = TakeProfit; 
   lsComm = GetCommentForOrder(); 
   int check = OrderSend(Symbol(),OP_SELLSTOP, ldLot, Price, Slippage, ldStop, ldTake, lsComm, MAGIC, 0, clSellStop); 
   
   if (check != -1){      
      if (UseSound) PlaySound(NameFileSound); 
   }else{
      ViewLastError(GetLastError());
   }
} 


double OpenPriceBuy(int IndexPosition = -1) {
   int index = 0;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_BUY) { 
			       index++;
			       if (IndexPosition == -1){
			         return(OrderOpenPrice());
			       }else{
			         if (index == IndexPosition){
                     return(OrderOpenPrice());			         
			         }			         
			       }	
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(0);
}


double OpenPriceSell(int IndexPosition = -1) {
   int index = 0;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_SELL) { 
			       index++;
			       if (IndexPosition == -1){
			         return(OrderOpenPrice());
			       }else{
			         if (index == IndexPosition){
                     return(OrderOpenPrice());			         
			         }			         
			       }				      				  
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(0);
}

int CountOpenBuy(){
   int count;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_BUY) { 
				  count++;
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(count);
}

int CountOpenSell(){
   int count;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_SELL) { 
				  count++;
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(count);
}

double GetStopLoss_Buy(int IndexPosition = -1){
   int index = 0;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_BUY) {
			       index++;
			       if (IndexPosition == -1){
			         return(OrderStopLoss());  
			       }else{
			         if (index == IndexPosition){
                     return(OrderStopLoss());			         
			         }			         
			       }				    
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(0);
}

double GetStopLoss_Sell(int IndexPosition = -1){
   int index = 0;
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC) {
			   if (OrderType()==OP_SELL) {
			       index++;
			       if (IndexPosition == -1){
			         return(OrderStopLoss());  
			       }else{
			         if (index == IndexPosition){
                     return(OrderStopLoss());			         
			         }			         
			       }				    
				}
			}
		}else{
		   ViewLastError(GetLastError());
		}
	} 
	return(0);
}