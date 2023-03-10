//+------------------------------------------------------------------+
//|                                      Calculate_Average_Price.mq4 |
//|                                                     Michal Herda |
//|                                                                  |
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////       CALCULATE AVERAGE        ////////////////////
/////////////////            PRICE              ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
#property copyright "Michal Herda"
#property link      "mql4.com"
#property version   "1.00"
#property strict
/////////////////////////////////////////////////////////////////////
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\ListView.mqh>
#include <Controls\Label.mqh>
#include <Controls\Edit.mqh>
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASS             ////////////////////
/////////////////           DEFINES              ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//indent and gaps
#define INDENT_TOP                                     (10)
#define INDENT_LEFT                                    (12)
//for Button
#define BUTTON_HEIGHT                                  (30)
#define BUTTON_WIDTH                                   (75)
//for Label
#define LABEL_HEIGHT                                   (30)
#define LABEL_WIDTH                                    (35)
//for Edit1
#define EDIT_HEIGHT                                    (30)
#define EDIT_WIDTH                                     (100)
//for Label 3 and 4
#define LABEL3_HEIGHT                                  (30)
#define LABEL3_WIDTH                                   (25)
//for Edit2
#define EDIT2_HEIGHT                                   (30)
#define EDIT2_WIDTH                                    (75)
//for Edit3 i 4 Tekst
#define OBJPROP_TEXT_BUY                               ("0")
#define OBJPROP_TEXT_SELL                              ("0")
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASSES           ////////////////////
/////////////////          DEFINITION            ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////        CMainMenu CLASS         ////////////////////
/////////////////           DEFINITION           ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
class CMainMenu : public CAppDialog {

public:
      CLabel                    m_label1 ;
      CLabel                    m_label2 ;  
      CButton                   m_button1 ;
      CButton                   m_button2 ;
      CEdit                     m_edit1 ;
      CEdit                     m_edit2 ;
      CLabel                    m_label3 ;
      CLabel                    m_label4 ;
      CEdit                     m_edit3 ;
      CEdit                     m_edit4 ;
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                CMainMenu(void);
                               ~CMainMenu(void);
   //--- create
   virtual bool                 Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //--- chart event handler
   virtual bool                 OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //--- create dependent controls
   bool                         CreateLabel1(void);
   bool                         CreateLabel2(void);
   bool                         CreateButton1(void);
   bool                         CreateButton2(void);
   bool                         CreateEdit1(void);
   bool                         CreateEdit2(void);
   bool                         CreateLabel3(void);
   bool                         CreateLabel4(void);
   bool                         CreateEdit3(void);
   bool                         CreateEdit4(void);
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////
   void                         OnClickButton1(void);
   void                         OnClickButton2(void);
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////
   void                         OnChangeEdit3(void);
};
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            EVENT                 //////////////////
/////////////////           HANDLING               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
EVENT_MAP_BEGIN(CMainMenu)
/////////////////////////////////////////////////////////////////////
ON_EVENT(ON_CLICK,m_button1,OnClickButton1)
ON_EVENT(ON_CLICK,m_button2,OnClickButton2)
/////////////////////////////////////////////////////////////////////
ON_EVENT(ON_CHANGE,m_edit3,OnChangeEdit3)
/////////////////////////////////////////////////////////////////////
EVENT_MAP_END(CAppDialog)
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        CONSTRUCTOR               //////////////////
/////////////////        DESTRUCTOR                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMainMenu::CMainMenu(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMainMenu::~CMainMenu(void)
  {
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CMainMenu::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2){
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateLabel1())
      return(false);
   if(!CreateLabel2())
      return(false);
   if(!CreateButton1())
      return(false);
   if(!CreateButton2())
      return(false);
   if(!CreateEdit1())
      return(false);
   if(!CreateEdit2())
      return(false);
   if(!CreateLabel3())
      return(false);
   if(!CreateLabel4())
      return(false);
   if(!CreateEdit3())
      return(false);
   if(!CreateEdit4())
      return(false);
//--- succeed  
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////       GLOBAL VARIABLES         ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double Average_Buy_Price ;
double Average_Sell_Price ;
double Minimal_Lot_Size_Buy = 1 ;
double Minimal_Lot_Size_Sell = 1 ;
extern int BreakEven_Buy_Plus  ;
extern int BreakEven_Sell_Plus ;
CMainMenu MainWindow ;
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////      
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//--- create application dialog
   if(!MainWindow.Create(0," AVERAGE_OPEN_PRICE_CALCULATE ",0,40,40,430,156))
      return(INIT_FAILED);
