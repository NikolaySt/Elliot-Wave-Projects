/*-------------------------------------------------------------------------------
   ������ 
      1. �� ����� (������) (arr_ml_bars)
      2. ��������� � ������ �� �� (arr_ml_peaks)
--------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
//arr_ml_bars
[][0] high, 
[][1] low, 
[][2] time, 
[][3] ����������� - ������: 1, ������:-1;, 
[][4] - ��� ������� ��� � � ������������� /�����/
[][5] - ������� ���� �� ���� � �������� ��� ��� ��� �� ������� 1-��������, 0 - � ������� �� �������

//arr_ml_peaks
[][0] ����/���� - ��������, 
[][1] ����� ���� � ����� � ��������, 
[][2] ���- ����: 1, ����:-1;, 
[][3] ���� ������ � ������������� - vreme;
[][4] ������� ���� ����� � �������� � � ������� ��� ��� ��� �� ������� 1-��������, 0 - � ������� �� �������
------------------------------------------------------------------------------*/
double arr_ml_bars[20][6]; int index_ml_bars = 0;
double arr_ml_peaks[20][5]; int index_ml_peaks = 0;
void InitArraysParams(){
   index_ml_bars = 0; ArrayInitialize(arr_ml_bars, 0);
   index_ml_peaks = 0; ArrayInitialize(arr_ml_peaks, 0);         
}

void ArrayResizeInternal_2D(double&array[][], int index, int inc = 20){
   // ��� ������ e ��������� ������ �� ������ �� ������ �� ��������� � ��� 20 ��������
   int dim = ArrayRange(array, 1);
   if (index*dim >= ArraySize(array)) ArrayResize(array, index*dim + inc*dim);              
}

/*--------------------------------------------------------------------------------------

      ������� �� ������ � ����� �� ������ /arr_ml_bars/

---------------------------------------------------------------------------------------*/


int MLSetBar(double high, double low, datetime time, int direction, double count, int forming){   
   arr_ml_bars[index_ml_bars][0] = high;
   arr_ml_bars[index_ml_bars][1] = low;
   arr_ml_bars[index_ml_bars][2] = time;
   arr_ml_bars[index_ml_bars][3] = direction;           
   arr_ml_bars[index_ml_bars][4] = count;
   arr_ml_bars[index_ml_bars][5] = forming;
   index_ml_bars++;
   
   ArrayResizeInternal_2D(arr_ml_bars, index_ml_bars);
   //����� ������� �� ��������� �������;     
   return(index_ml_bars-1);   
}

void MLGetBar(int index, double& high, double& low, datetime& time, int& direction){   
   high = arr_ml_bars[index][0];
   low = arr_ml_bars[index][1];
   time = arr_ml_bars[index][2];
   direction = arr_ml_bars[index][3]; 
}

bool MLGetLastBar(double& high, double& low, datetime& time, int& direction){     
   int index = index_ml_bars - 1;
   if (index >= 0){
      high = arr_ml_bars[index][0];
      low = arr_ml_bars[index][1];
      time = arr_ml_bars[index][2];
      direction = arr_ml_bars[index][3]; 
      return(true);
   }
   return(false);   
}

datetime MLGetTimeLastBar(){     
   int index = index_ml_bars - 1;
   if (index >= 0){
      return(arr_ml_bars[index][2]);
   }
   return(-1);   
}
int MLGetTypeLastBar(){
   int index = index_ml_bars - 1;
   if (index >= 0){
      return(arr_ml_bars[index][3]);
   }
   return(-1);   
}

int MLLastBarIndex(){ 
   if (index_ml_bars > 0){
      return(index_ml_bars - 1);
   }else{
      return(0);
   }      
}

int MLLastFormBarIndex(){ 
   //����� ��������� �������� ���������
   int index = index_ml_bars-1;     
   while (arr_ml_bars[index][5] != 1 && index >= 0){      
      index--;
   }
   return(index);    
}

double MLBarHigh(int index){return(arr_ml_bars[index][0]);}
double MLBarLow(int index){return(arr_ml_bars[index][1]);}
int MLBarType(int index){return(arr_ml_bars[index][3]);}
double MLBarTimeCount(int index){return(arr_ml_bars[index][4]);}
int MLBarForming(int index){return(arr_ml_bars[index][5]);}
void MLSetBarForming(int index, int forming){ arr_ml_bars[index][5] = forming;}

double MLGetLastPoint(){
   int index = MLLastBarIndex();
   if (MLBarType(index) == 1) return(MLBarHigh(index));
   if (MLBarType(index) == -1) return(MLBarLow(index));
   return(0);
}

