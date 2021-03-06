/* 
������������ �� ������� � ��������������� experts\include �� ������������ MT4.
����� ������� ��������� ������������ ������ �� ������� ��� ������ �� ���������� �� ���������� ��������� � �������� ���:

#define DEF_SMN  500    //�������� �� �� �������� �� ������������ �� ���������� SystemMagicNumber
#define DEF_BE   1      //�������� �� �� �������� �� ������������ �� ���������� BreakEnter
#define DEF_EE   1      //�������� �� �� �������� �� ������������ �� ���������� ExitExtend

#include <vgclib.mqh>

*/

//���� ���������
extern double    TradeMM           = 2;             //������ �� ���������� ��� ��������� ���� � ���������� �� ���� ��.
extern int       TradeMMType       = 0;             //��� 0 - ������ �� ���� ���, 1 - ������� �� �������� ���� , 2 - ������� �� ��������� ����
extern double    TradeBalance      = 0;             //�������� ����. ��� ������� ���� �������� ������ ������� �� ��������.
extern datetime  DateBalance       = D'2006.1.1';   //���� � �������� ������. �������� �� ��� ������� �������������.
extern double    LimitBalance      = 0;             //������ ��� ����� ���� ���� ����� ���������� ���� �� �����.
extern int       BreakEnter        = DEF_BE;        //����� ����� ���/��� �������� ��� ����� ������ ���� � �����, ���������
extern int       ExitExtend        = DEF_EE;        //����� ����� �� �� ����� �� ������� ��� ����� - ������ �� ������ ��� ���� ������� �� ������� ��� �����, ������ �� ������� ���� �� ���������
extern int       SystemMagicNumber = DEF_SMN;       //�������� �����, ����� ����� �������� �� �������� �� ��������� �� ��������� ������� �� ����������� ������������
extern int       MinStopMove       = 1;             //���� ����� ���-����� ����� �� ����� �����
extern int       IndicatorShift    = 1;             //������������ �� ������� �� ���� ����������. �������� ���� �� � ����� ���� ��� ���-�������, � � ����� ������ � ��� ������ ������.
extern int       SlipPage          = 1;             //����� ���������� ����������� �� ������� ��� ���� � �������.
extern double    MinLots           = 0.1;           //����� � ���-������� ������� ��� �������.
extern double    MaxLots           = 100;           //����� � ���-�������� ������� ��� �������.
extern int       MinStopLoss       = 8;             //����� � ���-������� ���� ��� �������.
extern int       MinTakeProfit     = 8;             //����� � ���-������� ��� ��� �������.

#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| ��������� �������� ���� ���� ����� �� �� ��������/��������       |
//+------------------------------------------------------------------+
#define DEF_STOP_FIXED_PIPS  1  //�������� ��������� ������� ��������� �������
#define DEF_STOP_FIXED_PRICE 2  //�������� ��������� ������� ��������� ���� �� �����
#define DEF_STOP_ATR         3  //�������� ��������� ������� ���� ���������� ATR, ���������� � ���������� �� ������ ATR
#define DEF_STOP_LO_HI       4  //�������� ��������� ������� ���� ������ ����� �� �� �������� �� ���-�����/������ ��������. ������� ��������� ������ ��������� ������ �� ����� � �������.
#define DEF_STOP_FRACTAL     5  //������� ��������� ������ ���������� ������ �� ����� � �������. ������� ��������� ������ ��������� ������ �� ����� � �������. ��� � ����� ���� ����� � ����� ����� ����������.
#define DEF_STOP_SAFEZONE    6  //�� ����������� ���� �� �����. ������� ��������� ������ �������������� - �� ������������ � 2, ������� ������� �� ���.�� ����������� - �� ������������ � 20
#define DEF_STOP_SAR         7  //�� parabolic SAR. ������� ��������� ������ ������ - �� ������������ � 0.02, ������� ���������� - �� ������������ � 0.2

//+------------------------------------------------------------------+
//| ��������� �� ����� ���� ����������                               |
//+------------------------------------------------------------------+
int     arrPositions[100];      //����� � ������ ���������� �������
int     PositionCount=0;        //���� �������
int     PositionType=-1;        //���� ��� � �������, -1 - �� ���, 0 - OP_BUY, 1 - OP_SELL
double  TradeProfit=0;          //����� � ���������/�������� �� �����������
double  TradeStartBalance=0;    //� ����� ���� ��� ���������
int     LastTradeTime=0;        //��� �� ����� ���� �� �������� ���� ��� ���� �� ��������� �� ���������. ������ � ��� ������ �� �������� ���������� �����.

//+------------------------------------------------------------------+
//| ������� ���������,�������� � ���������� �������                  |
//+------------------------------------------------------------------+

