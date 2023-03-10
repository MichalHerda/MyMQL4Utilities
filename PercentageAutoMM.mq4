//+------------------------------------------------------------------+
//|                              Percentage Auto Money Managment.mq4 |
//|                                                     Michal Herda |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Michal Herda"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Running Program Sends Automatic Orders To Close All Positions After Reaching Percentage SL/TP, \nSet By The User."
#property description "\nOrders Will Be Sent If The Market Is Open And the SL / TP Application Buttons Are Pressed. "
#property description "\nBefore You Apply The Program To Your REAL Account, Make Sure You Understand How It Works. "
#property strict
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\RadioGroup.mqh>
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
#define BUTTON_WIDTH                                   (105)
//for Edit
#define EDIT_HEIGHT                                    (30)
#define EDIT_WIDTH                                     (105)
//for radio group
#define RADIO_HEIGHT                                   (40)
#define RADIO_WIDTH                                    (152)
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASSES           ////////////////////
/////////////////          DEFINITION            ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//**************************************************************************************************************************************************************
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////        CMainMenu CLASS         ////////////////////
/////////////////           DEFINITION           ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
class CMainMenu : public CAppDialog
  {
public:
      CButton                      m_button1 ;
      CButton                      m_button2 ;
      CEdit                        m_edit ;
      CEdit                        m_edit1 ;
      CEdit                        m_edit2 ;
      CRadioGroup                  m_radio_group ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                   CMainMenu(void) ;
                                  ~CMainMenu(void) ;
//--- create
      virtual bool                 Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2) ;
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- chart event handler
      virtual bool                 OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create dependent controls    
      bool                         CreateButton1(void) ;
      bool                         CreateButton2(void) ;
      bool                         CreateEdit (void) ;
      bool                         CreateEdit1(void) ;
      bool                         CreateEdit2(void) ;
      bool                         CreateRadioGroup(void) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      void                         OnClickButton1(void) ;
      void                         OnClickButton2(void) ;
      void                         OnChangeRadioGroup(void) ; 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ON_EVENT(ON_CLICK,m_button1,OnClickButton1)
ON_EVENT(ON_CLICK,m_button2,OnClickButton2)
ON_EVENT(ON_CHANGE,m_radio_group,OnChangeRadioGroup)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CMainMenu::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false) ;
//--- create dependent controls
   if(!CreateButton1())
      return(false) ;
   if(!CreateButton2())
      return(false) ;
   if(!CreateEdit())
      return(false) ;
   if(!CreateEdit1())
      return(false) ;
   if(!CreateEdit2())
      return(false) ;
   if(!CreateRadioGroup())
      return(false) ;
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
extern bool log_display_enable = true ;
extern bool tooltip_enable = true ;
extern bool SWAP_Include = true ;
extern bool Commission_Include = true ;
extern int  Decimal_Places = 3 ;
/////////////////////////////////////////////////////////////////////
double      PercentageProfit ;
double      Percentage_Profit_Target ;
double      Percentage_Loss_Allowed ;
double      Account_Balance ;
bool        AutoSL_Enable = false ;
bool        AutoTP_Enable = false ;
bool        AllChartsApply = false ;
double      WholeProfit ;
double      Close_Price_Buy = 0 ;
double      Close_Price_Sell = 0 ;
CMainMenu   MainWindow ;
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////           ON_INIT              ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create application dialog
   if(!MainWindow.Create(0,"      Percentage Auto Money Managment ",0,40,40,330,247))
      return(INIT_FAILED) ;
//--- run application
   MainWindow.Run() ;
//--- enable object create events
   ChartSetInteger (ChartID(), CHART_EVENT_OBJECT_CREATE, true) ;
//--- enable object delete events
   ChartSetInteger (ChartID(), CHART_EVENT_OBJECT_DELETE, true) ;
//--- succeed
   return(INIT_SUCCEEDED) ;
//---
 }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////           ON_DEINIT            ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("") ;
//--- destroy dialog
   MainWindow.Destroy(reason) ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////           CHART_EVENT          ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   MainWindow.ChartEvent(id,lparam,dparam,sparam) ;
