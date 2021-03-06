//-------Управление на капитала---------
//-------Фиксирано фракционен метод-----
extern bool MM_FF = false;
extern double MM_FF_Percent = 1;
//-------Фиксирано фракционен метод-----
extern bool MM_FF_Atr = false;
extern int MM_FF_Atr_Period = 20;
extern double MM_FF_Atr_ContractSize = 100000;
extern double MM_FF_Atr_Percent = 1;
//---Фиксирано пропорционален метод-----
extern bool MM_FP = false;
extern double MM_FP_Percent = 1;
extern double MM_FP_Contract = 0.1;
extern int MM_FP_Ratio = 2;
extern int MM_FP_LevelContract_step = 1;

//---Без управление на капитала---------
extern double Lots = 1;
//--------------------------------------

//-----------MM параметри ---------------
double MM_FP_Delta;
double MM_FP_LevelContract = 1;
double MM_FP_UpLevel, MM_FP_DownLevel;
//---------------------------------------

void InitializeMM(){
   MM_FP_Delta = NormalizeDouble( (((MM_FP_Percent/100)* AccountEquity())/MM_FP_Ratio)/MM_FP_Contract, 0) ;
   MM_FP_UpLevel = AccountEquity() + MM_FP_LevelContract * MM_FP_Delta;
   MM_FP_DownLevel = AccountEquity();
   //Debug
   //Print("Delta = ", MM_FP_Delta, " DownLevel = ", MM_FP_DownLevel," LevelContract = ", MM_FP_LevelContract," UpLevel = ",MM_FP_UpLevel);
}

void CalcMM(){
   if (MM_FF){
      //Управление на капитала по фиксирано фракционен метод, големината на позицията зависи от големината на стоплоса
      //съобразена със процента риск.
      double dolars_point = 1000 * Point;
      double Risk_Loss_dolars = AccountEquity() * (MM_FF_Percent/100);
      Lots = NormalizeDouble( (Risk_Loss_dolars/ (dolars_point * StopLoss))/100 , 2);      
   }else{  
      if (MM_FF_Atr){
         //Управление на капитала по фиксирано фракционен метод, големината на позицията зависи от големината на стоплоса
         //съобразен и изчислен по ATR20.      
         double MV = iATR(NULL, 0, MM_FF_Atr_Period, 1) * MM_FF_Atr_ContractSize;
         Lots = ((MM_FF_Atr_Percent/100)*AccountEquity())/MV;
         Lots = NormalizeDouble(Lots, 2);
         
      }else{
         //Управление на капитала по фиксирано пропорцияонален метод 
         if (MM_FP){
            if (AccountEquity() > MM_FP_UpLevel){
               MM_FP_LevelContract = MM_FP_LevelContract + MM_FP_LevelContract_step;       
               MM_FP_DownLevel = MM_FP_UpLevel; 
               MM_FP_UpLevel = MM_FP_UpLevel + MM_FP_LevelContract * MM_FP_Delta;                                   
            }else{
               if (AccountEquity() < MM_FP_DownLevel){                             
                  MM_FP_LevelContract = MM_FP_LevelContract -  MM_FP_LevelContract_step;   
                  if (MM_FP_LevelContract < 1){ 
                     MM_FP_LevelContract = 1;
                  }else{
                     MM_FP_UpLevel = MM_FP_DownLevel;
                     MM_FP_DownLevel = MM_FP_UpLevel - MM_FP_LevelContract * MM_FP_Delta;               
                  }                                             
               }
            }      
            Lots = NormalizeDouble(MM_FP_LevelContract * MM_FP_Contract, 2);
            //Debug--
            //Print("Delta = ", MM_FP_Delta, " DownLevel = ", MM_FP_DownLevel," LevelContract = ", MM_FP_LevelContract," UpLevel = ",MM_FP_UpLevel);         
         }   
      }         
   }   

   if (Lots > 10){Lots = 10;}   
}