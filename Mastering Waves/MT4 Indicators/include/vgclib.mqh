/* 
Библиотеката се поставя в поддиректорията experts\include на инсталирания MT4.
Всеки експерт използващ библиотеката трябва да започне със секция за дефиниране на специфични параметри и следният код:

#define DEF_SMN  500    //Използва се за стойност по подразбиране на параметъра SystemMagicNumber
#define DEF_BE   1      //Използва се за стойност по подразбиране на параметъра BreakEnter
#define DEF_EE   1      //Използва се за стойност по подразбиране на параметъра ExitExtend

#include <vgclib.mqh>

*/

//Общи параметри
extern double    TradeMM           = 2;             //Размер на залаганата или рискувана сума в зависимост от типа ММ.
extern int       TradeMMType       = 0;             //При 0 - сделки от един лот, 1 - процент на залагана сума , 2 - процент на рискувана сума
extern double    TradeBalance      = 0;             //Заделена сума. При указана нула използва цялата налична по сметката.
extern datetime  DateBalance       = D'2006.1.1';   //Кога е заделена сумата. Използва се при начална инициализация.
extern double    LimitBalance      = 0;             //Размер под който след като падне заделената сума се спира.
extern int       BreakEnter        = DEF_BE;        //Колко пипса под/над фрактала или друго ценово ниво е входа, стоповете
extern int       ExitExtend        = DEF_EE;        //Колко пипса да се опита да отмъкне при изход - когато се указва цел тези пипсове се добавят към целта, същото но обратно важи за стоповете
extern int       SystemMagicNumber = DEF_SMN;       //Уникален номер, който освен двойката се използва за откриване на пуснатите поръчки от конкретната конфигурация
extern int       MinStopMove       = 1;             //През колко най-малко пипса се мести стопа
extern int       IndicatorShift    = 1;             //Изчисленията се базират на това отместване. Стойност нула не е добра идея при Бек-тестове, а в доста случаи и при реална работа.
extern int       SlipPage          = 1;             //Какво отклонение разрешаваме на брокера при вход в позиция.
extern double    MinLots           = 0.1;           //Каква е най-малката позиция при брокера.
extern double    MaxLots           = 100;           //Каква е най-голямата позиция при брокера.
extern int       MinStopLoss       = 8;             //Какъв е най-малкият стоп при брокера.
extern int       MinTakeProfit     = 8;             //Какъв е най-малката цел при брокера.

#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Дефиниции указващи вида стоп който ще се използва/поддържа       |
//+------------------------------------------------------------------+
#define DEF_STOP_FIXED_PIPS  1  //Изискава параметър указващ конкретни пипсове
#define DEF_STOP_FIXED_PRICE 2  //Изискава параметър указващ конкретна цена за стопа
#define DEF_STOP_ATR         3  //Изискава параметър указващ броя използвани ATR, следващият е параметъра на самият ATR
#define DEF_STOP_LO_HI       4  //Изискава параметър указващ броя барове които ще се проверят за най-малка/висока стойност. Вторият параметър указва минимален размер на стопа в пипсове.
#define DEF_STOP_FRACTAL     5  //Първият параметър указва максимален размер на стопа в пипсове. Вторият параметър указва минимален размер на стопа в пипсове. Или с други думи стопа е между двата параметъра.
#define DEF_STOP_SAFEZONE    6  //По безопасната зона на Елдер. Първият параметър указва мултипликатора - по подразбиране е 2, вторият периода за изч.на отстоянието - по подразбиране е 20
#define DEF_STOP_SAR         7  //По parabolic SAR. Първият параметър указва стъпка - по подразбиране е 0.02, вторият отклонение - по подразбиране в 0.2

//+------------------------------------------------------------------+
//| Дефиниции на някои общи променливи                               |
//+------------------------------------------------------------------+
int     arrPositions[100];      //Масив с текущо отворените позиции
int     PositionCount=0;        //Брой поръчки
int     PositionType=-1;        //Дали сме в позиция, -1 - не сме, 0 - OP_BUY, 1 - OP_SELL
double  TradeProfit=0;          //Какво е спечелено/загубено от стратегията
double  TradeStartBalance=0;    //С каква сума сме започнали
int     LastTradeTime=0;        //Тук си пазим часа на последен вход или часа на затваряне на позицията. Идеята е ако искаме да изчакаме определено време.

