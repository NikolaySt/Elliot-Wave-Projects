
string GetCommentForOrder() {return(Name_Expert);} 

bool CheckBeforeBegin(){
   if (Account != AccountNumber()){
      Comment("Trade on account :"+AccountNumber()+" FORBIDDEN!");
      return(0);
   }else {Comment("");}

   if(Bars<100){ 
      Print("bars less than 100");
      return(false);
   } 
   
   if(StopLoss<10){
      Print("StopLoss less than 10");
      return(false);
   }
   
   if(AccountFreeMargin()<(1000*Lots)){
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return(false);
   }
   
   if (!OpenNewBar()){
      return(0);   
   }   

   return(true);   
}
#include "stderror.mqh"

int ViewLastError(int ErrorCode){
   Print("error(",ErrorCode,"): ", ErrorDescription(ErrorCode));
   return(0);
}