//--- run application
   MainWindow.Run();
//--- enable object create events
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,true);
//--- enable object delete events
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,true);
//--- succeed
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   Comment("");
//--- destroy dialog
   MainWindow.Destroy(reason);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   MainWindow.ChartEvent(id,lparam,dparam,sparam);
//////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit3" ) {
   string Value = ObjectGetString(0,"Edit3",OBJPROP_TEXT,0);
   BreakEven_Buy_Plus = StringToInteger(Value);
   Print("BreakEven_Buy_Plus = ", BreakEven_Buy_Plus);
  }
//////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit4" ) {
   string Value = ObjectGetString(0,"Edit4",OBJPROP_TEXT,0);
   //string Value = sparam;
   BreakEven_Sell_Plus = StringToInteger(Value);
   Print("BreakEven_Sell_Plus = ", BreakEven_Sell_Plus);
  }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            LABEL 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel1(void) {
//--- coordinates
   int x1 = INDENT_LEFT ;
   int y1 = INDENT_TOP ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = INDENT_TOP + LABEL_HEIGHT ;
//--- create
   if(!m_label1.Create(m_chart_id,"Label1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label1.Text("Av.Buy"))
      return(false) ;
   if(!Add(m_label1))
      return(false) ;
//--- succeed
   return(true) ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            LABEL 2               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel2(void)
  {
//--- coordinates
   int x1 = INDENT_LEFT ;
   int y1 = ( 2 * INDENT_TOP ) + LABEL_HEIGHT  ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = ( 2 * INDENT_TOP ) + ( 2 * BUTTON_HEIGHT ) ;
//--- create
   if(!m_label2.Create(m_chart_id,"Label2",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label2.Text("Av.Sell"))
      return(false) ;
   if(!Add(m_label2))
      return(false) ;
//--- succeed
   return(true) ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 1                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit1(void) {
//--- coordinates
   double x1 = ( 2 * INDENT_LEFT ) + LABEL_WIDTH ;
   double y1 = INDENT_TOP ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2 =  y1 + EDIT_HEIGHT ;
/////////////////////////////////////////////////////////////////////
   double Average_Buy_Price = CalculateAverageBuyPrice () ;
//--- create
   if(!m_edit1.Create(m_chart_id,"Edit1",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit1.Text(DoubleToString(Average_Buy_Price, Digits)))
      return(false);
   if(!m_edit1.ReadOnly(true))
      return(false);
   if(!Add(m_edit1))
      return(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 2                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit2(void) {
//--- coordinates
   double x1 = ( 2 * INDENT_LEFT ) + LABEL_WIDTH;
   double y1 = ( 2 * INDENT_TOP ) +  EDIT_HEIGHT ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2=  y1 + EDIT_HEIGHT;
//////////////////////////////////////////////////////////////////////
   double Average_Sell_Price = CalculateAverageSellPrice () ;
//--- create
   if(!m_edit2.Create(m_chart_id,"Edit2",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit2.Text(DoubleToString(Average_Sell_Price, Digits)))
      return(false);
   if(!m_edit2.ReadOnly(true))
      return(false);  
   if(!Add(m_edit2))
      return(false);   
//--- succeed
   return(true);
}
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton1(void) {
///--- coordinates
   int x1 = ( 3 * INDENT_LEFT ) + LABEL_WIDTH + EDIT_WIDTH ;
   int y1 = INDENT_TOP ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;
//--- create
   if(!m_button1.Create(m_chart_id,"Button1",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button1.Text("Set BE"))
      return(false);
   if(!Add(m_button1))
      return(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 2               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton2(void){
///--- coordinates
   int x1 = ( 3 * INDENT_LEFT ) + EDIT_WIDTH + LABEL_WIDTH;
   int y1 = ( 2 * INDENT_TOP ) + BUTTON_HEIGHT ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;
//--- create
   if(!m_button2.Create(m_chart_id,"Button2",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button2.Text("Set BE"))
      return(false);
   if(!Add(m_button2))
      return(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            LABEL 3               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel3(void) {
//--- coordinates
   int x1 = ( 4 * INDENT_LEFT ) + LABEL_WIDTH + BUTTON_WIDTH + EDIT_WIDTH ;
   int y1 = INDENT_TOP ;
   int x2 = x1 + LABEL3_WIDTH ;
   int y2 = INDENT_TOP + LABEL3_HEIGHT ;
//--- create
   if(!m_label3.Create(m_chart_id,"Label3",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label3.Text("Plus"))
      return(false) ;
   if(!Add(m_label3))
      return(false) ;
//--- succeed
   return(true) ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            LABEL 4               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel4(void) {
//--- coordinates
   int x1 = ( 4 * INDENT_LEFT ) + LABEL_WIDTH + BUTTON_WIDTH + EDIT_WIDTH ;
   int y1 = ( 2 * INDENT_TOP ) + LABEL_HEIGHT ;
   int x2 = x1 + LABEL3_WIDTH ;
   int y2 = INDENT_TOP + LABEL3_HEIGHT ;
//--- create
   if(!m_label4.Create(m_chart_id,"Label4",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label4.Text("Plus"))
      return(false) ;
   if(!Add(m_label4))
      return(false) ;
//--- succeed
   return(true) ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 3                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit3(void){
//--- coordinates
   double x1 = ( 5 * INDENT_LEFT ) + LABEL_WIDTH + BUTTON_WIDTH + EDIT_WIDTH + LABEL3_WIDTH ;
   double y1 = INDENT_TOP ;
   double x2 = x1 + EDIT2_WIDTH;
   double y2=  y1 + EDIT2_HEIGHT;
//--- create
   if(!m_edit3.Create(m_chart_id,"Edit3",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit3.ReadOnly(false))
      return(true);  
   if(!Add(m_edit3))
      return(false);    
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 4                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit4(void) {
//--- coordinates
   double x1 = ( 5 * INDENT_LEFT ) + LABEL_WIDTH + BUTTON_WIDTH + EDIT_WIDTH + LABEL3_WIDTH ; ;
   double y1 = ( 2 * INDENT_TOP) + EDIT_HEIGHT ;
   double x2 = x1 + EDIT2_WIDTH ;
   double y2=  y1 + EDIT2_HEIGHT;
//--- create
   if(!m_edit4.Create(m_chart_id,"Edit4",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit4.ReadOnly(false))
      return(true);  
   if(!Add(m_edit4))
      return(false);   
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 1              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnClickButton1(void) {   
   if ( IsTradeAllowed ( Symbol(), TimeCurrent () ) == false ) { Print("Trade Is Not Allowed") ; }
      else {
            Print("Trade Is Allowed");
            SetBreakEvenForBuy();
      }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CHANGE             //////////////////
/////////////////             EDIT 3               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnChangeEdit3(void) {
   
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////         SET BREAKEVEN            //////////////////
/////////////////            FOR BUY               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void SetBreakEvenForBuy () {
    double NewStopLossBuy = CalculateAverageBuyPrice () ;  
    Print("New SL is", CalculateAverageBuyPrice () );
    for(int i = OrdersTotal()-1; i >= 0; i--) {
      if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_BUY ) ) {   
           if((OrderModify (OrderTicket(), OrderOpenPrice(), NewStopLossBuy, OrderTakeProfit(), 0, clrNONE))==true)
                                    Print("Modification SL: ",OrderTicket()," completed.");
                                 else
                                    Print("Modification failed ",OrderTicket());
           }
      }   
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 2              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnClickButton2(void) {
   double NewStopLossSell = CalculateAverageSellPrice () ;  
    if ( IsTradeAllowed ( Symbol(), TimeCurrent () ) == false ) { Print("Trade Is Not Allowed") ; }
      else {
      Print("Trade Is Allowed");
      SetBreakEvenForSell();
      }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////         SET BREAKEVEN            //////////////////
/////////////////            FOR SELL              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void SetBreakEvenForSell () {
    double NewStopLossSell = CalculateAverageSellPrice () ;  
    Print("New SL is", CalculateAverageSellPrice () );
    for(int i = OrdersTotal()-1; i >= 0; i--) {
      if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_SELL ) ) {   
        if((OrderModify (OrderTicket(), OrderOpenPrice(), NewStopLossSell, OrderTakeProfit(), 0, clrNONE))==true)

                              Print("Modification SL: ",OrderTicket()," completed.");
                              else
                              Print("Modification failed ",OrderTicket());
        }
    }   
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ORDERS                //////////////////
/////////////////           TOTAL BUY              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
int OrdersTotalBuy() {
   int TOTAL_BUY = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {
         if ( (OrderType() == OP_BUY) && (OrderSymbol() == Symbol () ) )
            TOTAL_BUY = TOTAL_BUY + 1;
         else
            TOTAL_BUY = TOTAL_BUY;
      }
      else
         GetLastError();
   }
   return TOTAL_BUY;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ORDERS                //////////////////
/////////////////          TOTAL SELL              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
int OrdersTotalSell() {
   int TOTAL_SELL = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {
         if ( (OrderType() == OP_SELL) && (OrderSymbol() == Symbol () ) )
            TOTAL_SELL= TOTAL_SELL + 1;
         else
            TOTAL_SELL = TOTAL_SELL+ 0;
      }
      else
         GetLastError();
     }
   return(TOTAL_SELL);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           BUY - MINIMAL          //////////////////
/////////////////        LOT SIZE SEARCHING        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double SearchForMinimalLotSizeBuy() {
      for(int i = OrdersTotal()-1; i >= 0; i--){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {   
            if( ( OrderType () == OP_BUY ) && ( OrderSymbol () == Symbol () ) && ( OrderLots () < Minimal_Lot_Size_Buy) ) { Minimal_Lot_Size_Buy = OrderLots () ; }
           else
            Minimal_Lot_Size_Buy = Minimal_Lot_Size_Buy ;
         } 
           else GetLastError() ;
      }
/////////////////////////////////////////////////////////////////////
      return Minimal_Lot_Size_Buy ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////          SELL - MINIMAL          //////////////////
/////////////////        LOT SIZE SEARCHING        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double SearchForMinimalLotSizeSell() {
      for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {   
         if( ( OrderType () == OP_SELL ) && ( OrderSymbol () == Symbol () ) && ( OrderLots () < Minimal_Lot_Size_Sell) ) { Minimal_Lot_Size_Sell = OrderLots () ; }
        else
         Minimal_Lot_Size_Sell = Minimal_Lot_Size_Sell ;
      } 
       else GetLastError() ;
     }
/////////////////////////////////////////////////////////////////////
      return Minimal_Lot_Size_Buy ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CALCULATE             //////////////////
/////////////////        AVERAGE BUY PRICE         //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double CalculateAverageBuyPrice() {
   double AveragePrice ;
   int TotalBuy = OrdersTotalBuy() ;
   double SumOfBuy = 0 ;
   double LotSize = OrderLots() ;
   double Minimal_Lot_Size_Buy = 1 ;
   double TotalLotSizeBuy = 0 ;
   int AverageMultiply ;
   Print("Number Of Total Buy is ",TotalBuy) ;
   Print("Sum Of Buy is ",SumOfBuy) ;
///////////////////////////////////////////////////////////////////// Find The Lowest Lot Value
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {   
         if( ( OrderType () == OP_BUY ) && ( OrderSymbol () == Symbol () ) && ( OrderLots () < Minimal_Lot_Size_Buy) ) { Minimal_Lot_Size_Buy = OrderLots () ; }
        else
         Minimal_Lot_Size_Buy = Minimal_Lot_Size_Buy ;
      } 
        else GetLastError() ;
}
/////////////////////////////////////////////////////////////////////
   if ( Minimal_Lot_Size_Buy >= 1 )                                          { AverageMultiply = 1 ; }
   if ( ( Minimal_Lot_Size_Buy >= 0.1 ) &&  ( Minimal_Lot_Size_Buy < 1  ) )  { AverageMultiply = 10 ; }
   if ( ( Minimal_Lot_Size_Buy >= 0.01 ) && ( Minimal_Lot_Size_Buy < 0.1 ) ) { AverageMultiply = 100 ; }
/////////////////////////////////////////////////////////////////////
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {   
         if( ( OrderType () == OP_BUY ) && ( OrderSymbol () == Symbol () ) ) { SumOfBuy = SumOfBuy +  ( OrderOpenPrice () * ( OrderLots () * AverageMultiply ) ) ; 
                                                                               Print("Sum Of Buy = ", SumOfBuy ) ; TotalLotSizeBuy = TotalLotSizeBuy + OrderLots () ; }
         if( ( OrderType () == OP_BUY ) && ( OrderSymbol () != Symbol () ) ) { SumOfBuy = SumOfBuy                     ; Print("Sum Of Buy = ", SumOfBuy ) ; }
         if( ( OrderType () == OP_SELL) )                                    { SumOfBuy = SumOfBuy                     ; Print("Sum Of Buy = ", SumOfBuy ) ; }
            else
         GetLastError() ;
      }
   }    
   Print ("Total Lot Size For Buy = ", TotalLotSizeBuy ) ;
   if ( TotalLotSizeBuy != 0 ) { AveragePrice =  ( SumOfBuy / TotalLotSizeBuy ) / AverageMultiply ; }
      else Print ( "Total Buy = 0 " );
/////////////////////////////////////////////////////////////////////
   Average_Buy_Price = NormalizeDouble( AveragePrice,_Digits ) ;
   return Average_Buy_Price ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CALCULATE             //////////////////
/////////////////       AVERAGE SELL PRICE         //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double CalculateAverageSellPrice() {
   double AveragePrice ;
   int TotalSell = OrdersTotalSell() ;
   double SumOfSell = 0 ;
   double LotSize = OrderLots() ;
   double Minimal_Lot_Size_Sell = 1 ;
   double TotalLotSizeSell = 0 ;
   int AverageMultiply ;
   Print("Number Of Total Sell is ",TotalSell) ;
   Print("Sum Of Sell is ",SumOfSell) ;
///////////////////////////////////////////////////////////////////// Find The Lowest Lot Value
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {   
         if( ( OrderType () == OP_SELL ) && ( OrderSymbol () == Symbol () ) && ( OrderLots () < Minimal_Lot_Size_Sell) ) { Minimal_Lot_Size_Sell = OrderLots () ; }
        else
         Minimal_Lot_Size_Sell = Minimal_Lot_Size_Sell ;
      } 
        else GetLastError() ;
   }
/////////////////////////////////////////////////////////////////////
   if ( Minimal_Lot_Size_Sell >= 1 )                                           { AverageMultiply = 1 ; }
   if ( ( Minimal_Lot_Size_Sell >= 0.1 ) &&  ( Minimal_Lot_Size_Sell < 1  ) )  { AverageMultiply = 10 ; }
   if ( ( Minimal_Lot_Size_Sell >= 0.01 ) && ( Minimal_Lot_Size_Sell < 0.1 ) ) { AverageMultiply = 100 ; }
/////////////////////////////////////////////////////////////////////
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) {   
         if( ( OrderType () == OP_SELL ) && ( OrderSymbol () == Symbol () ) ) { SumOfSell = SumOfSell +  ( OrderOpenPrice () * ( OrderLots () * AverageMultiply ) ) ; 
                                                                               Print("Sum Of Sell = ", SumOfSell ) ; TotalLotSizeSell = TotalLotSizeSell + OrderLots () ; }
         if( ( OrderType () == OP_SELL ) && ( OrderSymbol () != Symbol () ) ) { SumOfSell = SumOfSell                     ; Print("Sum Of Sell = ", SumOfSell ) ; }
         if( ( OrderType () == OP_BUY) )                                      { SumOfSell = SumOfSell                     ; Print("Sum Of Sell = ", SumOfSell ) ; }
            else
         GetLastError() ;
      }
   }    
   Print ("Total Lot Size For Sell = ", TotalLotSizeSell ) ;
   if ( TotalLotSizeSell != 0 ) { AveragePrice =  ( SumOfSell / TotalLotSizeSell ) / AverageMultiply ; }
      else Print ( "Total Sell = 0 " );
/////////////////////////////////////////////////////////////////////
   Average_Sell_Price = NormalizeDouble(AveragePrice,_Digits);
   return Average_Sell_Price ;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////          ON TICK                 //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   Print ( "Average Buy  =  ", CalculateAverageBuyPrice() ) ;
   Print ( "Average Sell =  ", CalculateAverageSellPrice() ) ;
   Print ( "Minimal Lot Size for Buy  = ",SearchForMinimalLotSizeBuy() );
   Print ( "Minimal Lot Size for Sell = ",SearchForMinimalLotSizeSell() );
}