//+------------------------------------------------------------------+
//| Функции откриващи,зкриващи и поддържащи позиции                  |
//+------------------------------------------------------------------+

// Изчислява мястото на стопа
double CalculateStopLoss(int TradeType, int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0)
  {double Result=0;
   int    cnt,br;
   double ff,dd,d1,d2;
   if(StopType==DEF_STOP_FIXED_PIPS)    //Изисква параметър указващ конкретни пипсове
     {
      if(TradeType==OP_BUY)
         Result=Ask-StopParam1*Point;
      else   
         Result=Bid+StopParam1*Point;
     }
   else
   if(StopType==DEF_STOP_FIXED_PRICE)   //Изискава параметър указващ конкретна цена за стопа
      Result=StopParam1;
   else
   if(StopType==DEF_STOP_ATR)           //Изискава параметър указващ броя използвани ATR, следващият е параметъра на самият ATR
     {
      if(StopParam1<=0)
         StopParam1=2;
      if(StopParam2<=0)
         StopParam2=55;
      if(TradeType==OP_BUY)
         Result=Ask-StopParam1*iATR(NULL,StopTimeFrame,StopParam2,IndicatorShift);
      else   
         Result=Bid+StopParam1*iATR(NULL,StopTimeFrame,StopParam2,IndicatorShift);
     }
   else
   if(StopType==DEF_STOP_LO_HI)           //Изискава параметър указващ броя барове които ще се проверят за най-малка/висока стойност
     {
      if(TradeType==OP_BUY)
         Result=MathMin(Ask-StopParam2*Point,MathMin(Ask-BreakEnter*Point,iLow(NULL,StopTimeFrame,Lowest(NULL,StopTimeFrame,MODE_LOW,StopParam1,IndicatorShift)))-BreakEnter*Point);
      else   
         Result=MathMax(Bid+StopParam2*Point,MathMax(Bid+BreakEnter*Point,iHigh(NULL,StopTimeFrame,Highest(NULL,StopTimeFrame,MODE_HIGH,StopParam1,IndicatorShift))+Ask-Bid)+BreakEnter*Point);
     }
   else
   if(StopType==DEF_STOP_FRACTAL)         //Първият параметър указва максимален размер на стопа в пипсове. Вторият параметър указва минимален размер на стопа в пипсове. Или с други думи стопа е между двата параметъра.
     {
      if(TradeType==OP_BUY)
        {//Търсим най-близък образуван фрактал под Bid
         Result=0;
         cnt=2;
         while(cnt<1000&&Result==0&&iLow(NULL,StopTimeFrame,cnt)>(Ask-StopParam1*Point))
           {
            cnt=cnt+1;
            ff=iFractals(NULL,StopTimeFrame,MODE_LOWER,cnt);
            if(ff>0&&ff<Bid)
              {
               Result=ff-BreakEnter*Point;
               break;
              }
           }
         if(Result==0)
            Result=Ask-StopParam1*Point;
         Result=MathMin(Result,Ask-StopParam2*Point);
        }
      else
        {//Търсим най-близък образуван фрактал над Ask
         Result=0;
         cnt=2;
         while(cnt<1000&&Result==0&&iHigh(NULL,StopTimeFrame,cnt)<(Bid+StopParam1*Point))
           {
            cnt=cnt+1;
            ff=iFractals(NULL,StopTimeFrame,MODE_UPPER,cnt);
            if(ff>0&&ff>Ask)
              {
               Result=ff+BreakEnter*Point;
               break;
              }
           }
         if(Result==0)
            Result=Bid+StopParam1*Point;
         Result=MathMax(Result,Bid+StopParam2*Point);
        }
     }
   else
   if(StopType==DEF_STOP_SAFEZONE)        //Първият параметър указва мултипликатора - по подразбиране е 2, вторият периода за изч.на отстоянието - по подразбиране в 20
     {
      if(StopParam1<=0)
         StopParam1=2;
      if(StopParam2<=0)
         StopParam2=20;
      br=0;
      dd=0;
      if(TradeType==OP_BUY)
        {
         for(cnt=IndicatorShift; cnt<=StopParam2; cnt++)
            {
             d1=iLow(NULL,StopTimeFrame,cnt);
             d2=iLow(NULL,StopTimeFrame,cnt+1);
             if(d1<d2)
               {
                dd=dd+d2-d1;
                br=br+1;
               }
            }
         d1=MathMin(iLow(NULL,StopTimeFrame,IndicatorShift),Bid);
         if(br>0)
            Result=d1-StopParam1*dd/br;
         else
            Result=d1;
        }
      else
        {
         for(cnt=IndicatorShift; cnt<=StopParam2; cnt++)
            {
             d1=iHigh(NULL,StopTimeFrame,cnt);
             d2=iHigh(NULL,StopTimeFrame,cnt+1);
             if(d1>d2)
               {
                dd=dd+d1-d2;
                br=br+1;
               }
            }
         d1=MathMax(iHigh(NULL,StopTimeFrame,IndicatorShift),Bid);
         if(br>0)
            Result=d1+StopParam1*dd/br+Ask-Bid;
         else
            Result=d1+Ask-Bid;
        }
     }
   else
   if(StopType==DEF_STOP_SAR)             //Първият параметър указва стъпка - по подразбиране е 0.02, вторият отклонение - по подразбиране в 0.2
     {
      if(StopParam1<=0)
         StopParam1=0.02;
      if(StopParam2<=0)
         StopParam2=0.2;
      dd=iSAR(NULL,StopTimeFrame,StopParam1,StopParam2,IndicatorShift);
      if(TradeType==OP_BUY && dd<Bid)
         Result=dd;
      else
      if(TradeType==OP_SELL && dd>Ask)
         Result=dd+Ask-Bid;
     }

   //Корекция на стопа спрямо лимитите на брокера
   if(Result>0)
     {
      Result=NormalizeDouble(Result/Point,0)*Point;
      if(TradeType==OP_BUY)
         Result=MathMin(Result+ExitExtend*Point,Bid-MinStopLoss*Point);
      else
      if(TradeType==OP_SELL)
         Result=MathMax(Result-ExitExtend*Point,Ask+MinStopLoss*Point);
     }    

   return(Result);
  }