// ��������� ������� �� �����
double CalculateStopLoss(int TradeType, int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0)
  {double Result=0;
   int    cnt,br;
   double ff,dd,d1,d2;
   if(StopType==DEF_STOP_FIXED_PIPS)    //������� ��������� ������� ��������� �������
     {
      if(TradeType==OP_BUY)
         Result=Ask-StopParam1*Point;
      else   
         Result=Bid+StopParam1*Point;
     }
   else
   if(StopType==DEF_STOP_FIXED_PRICE)   //�������� ��������� ������� ��������� ���� �� �����
      Result=StopParam1;
   else
   if(StopType==DEF_STOP_ATR)           //�������� ��������� ������� ���� ���������� ATR, ���������� � ���������� �� ������ ATR
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
   if(StopType==DEF_STOP_LO_HI)           //�������� ��������� ������� ���� ������ ����� �� �� �������� �� ���-�����/������ ��������
     {
      if(TradeType==OP_BUY)
         Result=MathMin(Ask-StopParam2*Point,MathMin(Ask-BreakEnter*Point,iLow(NULL,StopTimeFrame,Lowest(NULL,StopTimeFrame,MODE_LOW,StopParam1,IndicatorShift)))-BreakEnter*Point);
      else   
         Result=MathMax(Bid+StopParam2*Point,MathMax(Bid+BreakEnter*Point,iHigh(NULL,StopTimeFrame,Highest(NULL,StopTimeFrame,MODE_HIGH,StopParam1,IndicatorShift))+Ask-Bid)+BreakEnter*Point);
     }
   else
   if(StopType==DEF_STOP_FRACTAL)         //������� ��������� ������ ���������� ������ �� ����� � �������. ������� ��������� ������ ��������� ������ �� ����� � �������. ��� � ����� ���� ����� � ����� ����� ����������.
     {
      if(TradeType==OP_BUY)
        {//������ ���-������ ��������� ������� ��� Bid
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
        {//������ ���-������ ��������� ������� ��� Ask
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
   if(StopType==DEF_STOP_SAFEZONE)        //������� ��������� ������ �������������� - �� ������������ � 2, ������� ������� �� ���.�� ����������� - �� ������������ � 20
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
   if(StopType==DEF_STOP_SAR)             //������� ��������� ������ ������ - �� ������������ � 0.02, ������� ���������� - �� ������������ � 0.2
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

   //�������� �� ����� ������ �������� �� �������
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

// ������ ����� �������. ��� ����� � ������ � ������ � ������ �������. ����������� �������� �� TakeProfit ����������� �� ���������� �� ����������� Risk/Reward
bool OpenBuy(int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0, double TakeProfit=0, string Description="Open Buy", double MMCorect=1)
  {bool Result=false;
   double Lots=MathMin(MathCeil(1*MMCorect/MinLots)*MinLots,MaxLots);
   double StopLoss=0;
   int    NewOrder=0;
   //���������� �� ����
   StopLoss=CalculateStopLoss(OP_BUY,StopTimeFrame, StopType, StopParam1, StopParam2);
   //���������� �� �����
   if(TradeMMType==1) //������� �� �������� ����
      Lots=MathMin(MathCeil(MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
   else
   if(TradeMMType==2) //������� �� ��������� ����. ��� �� � ������ �����, ��� �������� �� � � USD ��� ��������� ������ �� � �� ���� xxx/USD
      if(StopLoss>0) 
         Lots=MathMin(MathCeil((100*Point/(Ask-StopLoss))*MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
      else //��� ������ ��� ������� ���� ����� � ����� � �������� ����������� ���������� ������
         Lots=MinLots;
   //��� ��� ������������� �� ���������� ����� � ���������� �� �����
   if(TakeProfit>0)
      TakeProfit=Ask+Point*TakeProfit;
   else
   if(TakeProfit<0)
      if(StopLoss==0)
         TakeProfit=0;
      else 
         TakeProfit=Ask+(Ask-StopLoss)*TakeProfit*(-1);
   //�������� �� ����� ������ �������� �� �������
   if(TakeProfit>0)
      TakeProfit=MathMax(TakeProfit+ExitExtend*Point,Ask+MinTakeProfit*Point);
   //�� ����������� ������ �������� ������
   if(PositionType==-1 || PositionType==OP_BUY)
      NewOrder=OrderSend(Symbol(), OP_BUY, Lots, Ask, SlipPage, StopLoss, TakeProfit, Description, SystemMagicNumber,0,White);
   if(NewOrder>0)
     {
      PositionCount=PositionCount+1;
      arrPositions[PositionCount]=NewOrder;
      PositionType=OP_BUY;
      LastTradeTime=CurTime();
      Result=true;
      Print("*** ",Description," �� ���� ",Ask," ***");
     }
   else     
      Print("*** ERROR BUY *** ",Ask,",",StopLoss,",",TakeProfit," *** ",ErrorDescription(GetLastError()));
   return(Result);
  }

// ������ ���� �������. ��� ����� � ������ � ������ � ������ �������. ����������� �������� �� TakeProfit ����������� �� ���������� �� ����������� Risk/Reward
bool OpenSell(int StopTimeFrame, int StopType, double StopParam1, double StopParam2=0, double TakeProfit=0, string Description="Open Sell", double MMCorect=1)
  {bool Result=false;
   double Lots=MathMin(MathCeil(1*MMCorect/MinLots)*MinLots,MaxLots);
   double StopLoss=0;
   int    NewOrder;
   //���������� �� ����
   StopLoss=CalculateStopLoss(OP_SELL,StopTimeFrame, StopType, StopParam1, StopParam2);
   //���������� �� �����
   if(TradeMMType==1) //������� �� �������� ����
      Lots=MathMin(MathCeil(MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
   else
   if(TradeMMType==2) //������� �� ��������� ����. ��� �� � ������ �����, ��� �������� �� � � USD ��� ��������� ������ �� � �� ���� xxx/USD
      if(StopLoss>0) 
         Lots=MathMin(MathCeil((100*Point/(StopLoss-Bid))*MMCorect*TradeMM/100*(TradeStartBalance+TradeProfit)/MinLots/1000)*MinLots,MaxLots);
      else //��� ������ ��� ������� ���� ����� � ����� � �������� ����������� ���������� ������
         Lots=MinLots;
   //��� ��� ������������� �� ���������� ����� � ���������� �� �����
   if(TakeProfit>0)
      TakeProfit=Bid-Point*TakeProfit;
   else
   if(TakeProfit<0)
      if(StopLoss==0)
         TakeProfit=0;
      else 
         TakeProfit=Bid-(StopLoss-Bid)*TakeProfit*(-1);
   //�������� �� ����� ������ �������� �� �������
   if(TakeProfit>0)
      TakeProfit=MathMin(TakeProfit-ExitExtend*Point,Bid-MinTakeProfit*Point);
   //�� ����������� ������ �������� ������
   if(PositionType==-1 || PositionType==OP_SELL)
      NewOrder=OrderSend(Symbol(),OP_SELL, Lots, Bid, SlipPage, StopLoss, TakeProfit, Description, SystemMagicNumber,0,Yellow);
   if(NewOrder>0)
     {
      PositionCount=PositionCount+1;
      arrPositions[PositionCount]=NewOrder;
      PositionType=OP_SELL;
      LastTradeTime=CurTime();
      Result=true;
      Print("*** ",Description," �� ���� ",Bid," ***");
     }
   else     
      Print("*** ERROR SELL *** ",Bid,",",StopLoss,",",TakeProfit," *** ",ErrorDescription(GetLastError()));
   return(Result);
  }

// �������� ��������� �� ���������
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


// ������� ������ �������
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

// ��������� ���� ������ ����� ���� ��������� �������
void CheckPositions()
  {
   int cnt=1;
   int i;
   while(cnt<=PositionCount)
     {
      if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_HISTORY))
         if(OrderCloseTime()>0) //�� ����� ������, ������ �������� �� ��������� ���������.
           {//�������� ���������
            TradeProfit=TradeProfit+OrderProfit();
            if(OrderCloseTime()>LastTradeTime)
               LastTradeTime=OrderCloseTime();
            //�������� � ������ ��������� ������
            for(i=cnt;cnt<=PositionCount;cnt++)
                arrPositions[cnt]=arrPositions[cnt+1];
            //��������� ������������ �� ���� �������    
            PositionCount=PositionCount-1;
            cnt=cnt-1;
           }
      cnt=cnt+1;     
     }      
   if(PositionCount==0)
      PositionType=-1;
  } 

// ��������� ���� � ��������� ����� ���� �� ������
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

// ��������� ���� ������ ������� �� �� ����
bool AllPosIsProfitable()
  {bool Result=true;
   int cnt;
   for(cnt=1;cnt<=PositionCount;cnt++)
    if(OrderSelect(arrPositions[cnt], SELECT_BY_TICKET, MODE_TRADES))
      if(OrderProfit()<=0)
         Result=false;
   return(Result);
  }

// ��������� ���� ����� �� ������ ������ �������
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
   //������������� �� ������ � �������
   for(cnt=1;cnt<=100;cnt++)
       arrPositions[cnt]=0;
   //������ ���� ����� ������ ������� �������
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
   //���������� �� ������ � ����� �����������      
   if(TradeBalance<=0)
      TradeStartBalance=AccountBalance();
   else   
      TradeStartBalance=TradeBalance;
   TradeProfit=0;   
   LastTradeTime=0;
   //������� � ��������� �� �������� �� �� ��������� ����� ��� ��������� � ���� � ��� ���������� �����.
   for(cnt=HistoryTotal();cnt>=0;cnt--)
     if(OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY))
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==SystemMagicNumber && (OrderType()==OP_BUY || OrderType()==OP_SELL))
         if(OrderOpenTime()>=DateBalance)
           {//��� ������� ��� �������� ���� � ������������� �� ���������
            if(TradeBalance>0)
               TradeProfit=TradeProfit+OrderProfit();
            //�������� ������� � �� ���������� ������
            if(OrderCloseTime()>LastTradeTime)
               LastTradeTime=OrderCloseTime();
           }
   Print("*** ",EAName,"(",SystemMagicNumber,") is started *** NewTradeBalance: ",TradeStartBalance+TradeProfit,", Positions: ",PositionCount,", Symbol: ",Symbol());
   return(Result);
  }