double MLGetCountLastBar(){
   int index = index_ml_bars - 1;
   if (index >= 0) return(arr_ml_bars[index][4]); else return(0);   
}


double MLGetLastCountTime_Type(int type){
   int index = MLLastBarIndex();
   if (index >= 0){
      if (type == arr_ml_bars[index][3]){
         return(arr_ml_bars[index][4]);
      }else{
         return(0);         
      }
   }
   return(0);  
}

int MLGetLowestHigh(int count, int begin){
//������ Motion ���� � ���-������ ����   
   double level = MLBarHigh(begin); 
   int result = begin; 
   int i = begin - 1;       
   while (i >= begin-count){
      
      if (MLBarHigh(i) < level){
         result = i;    
         level = MLBarHigh(i);
      }
      i--;     
   }      
   return(result);
}

int MLGetHighestLow(int count, int begin){   
//������ Motion ���� � ���-������ ����   
   double level = MLBarLow(begin);    
   int result = begin; 
   
   int i = begin-1;       
   while (i >= begin-count){   
      if (MLBarLow(i) > level){
         result = i;    
         level = MLBarLow(i);
      }
      i--;     
   }      
   
   return(result);
}

int MLGetLowestLow(int count, int begin){   
   //������ Motion ���� � ���-����� ����
   double level = MLBarLow(begin); 
   int result = begin; 
   int i = begin-1;       
   while (i >= begin-count){
          
      if (MLBarLow(i) < level){
         result = i;    
         level = MLBarLow(i);
      }
      i--; 
   }      
   return(result);
}

int MLGetHighestHigh(int count, int begin){
   //������ Motion ���� � ���-������ ����          
   double level = MLBarHigh(begin); 
   int result = begin; 
   int i = begin - 1;
   while (i >= begin-count){         
      if (MLBarHigh(i) > level){
         result = i;    
         level = MLBarHigh(i);
      }
      i--;  
   }      
   return(result);
}


/*--------------------------------------------------------------------------------------

      ������� �� ������ � ����� ������� /arr_ml_peaks/

---------------------------------------------------------------------------------------*/
int MLSetPeak(double value, datetime time, int type_peak, double count, int forming){   
   arr_ml_peaks[index_ml_peaks][0] = value;
   arr_ml_peaks[index_ml_peaks][1] = time;
   arr_ml_peaks[index_ml_peaks][2] = type_peak;  //"+1" - ����, "-1" - ����
   arr_ml_peaks[index_ml_peaks][3] = count;
   arr_ml_peaks[index_ml_peaks][4] = forming;
   index_ml_peaks++;   
   ArrayResizeInternal_2D(arr_ml_peaks, index_ml_peaks);
   return(index_ml_peaks - 1);   //����� ������� �� ��������� �������;
}


void MLGetPeak(int index, double& value, datetime& time, int& type_peak, double& count){   
   value = arr_ml_peaks[index][0];
   time = arr_ml_peaks[index][1];
   type_peak = arr_ml_peaks[index][2]; //"+1" - ����, "-1" - ����
   count = arr_ml_peaks[index][3];
}



bool MLGetLastPeak(double& value, datetime& time, int& type_peak, double& count){   
   int index = index_ml_peaks - 1;
   if (index >= 0){
      value = arr_ml_peaks[index][0];
      time = arr_ml_peaks[index][1];
      type_peak = arr_ml_peaks[index][2];
      count = arr_ml_peaks[index][3];
      return(true);
   }
   return(false);
}

double MLGetLastPeakCount(){   
   int index = index_ml_peaks - 1;
   if (index >= 0){
      return(arr_ml_peaks[index][3]);
   }
   return(0);
}

bool MLGetLastFormPeakType(int type_peak, double& value, datetime& time, double& count){   
   //����� ��������� ��������� ������ ��������� ���
   int index = index_ml_peaks-1;
   bool chfind = false;       
   
   while (!chfind && index >= 0){
      value = arr_ml_peaks[index][0];
      time = arr_ml_peaks[index][1];
      count = arr_ml_peaks[index][3];      
          
      if (type_peak == arr_ml_peaks[index][2] && arr_ml_peaks[index][4] == 1){   
            return(true);
      }else{       
         index--;
      }   
   }
   return(false);
}

int MLLastPeakIndex(){  if (index_ml_peaks > 0)  return(index_ml_peaks - 1); else return(0); }

int MLLastFormPeakIndex(){ 
   //����� ��������� ��������� ������ ��������� ���
   int index = index_ml_peaks-1;     
   while (arr_ml_peaks[index][4] != 1 && index >= 0){
      index--;
   }
   return(index);
   
}