// Отваря дълга позиция. При успех я отчита в масива с текущи позиции. Отрицателна стойност за TakeProfit инструктира за изчисление на съотношение Risk/Reward
bool OpenBuy(int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0, double TakeProfit=0, string Description="Open Buy", double MMCorect=1)
  {bool Result=false;
   double Lots=MathMin(MathCeil(1*MMCorect/MinLots)*MinLots,MaxLots);
   double StopLoss=0;
   int    NewOrder=0;
   //Изчисление на стоп
   StopLoss=CalculateStopLoss(OP_BUY,StopTimeFrame, StopType, StopParam1, StopParam2);
   //Изчисление на входа
   if(TradeMMType==1) //Процент на залагана сума
      Lots=MathMin(MathCeil(MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
   else
   if(TradeMMType==2) //Процент на рискувана сума. Тук не е съвсем чисто, ако сметката не е в USD или валутната двойка не е от вида xxx/USD
      if(StopLoss>0) 
         Lots=MathMin(MathCeil((100*Point/(Ask-StopLoss))*MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
      else //Ако играем без начален стоп риска е голям и избираме минималното количество лотове
         Lots=MinLots;
   //Ако сме инструктирани да определяме целта в зависимост от стопа
   if(TakeProfit>0)
      TakeProfit=Ask+Point*TakeProfit;
   else
   if(TakeProfit<0)
      if(StopLoss==0)
         TakeProfit=0;
      else 
         TakeProfit=Ask+(Ask-StopLoss)*TakeProfit*(-1);
   //Корекция на целта спрямо лимитите на брокера
   if(TakeProfit>0)
      TakeProfit=MathMax(TakeProfit+ExitExtend*Point,Ask+MinTakeProfit*Point);
   //Не разрешаваме засега насрещни сделки
   if(PositionType==-1 || PositionType==OP_BUY)
      NewOrder=OrderSend(Symbol(), OP_BUY, Lots, Ask, SlipPage, StopLoss, TakeProfit, Description, SystemMagicNumber,0,White);
   if(NewOrder>0)
     {
      PositionCount=PositionCount+1;
      arrPositions[PositionCount]=NewOrder;
      PositionType=OP_BUY;
      LastTradeTime=CurTime();
      Result=true;
      Print("*** ",Description," на цена ",Ask," ***");
     }
   else     
      Print("*** ERROR BUY *** ",Ask,",",StopLoss,",",TakeProfit," *** ",ErrorDescription(GetLastError()));
   return(Result);
  }

// Отваря къса позиция. При успех я отчита в масива с текущи позиции. Отрицателна стойност за TakeProfit инструктира за изчисление на съотношение Risk/Reward
bool OpenSell(int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0, double TakeProfit=0, string Description="Open Sell", double MMCorect=1)
  {bool Result=false;
   double Lots=MathMin(MathCeil(1*MMCorect/MinLots)*MinLots,MaxLots);
   double StopLoss=0;
   int    NewOrder;
   //Изчисление на стоп
   StopLoss=CalculateStopLoss(OP_SELL,StopTimeFrame, StopType, StopParam1, StopParam2);
   //Изчисление на входа
   if(TradeMMType==1) //Процент на залагана сума
      Lots=MathMin(MathCeil(MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
   else
   if(TradeMMType==2) //Процент на рискувана сума. Тук не е съвсем чисто, ако сметката не е в USD или валутната двойка не е от вида xxx/USD
      if(StopLoss>0) 
         Lots=MathMin(MathCeil((100*Point/(StopLoss-Bid))*MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
      else //Ако играем без начален стоп риска е голям и избираме минималното количество лотове
         Lots=MinLots;
   //Ако сме инструктирани да определяме целта в зависимост от стопа
   if(TakeProfit>0)
      TakeProfit=Bid-Point*TakeProfit;
   else
   if(TakeProfit<0)
      if(StopLoss==0)
         TakeProfit=0;
      else 
         TakeProfit=Bid-(StopLoss-Bid)*TakeProfit*(-1);
   //Корекция на целта спрямо лимитите на брокера
   if(TakeProfit>0)
      TakeProfit=MathMin(TakeProfit-ExitExtend*Point,Bid-MinTakeProfit*Point);
   //Не разрешаваме засега насрещни сделки
   if(PositionType==-1 || PositionType==OP_SELL)
      NewOrder=OrderSend(Symbol(),OP_SELL, Lots, Bid, SlipPage, StopLoss, TakeProfit, Description, SystemMagicNumber,0,Yellow);
   if(NewOrder>0)
     {
      PositionCount=PositionCount+1;
      arrPositions[PositionCount]=NewOrder;
      PositionType=OP_SELL;
      LastTradeTime=CurTime();
      Result=true;
      Print("*** ",Description," на цена ",Bid," ***");
     }
   else     
      Print("*** ERROR SELL *** ",Bid,",",StopLoss,",",TakeProfit," *** ",ErrorDescription(GetLastError()));
   return(Result);
  }

// Поддържа стоповете на позициите
void ProcessTrailingStops(int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0)
  {
   int    cnt=1;
   double StopLoss=0;
   for(cnt=1;cnt<=PositionCount;cnt++)
    if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_TRADES))
      {
       StopLoss=CalculateStopLoss(OrderType(),StopTimeFrame, StopType, StopParam1, StopParam2);
       if(OrderType()==OP_BUY && StopLoss>0 && StopLoss>OrderOpenPrice() && (OrderStopLoss()==0 || StopLoss>=(OrderStopLoss()+MathMax(MinStopMove,1)*Point)))
          OrderModify(OrderTicket(),OrderOpenPrice(),StopLoss,OrderTakeProfit(),Blue);
       else   
       if(OrderType()==OP_SELL && StopLoss>0 && StopLoss<OrderOpenPrice() && (OrderStopLoss()==0 || StopLoss<=(OrderStopLoss()-MathMax(MinStopMove,1)*Point)))
          OrderModify(OrderTicket(),OrderOpenPrice(),StopLoss,OrderTakeProfit(),Red);
      }   
  }


// Затваря всички позиции
void CloseAllPositions()
  {
   int cnt;
   for(cnt=1;cnt<=PositionCount;cnt++)
    if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_TRADES))
      if(OrderType()==OP_BUY)
         OrderClose(OrderTicket(),OrderLots(),Bid,SlipPage,White);
      else  
         OrderClose(OrderTicket(),OrderLots(),Ask,SlipPage,Yellow);
  }

// Проверява дали нямаме някоя вече затворена позиция
void CheckPositions()
  {
   int cnt=1;
   int i;
   while(cnt<=PositionCount)
     {
      if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_HISTORY))
         if(OrderCloseTime()>0) //За всеки случай, защото понякога си селектира позицията.
           {//Отчитаме резултата
            TradeProfit=TradeProfit+OrderProfit();
            if(OrderCloseTime()>LastTradeTime)
               LastTradeTime=OrderCloseTime();
            //Шифтваме в масива позициите наляво
            for(i=cnt;cnt<=PositionCount;cnt++)
                arrPositions[cnt]=arrPositions[cnt+1];
            //Уточитаме намаляването на броя позиции    
            PositionCount=PositionCount-1;
            cnt=cnt-1;
           }
      cnt=cnt+1;     
     }      
   if(PositionCount==0)
      PositionType=-1;
  } 

// Проверява дали е преместен стопа поне на нулата
bool AllPosIsProtected()
  {bool Result=true;
   int cnt;
   for(cnt=1;cnt<=PositionCount;cnt++)
    if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_TRADES))
      if(OrderType()==OP_BUY&&(OrderStopLoss()==0||OrderStopLoss()<OrderOpenPrice()))
         Result=false;
      else   
      if(OrderType()==OP_SELL&&(OrderStopLoss()==0||OrderStopLoss()>OrderOpenPrice()))
         Result=false;
   return(Result);
  }