/////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit1" )
  {
   string Value = ObjectGetString(0, "Edit1", OBJPROP_TEXT, 0) ;
   Percentage_Loss_Allowed = StringToDouble(Value) ;
  }
/////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit2" )
  {
   string Value = ObjectGetString(0, "Edit2", OBJPROP_TEXT, 0) ;
   Percentage_Profit_Target = StringToDouble (Value) ;   
  }
///////////////////////////////////////////////////////////////////// 
   Displaying_Calculations() ;
  }   
/////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton1(void)
  {
///--- coordinates
   double x1 = ( 2 * INDENT_LEFT )  ;
   double y1 = ( 2 * INDENT_TOP ) + EDIT_HEIGHT ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2 =  y1 + EDIT_HEIGHT ;
//--- create
   if(!m_button1.Create(m_chart_id,"Button1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Button1",OBJPROP_TOOLTIP,"Auto Stop Loss Enable/Disable \nPressed: ON \nNot Pressed: OFF"))
                  return(false) ; }
   if(!Add(m_button1))
      return(false) ;
   m_button1.Locking(true) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if ( AutoSL_Enable == false )  { ( m_button1.Pressed(false) ) ; ( m_button1.Text ("Auto SL / OFF ")  );  }
  if ( AutoSL_Enable == true  )  { ( m_button1.Pressed(true)  ) ; ( m_button1.Text ("Auto SL / ON " )  );  }
