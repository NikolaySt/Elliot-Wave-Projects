#define code_basic_id 1837456

bool CheckYear_Version(){
   int this_year = Year()  + code_basic_id;    
   int year_limit = 1839463; //2007
   if (this_year == year_limit){
      return(true);
   }else{
      return(false);
   }
}

/*
bool LimitCurrency(bool all = false){
   if (Symbol() == "EURUSD"){
      return(true);
   }else{
      return(false);
   }
}
*/

bool CheckAccountWork(){

   int number = AccountNumber()+code_basic_id;
   
   int bojo_real = 1840560; //3104
                            //3567
   int bojo_demo1 = 2051807; //214351 
   int bojo_demo2 = 2229138; //391682 
   
   //int niki_real = 1840660; //3204
   int niki_demo = 2037531; //200075
   
   //int mario_real = 1840543; //3087
   
   int momchil_demo = 2018629; //181173
   int momchil_real = 1840979; //3523
   
   //int andrio_ba6ta_real = 1840887; //3431
   
   //int zore_demo = 2059031; //221575 - //216590 neaktivna
   
   if (number == bojo_real || 
       number == bojo_demo1 || 
       number == bojo_demo2 || 
       
       //number == niki_real ||
       number == niki_demo ||
       
       //number == mario_real ||
       
       number == momchil_demo ||
       number == momchil_real //||
       
       //number == andrio_ba6ta_real ||
       
       //number == zore_demo
       ){   
       
      return(true);
   }else{
      return(false);
   }
}