// Проверява дали всички позиции са на плюс
bool AllPosIsProfitable()
  {bool Result=true;
   int cnt;
   for(cnt=1;cnt<=PositionCount;cnt++)
    if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_TRADES))
      if(OrderProfit()<=0)
         Result=false;
   return(Result);
  }

// Проверява дали стопа ще защити всички позиции
bool IsStopProtectedPos(double StopLoss)
  {bool Result=true;
   int cnt;
   for(cnt=1;cnt<=PositionCount;cnt++)
    if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_TRADES))
      if(OrderType()==OP_BUY && StopLoss<OrderOpenPrice())
         Result=false;
      else   
      if(OrderType()==OP_SELL && StopLoss>OrderOpenPrice())
         Result=false;
   return(Result);
  }

bool ResetAndInit(string EAName)
  {bool Result=true;
   int  cnt;
   //Инициализация на масива с позиции
   for(cnt=1;cnt<=100;cnt++)
       arrPositions[cnt]=0;
   //Търсим дали имаме текущо активни позиции
   PositionCount=0;
   PositionType=-1;
   for(cnt=OrdersTotal();cnt>=0;cnt--)
    if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==SystemMagicNumber && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         PositionCount=PositionCount+1;
         arrPositions[PositionCount]=OrderTicket();
         PositionType=OrderType();
        } 
   //Определяне на сумата с която разполагаме      
   if(TradeBalance<=0)
      TradeStartBalance=AccountBalance();
   else   
      TradeStartBalance=TradeBalance;
   TradeProfit=0;   
   LastTradeTime=0;
   //Гледаме в историята на сметката за да определим какво сме спечелили и кога е бил последният трейд.
   for(cnt=HistoryTotal();cnt>=0;cnt--)
     if(OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY))
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==SystemMagicNumber && (OrderType()==OP_BUY || OrderType()==OP_SELL))
         if(OrderOpenTime()>=DateBalance)
           {//Ако работим със заделена сума я актуализираме от историята
            if(TradeBalance>0)
               TradeProfit=TradeProfit+OrderProfit();
            //Отчитаме времето и на последната сделка
            if(OrderCloseTime()>LastTradeTime)
               LastTradeTime=OrderCloseTime();
           }
   Print("*** ",EAName,"(",SystemMagicNumber,") is started *** NewTradeBalance: ",TradeStartBalance+TradeProfit,", Positions: ",PositionCount,", Symbol: ",Symbol());
   return(Result);
  }