//--- succeed
   return(true) ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 2               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton2(void)
  {
///--- coordinates
   double x1 = ( 2 * INDENT_LEFT ) ;
   double y1 = ( 3 * INDENT_TOP ) + BUTTON_HEIGHT + EDIT_HEIGHT ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2=  y1 + EDIT_HEIGHT ;
//--- create
   if(!m_button2.Create(m_chart_id,"Button2",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if ( tooltip_enable == true) { 
               if(!ObjectSetString(0,"Button2",OBJPROP_TOOLTIP,"Auto Take Profit Enable/Disable \nPressed: ON \nNot Pressed: OFF"))
                  return(false) ; }
   if(!Add(m_button2))
      return(false) ;
   m_button2.Locking(true) ;   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////    
   if ( AutoTP_Enable == false )  { ( m_button2.Pressed(false) ) ; ( m_button2.Text ("Auto TP / OFF ")  );  }
   if ( AutoTP_Enable == true  )  { ( m_button2.Pressed(true)  ) ; ( m_button2.Text ("Auto TP / ON " )  );  }
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////             EDIT                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit(void)
  {
//--- coordinates
   int x1 = ( 2 * INDENT_LEFT ) ;
   int y1 = INDENT_TOP  ;
   int x2 = x1 + ( 2 * BUTTON_WIDTH ) + ( 2 * INDENT_LEFT ) ;
   int y2 = y1 + BUTTON_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit.Create(m_chart_id,"Edit",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit.Text(DoubleToString( 0, Digits)))
      return(false) ;
   if(!m_edit.ReadOnly(true))
      return(false) ;
   if(!m_edit.TextAlign(ALIGN_CENTER))
      return(true) ;
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit",OBJPROP_TOOLTIP,"Displaying Loss/Profit Value"))
                  return (false) ; }
   if ( !Add (m_edit) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 1                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit1(void)
  {
//--- coordinates
   int x1 = ( 4 * INDENT_LEFT )  + BUTTON_WIDTH ;
   int y1 = ( 2 * INDENT_TOP ) + EDIT_HEIGHT ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT; 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit1.Create(m_chart_id,"Edit1",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit1.Text(DoubleToString(Percentage_Loss_Allowed, Decimal_Places)))
      return(false);
   if(!m_edit1.ReadOnly(false))
      return(true);
   if(!m_edit1.TextAlign(ALIGN_CENTER))
      return(true);   
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit1",OBJPROP_TOOLTIP,"Set Percentage Loss Value To Close All Positions\nTake Into Account Negative And Positive Numbers\nWarning! If Button On Left Is Pressed, Market Open\nAnd This Field Value Is Greater That Percentage Loss/Profit Above\nOrder Close Will Be Send Immediately"))
                  return(false) ; }
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
bool CMainMenu::CreateEdit2(void)
  {
//--- coordinates
   int x1 = ( 4 * INDENT_LEFT ) + BUTTON_WIDTH  ;
   int y1 = ( 3 * INDENT_TOP ) + BUTTON_HEIGHT + EDIT_HEIGHT ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit2.Create(m_chart_id,"Edit2",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit2.Text( DoubleToString ( Percentage_Profit_Target  , Decimal_Places ) ) ) 
      return(false);
   if(!m_edit2.ReadOnly(false))
      return(true); 
   if(!m_edit2.TextAlign(ALIGN_CENTER))
      return(true);
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit2",OBJPROP_TOOLTIP,"Set Percentage Profit Value To Close All Positions.\nTake Into Account Negative And Positive Numbers\nWarning! If Button On Left Is Pressed, Market Open\nAnd This Field Value Is Less That Percentage Loss/Profit Above\nOrder Close Will Be Send Immediately"))
                  return(false) ; }
   if(!Add(m_edit2))
      return(false);   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////          RADIO_GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateRadioGroup(void)
  {
//--- coordinates
   int x1 = ( 5.5 * INDENT_LEFT ) ;
   int y1 = ( 4 * INDENT_TOP ) + ( 2 * BUTTON_HEIGHT ) + EDIT_HEIGHT ;
   int x2 = x1 + RADIO_WIDTH ;
   int y2 = y1 + RADIO_HEIGHT;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_radio_group.Create(m_chart_id,"RadioGroup",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_radio_group))
      return(false);
//----add items
   if(!m_radio_group.AddItem("    Current Chart",1))
      return(false);
   if(!m_radio_group.AddItem("       All Charts ",2))
      return(false);
//----set default value
   if(AllChartsApply == false )  m_radio_group.Value(1) ;   
   if(AllChartsApply == true  )  m_radio_group.Value(2) ;   
//--- succeed
   return(true) ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 1              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnClickButton1(void)
  {
   if ( m_button1.Pressed() ) 
       { 
         AutoSL_Enable = true ; 
         m_button1.Text("Auto SL / ON") ; 
         if ( log_display_enable == true ) { Print ( "AutoSL_Enable = ", AutoSL_Enable ) ; }
        }
               else { AutoSL_Enable = false ; m_button1.Text ( "Auto SL / OFF" ) ; 
               if ( log_display_enable == true ) { Print ( "AutoSL_Enable = ", AutoSL_Enable ) ; }
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
void CMainMenu::OnClickButton2(void)
  {
    if ( m_button2.Pressed() ) 
       { 
        AutoTP_Enable = true ; 
        m_button2.Text("Auto TP / ON") ; 
        if ( log_display_enable == true ) { Print ( "AutoTP_Enable = ", AutoTP_Enable ) ; }
       }
               else { AutoTP_Enable = false ; m_button2.Text("Auto TP / OFF") ; 
               if ( log_display_enable == true ) { Print ( "AutoTP_Enable = ", AutoTP_Enable ) ; }
               }
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           ON_CHANGE              //////////////////
/////////////////          RADIO_GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnChangeRadioGroup(void)
  {
   if(m_radio_group.Value() == 1)
     {
      AllChartsApply = false ;
      if ( log_display_enable == true ) { Print( "Option Changed : Applied For ", Symbol() ) ; }
     }
   if(m_radio_group.Value() == 2)
     {
      AllChartsApply = true ;
      if ( log_display_enable == true ) { Print( "Option Changed : Applied For All Symbols" ) ; 
     }
     }  
    if ( (m_radio_group.Value() == 1) && (m_radio_group.Value() == 2) )
      if ( log_display_enable == true ) {Print( "Error: Both \"Current Chart\" And \"All Charts\" Are Marked. Please Change TimeFrame or Restart EA If Changing TimeFrame Does Not Work" ); 
     }
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////          ORDER PROFIT            //////////////////
/////////////////       FOR CURRENT SYMBOL         //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double OrderProfitForCurrentSymbol()
   {
      double Current_Symbol_Profit = 0 ;
      for ( int i = 0 ; i < OrdersTotal() ; i++ )
         { 
              if ( ( SWAP_Include == false ) && ( Commission_Include == false ) )                
                 {
                  if ( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true )   
                     { 
                        if ( OrderSymbol () == Symbol () ) Current_Symbol_Profit = Current_Symbol_Profit + OrderProfit () ;
                        if ( OrderSymbol () != Symbol () ) Current_Symbol_Profit = Current_Symbol_Profit ;
                     }
                           else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
                 }
                 
                if ( ( SWAP_Include == true ) && ( Commission_Include == false )   )             
                 {
                  if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
                     { 
                        if ( OrderSymbol () == Symbol () ) Current_Symbol_Profit = Current_Symbol_Profit + OrderProfit () + OrderSwap () ;
                        if ( OrderSymbol () != Symbol () ) Current_Symbol_Profit = Current_Symbol_Profit ;
                     }
                           else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
                 }    
               
                 if ( ( SWAP_Include == true ) && ( Commission_Include == true )  )               
                 {
                  if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
                     { 
                        if ( OrderSymbol () == Symbol () ) Current_Symbol_Profit = Current_Symbol_Profit + OrderProfit () + OrderSwap () + OrderCommission () ;
                        if ( OrderSymbol () != Symbol () ) Current_Symbol_Profit = Current_Symbol_Profit ;
                     }
                           else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
                 }
         }
      return (Current_Symbol_Profit) ;     
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           ORDER SWAP             //////////////////
/////////////////        FOR ALL  SYMBOLS          //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double OrderSwapForAllSymbols()
   {
      double Swap_For_All_Symbols = 0 ;
      for ( int i = 0 ; i < OrdersTotal() ; i++ )
         { 
            if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
               { 
                  Swap_For_All_Symbols = Swap_For_All_Symbols + OrderSwap () ;
               }
                     else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
         }
      return ( Swap_For_All_Symbols ) ;     
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ORDER SWAP            //////////////////
/////////////////        FOR CURRENT SYMBOL        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double OrderSwapForCurrentSymbol()
   {
      double Swap_For_Current_Symbol = 0 ;
      for ( int i = 0 ; i < OrdersTotal() ; i++ )
         { 
            if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
               { 
                  if ( OrderSymbol () == Symbol () ) Swap_For_Current_Symbol = Swap_For_Current_Symbol + OrderSwap () ;
                  if ( OrderSymbol () != Symbol () ) Swap_For_Current_Symbol = Swap_For_Current_Symbol ;               
               }
                     else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
         }
      return ( Swap_For_Current_Symbol ) ;     
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        ORDER COMMISSION          //////////////////
/////////////////        FOR ALL  SYMBOLS          //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double OrderCommissionForAllSymbols()
   {
      double Commission_For_All_Symbols = 0 ;
      for ( int i = 0 ; i < OrdersTotal() ; i++ )
         { 
            if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
               { 
                  Commission_For_All_Symbols = Commission_For_All_Symbols + OrderCommission () ;
               }
                     else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
         }
      return ( Commission_For_All_Symbols ) ;     
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////         ORDER COMMISSION         //////////////////
/////////////////        FOR CURRENT SYMBOL        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double OrderCommissionForCurrentSymbol()
   {
      double Commission_For_Current_Symbol = 0 ;
      for ( int i = 0 ; i < OrdersTotal () ; i ++ )
         { 
            if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
               { 
                  if ( OrderSymbol () == Symbol () ) Commission_For_Current_Symbol = Commission_For_Current_Symbol + OrderCommission () ;
                  if ( OrderSymbol () != Symbol () ) Commission_For_Current_Symbol = Commission_For_Current_Symbol ;               
               }
                     else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
         }
      return ( Commission_For_Current_Symbol ) ;     
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           ORDERS TOTAL           //////////////////
/////////////////        FOR CURRENT SYMBOL        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
int OrdersTotalSymbol()
   {
      int Total_Symbol_Opened = 0 ;
      for ( int i = 0 ; i < OrdersTotal () ; i ++ )
          {
            if (OrderSelect (i, SELECT_BY_POS, MODE_TRADES) == true)   
               { 
                 if ( OrderSymbol () == Symbol () ) Total_Symbol_Opened = Total_Symbol_Opened + 1 ;
                 if ( OrderSymbol () != Symbol () ) Total_Symbol_Opened = Total_Symbol_Opened ; 
               }
                     else Print ( "Position have not been selected, Error = ",GetLastError() ) ; 
         }
      return ( Total_Symbol_Opened ) ;     
   }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////          ON TICK                 //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OnTick()
  {
//---
      if ( log_display_enable == true )
         {         
         Print ( " Auto Stop Loss Enable = ", AutoSL_Enable ) ;
         Print ( " Auto Take Profit Enable = ", AutoTP_Enable ) ;
         Print ( " Account Balance = ", DoubleToString ( AccountBalance (), 2 ) ) ;
         if ( ( SWAP_Include == true ) && ( Commission_Include == true  ) ) Print ( " Account Profit ( Costs Included ) = ", DoubleToString ( AccountProfit (), 2 ) ) ;
         if ( ( SWAP_Include == true ) && ( Commission_Include == false ) && ( AllChartsApply == true ) ) 
            Print ( " Account Profit ( SWAP Included, Commision Not Included ) = ", DoubleToString ( ( AccountBalance () + OrderSwapForAllSymbols () ), 2 ) ) ;
//         if ( ( SWAP_Include == true ) && ( Commission_Include == false ) && ( AllChartsApply == false ) ) 
//            Print ( " Account Profit ( SWAP Included, Commision Not Included ) = ", DoubleToString ( ( AccountBalance () + OrderSwapForCurrentSymbol () ), 2 ) ) ;
         if ( ( SWAP_Include == false ) && ( Commission_Include == true ) && ( AllChartsApply == true ) ) 
            Print ( " Account Profit ( SWAP Not Included, Commision Included ) = ", DoubleToString ( ( AccountBalance () + OrderCommissionForAllSymbols () ), 2 ) ) ;    
//         if ( ( SWAP_Include == false ) && ( Commission_Include == true ) && ( AllChartsApply == false ) ) 
//            Print ( " Account Profit ( SWAP Not Included, Commision Included ) = ", DoubleToString ( ( AccountBalance () + OrderCommissionForCurrentSymbol () ), 2 ) ) ;  
         if ( ( SWAP_Include == false ) && ( Commission_Include == false ) && ( AllChartsApply == true ) ) 
            Print ( " Account Profit ( SWAP Not Included, Commision Included ) = ", DoubleToString ( ( AccountBalance () + OrderCommissionForAllSymbols () + OrderSwapForAllSymbols() ), 2 ) ) ;    
//         if ( ( SWAP_Include == false ) && ( Commission_Include == false ) && ( AllChartsApply == false ) ) 
//            Print ( " Account Profit ( SWAP Not Included, Commision Included ) = ", DoubleToString ( ( AccountBalance () + OrderCommissionForCurrentSymbol () + OrderSwapForCurrentSymbol () ), 2 ) ) ;      
         Print ( " Current Symbol Profit = ", DoubleToString ( OrderProfitForCurrentSymbol (), 2 ) ) ;
         Print ( " Current Instrument SWAP = ", DoubleToString ( OrderSwapForCurrentSymbol (), 2) ) ;
         Print ( " Sum of All Symbols SWAP = ", DoubleToString ( OrderSwapForAllSymbols (), 2 ) ) ;
         Print ( " Current Symbol Commission = ", DoubleToString ( OrderCommissionForCurrentSymbol (), 2 ) ) ;
         Print ( " All Symbols Commission = ", DoubleToString ( OrderCommissionForAllSymbols (), 2 ) ) ;
         Print ( " Percentage Loss Alowed ( SL ) = ", Percentage_Loss_Allowed  ) ;
         Print ( " Percentage Profit Target ( TP ) = ", Percentage_Profit_Target  ) ;
         
         Print ( " Orders Total For Current Symbol = ", OrdersTotalSymbol () ) ;
         Print ( " Orders Total For All Symbols = ", OrdersTotal () ) ;
         }
//         Print ( " Account Profit = ", NormalizeDouble (AccountProfit (), 2 ) );
          
       Displaying_Calculations () ;  
  }

                                                               /////////////////////////////////////////////////////////////////////
                                                               /////////////////////////////////////////////////////////////////////
                                                               /////////////////                                  //////////////////
                                                               /////////////////           DISPLAYING             //////////////////
                                                               /////////////////          CALCULATIONS            //////////////////
                                                               /////////////////                                  //////////////////
                                                               /////////////////////////////////////////////////////////////////////
                                                               /////////////////////////////////////////////////////////////////////
                                       
                    void Displaying_Calculations()
                    
                              {
                              
                                                          
                                           if ( AllChartsApply == false )
                                                      {
                                                       if ( AccountBalance () != 0 )
                                                             {
                                                             PercentageProfit = (OrderProfitForCurrentSymbol()/AccountBalance()) * 100 ;
                                                             }
                                                       if ( AccountBalance () == 0 )
                                                             {
                                                             PercentageProfit = 0 ;
                                                             }
                                                       double UpdatedProfitForCurrentSymbol = NormalizeDouble ( OrderProfitForCurrentSymbol () , Decimal_Places ) ;
                                                       double UpdatedPercentageProfit = NormalizeDouble ( PercentageProfit, Decimal_Places ) ;
                                                       string PercentageProfitString = DoubleToStr ( UpdatedPercentageProfit, Decimal_Places ) ;   
                                                       string Percentage_Loss_AllowedString = DoubleToStr ( Percentage_Loss_Allowed, Decimal_Places ) ;
                                                       string Percentage_Profit_TargetString = DoubleToStr ( Percentage_Profit_Target, Decimal_Places ) ;
                                                       ObjectSetString(0,"Edit",OBJPROP_TEXT, PercentageProfitString + " %" );
                                                       ObjectSetString(0,"Edit1",OBJPROP_TEXT, Percentage_Loss_AllowedString + " %" ) ;
                                                       ObjectSetString(0,"Edit2",OBJPROP_TEXT, Percentage_Profit_TargetString + " %" ) ;
                                                                                                             
                                                       
                                                    
                                                      if ( ( UpdatedPercentageProfit >= Percentage_Profit_Target ) && ( AutoTP_Enable == true ) && ( OrdersTotalSymbol () > 0 )  ) 
                                                      {Print ( " Profit Reached. A close Order Has Been Sent For All Positions . Pleace Notice, Slippage Is Possible. The Program Is Not Responsible For That " ) ; 
                                                      CloseAll () ;}
                                                      
                                                      if ( ( UpdatedPercentageProfit <= Percentage_Loss_Allowed   ) && ( AutoSL_Enable == true ) && ( OrdersTotalSymbol () > 0 ) )   
                                                      {Print ( " Maximal Loss Reached. A Close Order Has Been Sent For Current Symbol Positions. Pleace Notice, Slippage Is Possible. The Program Is Not Responsible For That " ) ;
                                                      CloseAll () ;}
                                                       
                                                      }
                                          
// There is difference beetween Profit definitions for AllChartApply bool :  SWAP_Include & Commission_Include are included in OrderProfitForCurrentSymbol for AllChartApply == false
//                                                                           For AllChartApply == true they are included inside this function below :                                       
                                          
                                                    if ( AllChartsApply == true )
                                                    
                                                         {
                                                                                                            
                                                          if ( ( SWAP_Include == true ) && ( Commission_Include == true ) )  WholeProfit = AccountProfit () ;
                                                          if ( ( SWAP_Include == true ) && ( Commission_Include == false ) ) WholeProfit = AccountProfit () - OrderSwapForAllSymbols () ;
                                                          if ( ( SWAP_Include == false ) && ( Commission_Include == false ) ) WholeProfit = AccountProfit () - OrderSwapForAllSymbols () - OrderCommissionForAllSymbols () ;
                                                          
                                                          if ( AccountBalance () != 0 )
                                                                   {                                          
                                                                   PercentageProfit = (  WholeProfit  /  AccountBalance())  * 100 ;
                                                                   }
                                                          if ( AccountBalance () == 0 )
                                                                   {
                                                                   PercentageProfit = 0 ;
                                                                   }
                                                          double UpdatedProfitForAllSymbols = NormalizeDouble ( WholeProfit , Decimal_Places ) ;
                                                          double UpdatedPercentageProfit = NormalizeDouble ( PercentageProfit, Decimal_Places ) ;
                                                          string PercentageProfitString = DoubleToStr ( UpdatedPercentageProfit, Decimal_Places ) ;   
                                                          string Percentage_Loss_AllowedString = DoubleToStr ( Percentage_Loss_Allowed, Decimal_Places ) ;
                                                          string Percentage_Profit_TargetString = DoubleToStr ( Percentage_Profit_Target, Decimal_Places ) ;
                                                          ObjectSetString(0,"Edit",OBJPROP_TEXT, PercentageProfitString + " %" ) ;
                                                          ObjectSetString(0,"Edit1",OBJPROP_TEXT, Percentage_Loss_AllowedString  + " %" ) ;
                                                          ObjectSetString(0,"Edit2",OBJPROP_TEXT, Percentage_Profit_TargetString + " %" ) ;
                                                         
                                                         if ( ( UpdatedPercentageProfit >= Percentage_Profit_Target ) && ( AutoTP_Enable == true )  && ( OrdersTotal () > 0 ) ) 
                                                         {Print ( " Profit Reached. A close Order Has Been Sent For All Positions . Pleace Notice, Slippage Is Possible. The Program Is Not Responsible For That " ) ; 
                                                         CloseAll() ;}
                                                         
                                                         if ( ( UpdatedPercentageProfit <= Percentage_Loss_Allowed   ) && ( AutoSL_Enable == true ) && ( OrdersTotal () > 0 ) )   
                                                         {Print ( " Maximal Loss Reached. A Close Order Has Been Sent For Current Symbol Positions. Pleace Notice, Slippage Is Possible. The Program Is Not Responsible For That " ) ;
                                                         CloseAll() ;}
                                                                                                                                                                 
                                                        }                                                                                                                                                        
                              }
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************                                                                               *****************************************************************
//***************************************************                  FUNCTIONS TAKEN FROM MY PREVIOUS PROGRAMS                    *****************************************************************
//***************************************************                   THEY SHOULD BE UPLOADED INTO LIBRARIES                      *****************************************************************
//***************************************************                             AND #INCLUDE AS MQH                               *****************************************************************
//***************************************************                                                                               *****************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        GET CLOSE PRICE           //////////////////
/////////////////              BUY                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double GetClosePriceBuy(int i)
   {
   //--- wybrać pozycję/zlecenie z indeksem "i"      
//    Print("Selected Position Ticket is, ", OrderTicket() );
//    Print( "OrderSymbol = ",OrderSymbol() );
//    Print( "Symbol() = ", Symbol() );     
      Close_Price_Buy = MarketInfo(OrderSymbol(), MODE_BID);
//////////////////////////////////////////////////////////////////////////     
//     Print( "Close Price for Buy Position, Ticket No ",OrderTicket()," is ",Close_Price_Buy," . Remember That Slippage Is Possible, And It Is Not This EA Responsibility. Slippage Could Be Both Positive And Negative.") ; 
//////////////////////////////////////////////////////////////////////////     
      return(Close_Price_Buy);
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        GET CLOSE PRICE           //////////////////
/////////////////              SELL                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double GetClosePriceSell(int i)
   {
   //--- wybrać pozycję/zlecenie z indeksem "i"     
//    Print("Selected Position Ticket is, ", OrderTicket() );
//    Print( "OrderSymbol = ",OrderSymbol() );
//    Print( "Symbol() = ", Symbol() );
      Close_Price_Sell = MarketInfo(OrderSymbol(), MODE_ASK);      
//////////////////////////////////////////////////////////////////////////          
//    Print( "Close Price for Buy Position, Ticket No ",OrderTicket()," is ",Close_Price_Buy," . Remember That Slippage Is Possible, And It Is Not This EA Responsibility. Slippage Could Be Both Positive And Negative.") ; 
//////////////////////////////////////////////////////////////////////////     
      return(Close_Price_Sell);
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             CLOSE                //////////////////
/////////////////              ALL                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CloseAll()
  {
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)   
           if( AllChartsApply == true )
             {
               //--- wybrać tylko otwartą pozycję na sprzedaż
               if(OrderType() == OP_SELL)                
                     {
                     GetClosePriceSell(i);
                     Close_Sell_Instruction(Close_Price_Sell);
                     }                     
               if(OrderType() == OP_BUY)                
                     {
                     GetClosePriceBuy(i);
                     Close_Buy_Instruction(Close_Price_Buy );
                     }                                                     
            }
            
          if ( ( AllChartsApply == false ) && ( OrderSymbol()!=Symbol() ) )
               
                 {
                 Print("Position No ",OrderTicket()," Does Not Belong To This Chart, So Won't Be Closed. If You Need To Close This Position, Change Option For All Charts Or Launch Program On ",OrderSymbol()," Chart. ");
                
                 }
                 
              if ( ( AllChartsApply == false ) && ( OrderSymbol()==Symbol() ) )
               
                 {
                  //--- wybrać tylko otwartą pozycję na sprzedaż
                  if(OrderType() == OP_SELL)
                    
                     {
                     GetClosePriceSell(i);
                     Close_Sell_Instruction(Close_Price_Sell);
                     }
         
                  if(OrderType() == OP_BUY)
                    
                     {
                     GetClosePriceBuy(i);
                     Close_Buy_Instruction(Close_Price_Buy);
                     }
                 }                                           
     }
  }
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////           CLOSE BUY              //////////////////
                                                            /////////////////          INSTRUCTION             //////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
void Close_Buy_Instruction(double Close_Price_Buy)
  {
   if ( IsTradeAllowed ( OrderSymbol(), TimeCurrent () ) == false ) { Print("Market Closed ",OrderSymbol()," Trading Is Not Allowed, Cannot Close Selected Position ",OrderTicket() , " Please Check Hours Of Trading And Try Later ") ; }
   if ( OrderType() == OP_BUY )
                 {
                  //--- odświeżyć notowania
                  RefreshRates();
                  //--- zamknąć wybraną pozycję
                  if(OrderClose(OrderTicket(), // funkcja OrderTicket() znajdzie unikalny numer (ticket) pozycji
                                OrderLots(),   // funkcja OrderLots() znajdzie ilość lotów tej pozycji
                                Close_Price_Buy,           // aktualna cena kupna
                                0)            // poślizg cenowy, w punktach
                     == false)
                     //--- wyświetlić informację jeśli nie uda się zamknąć pozycję
                     Print("Position ",OrderTicket()," Not Closed "
                           ". Error = ",GetLastError());
                            else Print("Position ",OrderTicket()," Closed");
                 }
  }
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////          CLOSE SELL              //////////////////
                                                            /////////////////          INSTRUCTION             //////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
void Close_Sell_Instruction(double Close_Price_Sell)
  {
   if ( IsTradeAllowed ( OrderSymbol(), TimeCurrent () ) == false ) { Print("Market Close ",OrderSymbol()," Trading Is Not Allowed, Cannot Close Selected Position ",OrderTicket(), " Please Check Hours Of Trading And Try Later ") ; }
   if ( OrderType() == OP_SELL)
                 {
                  //--- odświeżyć notowania
                  RefreshRates();
                  //--- zamknąć wybraną pozycję
                  if(OrderClose(OrderTicket(), // funkcja OrderTicket() znajdzie unikalny numer (ticket) pozycji
                                OrderLots(),   // funkcja OrderLots() znajdzie ilość lotów tej pozycji
                                Close_Price_Sell,           // aktualna cena kupna
                                0)            // poślizg cenowy, w punktach
                     == false)
                     //--- wyświetlić informację jeśli nie uda się zamknąć pozycję
                     Print("Position ",OrderTicket()," Not Closed "
                           ". Error = ",GetLastError());
                           else Print("Position ",OrderTicket()," Closed");
                 }  
    else 
      Print(" ");
  }