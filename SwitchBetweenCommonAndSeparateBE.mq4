//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************              SWITCH BETWEEN SEPARATE AND COMMON              ************************************************
//***********************************************                          BREAKEVEN                           ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//+------------------------------------------------------------------+
//|                 Switch Between Common And Separate BreakEven.mq4 |
//|                                                     Michal Herda |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#property copyright "Michal Herda"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\CheckGroup.mqh>
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASS             ////////////////////
/////////////////           DEFINES              ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//indent and gaps
#define INDENT_TOP                                     (15)
#define INDENT_LEFT                                    (15)
//for Button
#define BUTTON_HEIGHT                                  (30)
#define BUTTON_WIDTH                                   (120)
//for Edit
#define EDIT_HEIGHT                                    (30)
#define EDIT_WIDTH                                     (105)
//for CheckGroup
#define CHECK_HEIGHT                                   (40)
#define CHECK_WIDTH                                    (150)
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
      CButton                      m_button3 ;
      CEdit                        m_edit1 ;
      CEdit                        m_edit2 ;
      CEdit                        m_edit3 ;
      CCheckGroup                  m_check_group ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                   CMainMenu (void) ;
                                  ~CMainMenu (void) ;
//--- create
      virtual bool                 Create (const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- chart event handler
      virtual bool                 OnEvent (const int id,const long &lparam,const double &dparam,const string &sparam) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create dependent controls    
      bool                         CreateButton1      (void) ;
      bool                         CreateButton2      (void) ;
      bool                         CreateButton3      (void) ;
      bool                         CreateEdit1        (void) ;
      bool                         CreateEdit2        (void) ;
      bool                         CreateEdit3        (void) ;
      bool                         CreateCheckGroup   (void) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      void                         OnClickButton1     (void) ;
      void                         OnClickButton2     (void) ;
      void                         OnClickButton3     (void) ;
      void                         OnChangeCheckGroup (void) ;
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
EVENT_MAP_BEGIN (CMainMenu)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ON_EVENT (ON_CLICK,m_button1,OnClickButton1)
ON_EVENT (ON_CLICK,m_button2,OnClickButton2)
ON_EVENT (ON_CLICK,m_button3,OnClickButton3)
ON_EVENT (ON_CHANGE,m_check_group,OnChangeCheckGroup)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
EVENT_MAP_END (CAppDialog)
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
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
CMainMenu::CMainMenu (void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMainMenu::~CMainMenu (void)
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
bool CMainMenu::Create (const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if (!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false) ;
//--- create dependent controls
   if (!CreateButton1())
      return(false) ;
   if (!CreateButton2())
      return(false) ;
   if (!CreateButton3())
      return(false) ;
   if (!CreateEdit1())
      return(false) ;
   if (!CreateEdit2())
      return(false) ;
   if (!CreateEdit3())
      return(false) ;
   if (!CreateCheckGroup())
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
extern bool log_display_enable             = true  ;
extern bool tooltip_enable                 = true  ;
/////////////////////////////////////////////////////////////////////
double Average_Buy_Price         ;
double Average_Sell_Price        ;
/////////////////////////////////////////////////////////////////////
int Average_Modification         ;
int Separate_Modification        ;
int BE_Mod_Level                 ;
/////////////////////////////////////////////////////////////////////
bool Average_BE_Mode     = false ;
bool Separate_BE_Mode    = false ;
bool Auto_BE_Mode        = false ;
/////////////////////////////////////////////////////////////////////
bool Buy_Apply           = false ;
bool Sell_Apply          = false ;
CMainMenu   MainWindow           ;
/////////////////////////////////////////////////////////////////////
double Minimal_Lot_Size_Buy  = 1 ;
double Minimal_Lot_Size_Sell = 1 ;
/////////////////////////////////////////////////////////////////////
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
   if(!MainWindow.Create(0,"Switch Between Common And Separate BE ",0,40,40,348,270))
      return (INIT_FAILED) ;
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
         string Value1 = ObjectGetString(0, "Edit1", OBJPROP_TEXT, 0) ;
         Average_Modification = StringToInteger(Value1) ;
        }
/////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit2" )
        {
         string Value2 = ObjectGetString(0, "Edit2", OBJPROP_TEXT, 0) ;
         Separate_Modification = StringToInteger (Value2) ;   
        }
/////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit3" )
        {
         string Value3 = ObjectGetString(0, "Edit3", OBJPROP_TEXT, 0) ;
         BE_Mod_Level = StringToInteger (Value3) ;   
        }
  }
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
   double y1 = INDENT_TOP  ;
   double x2 = x1 + BUTTON_WIDTH ;
   double y2 =  y1 + EDIT_HEIGHT ;
//--- create
   if(!m_button1.Create(m_chart_id,"Button1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_button1.Text("Common BE"))
      return(false);
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Button1",OBJPROP_TOOLTIP,"Set Common BreakEven Stoploss Value\nThis Value Is Calculated As Average Open Price \nDecreased/Increased By The Value From The Field On The Right"))
                  return(false) ; }
   if(!Add(m_button1))
      return(false) ;
   m_button1.Locking(false) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  if ( AutoSL_Enable == false )  { ( m_button1.Pressed(false) ) ; ( m_button1.Text ("Auto SL / OFF ")  );  }
//  if ( AutoSL_Enable == true  )  { ( m_button1.Pressed(true)  ) ; ( m_button1.Text ("Auto SL / ON " )  );  }
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
   double y1 = ( 2 * INDENT_TOP ) + BUTTON_HEIGHT  ;
   double x2 = x1 + BUTTON_WIDTH ;
   double y2=  y1 + EDIT_HEIGHT ;
//--- create
   if(!m_button2.Create(m_chart_id,"Button2",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_button2.Text("Separate BE"))
      return(false);
   if ( tooltip_enable == true) { 
               if(!ObjectSetString(0,"Button2",OBJPROP_TOOLTIP,"Set Separate BreakEven Stoplosses Value\nDecreased/Increased By The Value From The Field On The Right\nThis Option is Available Only If All Current Symbol Positions Are Profitable\nSWAP And Commission Are Not Included"))
                  return(false) ; }
   if(!Add(m_button2))
      return(false) ;
   m_button2.Locking(false) ;   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////    
//   if ( AutoTP_Enable == false )  { ( m_button2.Pressed(false) ) ; ( m_button2.Text ("Auto TP / OFF ")  );  }
//   if ( AutoTP_Enable == true  )  { ( m_button2.Pressed(true)  ) ; ( m_button2.Text ("Auto TP / ON " )  );  }
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 3               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton3(void)
  {
///--- coordinates
   double x1 = ( 2 * INDENT_LEFT ) ;
   double y1 = ( 3 * INDENT_TOP ) + ( 2 * BUTTON_HEIGHT ) ;
   double x2 = x1 + BUTTON_WIDTH ;
   double y2=  y1 + EDIT_HEIGHT ;
//--- create
   if(!m_button3.Create(m_chart_id,"Button3",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if ( tooltip_enable == true) { 
               if(!ObjectSetString(0,"Button3",OBJPROP_TOOLTIP,"Enable Automatic Change Between Common And Separate BreakEven StopLosses\nAverage Mode Is Activate If At Least One Position Is Not Profitable\nSeparate Mode Is Activate After Reaching BreakEven Modification Level By The Least Profitable Position\n"))
                  return(false) ; }
   if(!Add(m_button3))
      return(false) ;
   m_button3.Locking(true) ;   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////    
   if ( Auto_BE_Mode == false )  { ( m_button3.Pressed(false) ) ; ( m_button3.Text ("Mode Auto / OFF ")  );  }
   if ( Auto_BE_Mode == true  )  { ( m_button3.Pressed(true)  ) ; ( m_button3.Text ("Mode Auto / ON " )  );  }
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
   int x1 = ( 3 * INDENT_LEFT ) + BUTTON_WIDTH  ;
   int y1 = INDENT_TOP  ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit1.Create(m_chart_id,"Edit1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if ( !m_edit1.Text ( DoubleToString ( Average_Modification , 0 ) ) )
      return(false) ;
   if(!m_edit1.ReadOnly(false))
      return(true) ;
   if(!m_edit1.TextAlign(ALIGN_CENTER))
      return(true) ;
   if ( tooltip_enable == true ) {
               if(!ObjectSetString(0,"Edit1",OBJPROP_TOOLTIP,"Decrease/Increase Value Of Common BreakEven Stop Loss\nCalculated As Average Value Of All Positions\nEnter An Integer"))
                  return (false) ; }
   if ( !Add (m_edit1) )
      return(false) ;   
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
   int x1 = ( 3 * INDENT_LEFT ) + BUTTON_WIDTH  ;
   int y1 = ( 2 * INDENT_TOP )  + EDIT_HEIGHT ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit2.Create(m_chart_id,"Edit2",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit2.Text( DoubleToString ( Separate_Modification , 0 ) ) ) 
      return(false);
   if(!m_edit2.ReadOnly(false))
      return(true); 
   if(!m_edit2.TextAlign(ALIGN_CENTER))
      return(true);
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit2",OBJPROP_TOOLTIP,"Decrease/Increase Value Of Separate BreakEven Stop Losses\nEnter An Integer\nThis Option Works Only If All Positions Are Profitable\nSWAP And Commission Are Not Included "))
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
/////////////////            EDIT 3                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit3(void)
  {
//--- coordinates
   int x1 = ( 3 * INDENT_LEFT ) + BUTTON_WIDTH  ;
   int y1 = ( 3 * INDENT_TOP )  + ( 2* EDIT_HEIGHT ) ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit3.Create(m_chart_id,"Edit3",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit3.Text( DoubleToString ( BE_Mod_Level , 0 ) ) ) 
      return(false);
   if(!m_edit3.ReadOnly(false))
      return(true); 
   if(!m_edit3.TextAlign(ALIGN_CENTER))
      return(true);
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit3",OBJPROP_TOOLTIP,"Point Value That Has To Be Reached By The Least Profitable Position \nTo Set BreakEven Stop Losses As Separate \nAvailable If \"Mode Auto\" is ON "))
                  return(false) ; }
   if(!Add(m_edit3))
      return(false);   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////          CHECK_GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateCheckGroup (void)
  {
   //--- coordinates
   int x1 = ( 5.5 * INDENT_LEFT ) ;
   int y1 = ( 4 * INDENT_TOP ) + ( 3 * BUTTON_HEIGHT ) ;
   int x2 = x1 + CHECK_WIDTH ;
   int y2 = y1 + CHECK_HEIGHT;
//--- create
   if(!m_check_group.Create(m_chart_id,"CheckGroup",m_subwin,x1,y1,x2,y2))
      return(false);  
   if(!Add(m_check_group))
      return(false); 
   if(!m_check_group.AddItem("     Apply To Buy ",1))
         return(false);
   if(!m_check_group.AddItem("     Apply To Sell ",2))
         return(false);
   if ( Buy_Apply  == true   ) m_check_group.Check(0,1) ;
   if ( Sell_Apply == true   ) m_check_group.Check(1,1) ;
   if ( Buy_Apply  == false  ) m_check_group.Check(0,0) ;
   if ( Sell_Apply == false  ) m_check_group.Check(1,0) ;
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
   if ( log_display_enable == true ) { Print ("Button \"Common BE\" Has Been Clicked") ; }
   SetCommonBreakEven () ;
   
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
   if ( log_display_enable == true ) { Print ("Button \"Separate BE\" Has Been Clicked") ; }
   SetSeparateBreakEven () ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 3              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnClickButton3(void)
  {
   if ( log_display_enable == true ) { Print ("Button \"Mode Auto\" Has Been Clicked") ; }
  }

void CMainMenu::OnChangeCheckGroup(void)
  {
   //       Comment(__FUNCTION__+" : Value="+IntegerToString(m_check_group.Value()));
      if ( m_check_group.Value() == 0 )
           { Buy_Apply = false ; Sell_Apply = false ; if ( log_display_enable == true) { Print("BuyApply = ",Buy_Apply,"SELLApply = ",Sell_Apply); Print ( " Modifications Not Allowed " ) ; } }
      if ( m_check_group.Value() == 1 )    
           { Buy_Apply = true ; Sell_Apply = false ; if ( log_display_enable == true) { Print("BuyApply = ",Buy_Apply,"SELLApply = ",Sell_Apply); Print ( " Modification Allowed For BUY Positions, Modifications Not Allowed For SELL Positions " ) ;} }
      if ( m_check_group.Value() == 2 )    
           { Buy_Apply = false ; Sell_Apply = true ; if ( log_display_enable == true) { Print("BuyApply = ",Buy_Apply,"SELLApply = ",Sell_Apply); Print ( " Modification Allowed For SELL Positions, Modifications Not Allowed For BUY Positions " ) ;} }
      if ( m_check_group.Value() == 3 )    
           { Buy_Apply = true ; Sell_Apply = true ; if ( log_display_enable == true)  { Print("BuyApply = ",Buy_Apply,"SELLApply = ",Sell_Apply); Print ( " Modification Allowed For SELL Positions, Modifications Not Allowed For BUY Positions " ) ;} }
      if ( m_check_group.Value() > 3 )
           { Buy_Apply = false ; Sell_Apply =false ; if ( log_display_enable == true ) { Print("Error = ",GetLastError()," Restart Program ! ") ; } }
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////      ARE ALL BUY POSITIONS       //////////////////
/////////////////            PROFITABLE            //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool Are_All_Buy_Positions_Profitable ()
  {
   bool Are_All_Buy_Positions_Profitable ;
//------------------------------------------------------------------
   for ( int i = 0 ; i < OrdersTotal () ; i ++ )
    {
      if( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true )
        {
         if ( ( OrderType() == OP_BUY ) && ( OrderSymbol() == Symbol () ) )
           {
            if ( OrderOpenPrice () <  Bid ) { Are_All_Buy_Positions_Profitable = true  ; }
            if ( OrderOpenPrice () >= Bid ) { Are_All_Buy_Positions_Profitable = false ; break ; }
           }
         else
            Comment (" "); if ( log_display_enable == true ) { Print ( " Checking, Are All BUY Positions Profitable. ",OrderTicket(),". Not Current Symbol, Or Not BUY Position " ) ; }
        }
      else
          Print ( "Order Not Selected. Error = ", GetLastError()  ) ;
    }   
//--------------------------------------------------------------------------------      
   return ( Are_All_Buy_Positions_Profitable ) ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////      ARE ALL SELL POSITIONS      //////////////////
/////////////////            PROFITABLE            //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool Are_All_Sell_Positions_Profitable ()
  {
   bool Are_All_Sell_Positions_Profitable ;
//-------------------------------------------------------------------------------
   for ( int i = 0 ; i < OrdersTotal () ; i ++ )
    {
      if( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true )
        {
         if ( ( OrderType() == OP_SELL) && ( OrderSymbol() == Symbol () ) )
           {
            if ( OrderOpenPrice () >  Bid ) { Are_All_Sell_Positions_Profitable = true  ; }
            if ( OrderOpenPrice () <= Bid ) { Are_All_Sell_Positions_Profitable = false ; break ; }
           }
         else
            Comment (" "); if ( log_display_enable == true ) { Print ( " Checking, Are All SELL Positions Profitable. ",OrderTicket(),". Not Current Symbol, Or Not SELL Position " ) ; }
        }
      else
          Print ( "Order Not Selected. Error = ", GetLastError()  ) ;
    }   
//-------------------------------------------------------------------------------
   return ( Are_All_Sell_Positions_Profitable ) ;
  }   


/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ORDERS                //////////////////
/////////////////           TOTAL BUY              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
int OrdersTotalBuy()
  {
   int TOTAL_BUY = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if ( (OrderType() == OP_BUY) && (OrderSymbol() == Symbol () ) )
            TOTAL_BUY = TOTAL_BUY + 1;
         else
            TOTAL_BUY = TOTAL_BUY + 0;
        }
      else
         Print ( "Order Not Selected. Error = ", GetLastError()  ) ;
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
int OrdersTotalSell()
  {
   int TOTAL_SELL = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
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
double SearchForMinimalLotSizeBuy()
   {
      for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {   
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
double SearchForMinimalLotSizeSell()
   {
      for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {   
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
double CalculateAverageBuyPrice()
   {
   double AveragePrice ;
   int TotalBuy = OrdersTotalBuy() ;
   double SumOfBuy = 0 ;
   double LotSize = OrderLots() ;
   double Minimal_Lot_Size_Buy = 1 ;
   double TotalLotSizeBuy = 0 ;
   int AverageMultiply ;
//   Print("Number Of Total Buy is ",TotalBuy) ;
//   Print("Sum Of Buy is ",SumOfBuy) ;
///////////////////////////////////////////////////////////////////// Find The Lowest Lot Value
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {   
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
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {   
         if( ( OrderType () == OP_BUY ) && ( OrderSymbol () == Symbol () ) ) { SumOfBuy = SumOfBuy +  ( OrderOpenPrice () * ( OrderLots () * AverageMultiply ) ) ; 
                                                                              /* Print("Sum Of Buy = ", SumOfBuy )*/   ; TotalLotSizeBuy = TotalLotSizeBuy + OrderLots () ; }
         if( ( OrderType () == OP_BUY ) && ( OrderSymbol () != Symbol () ) ) { SumOfBuy = SumOfBuy                     ; /*Print("Sum Of Buy = ", SumOfBuy )*/ ; }
         if( ( OrderType () == OP_SELL) )                                    { SumOfBuy = SumOfBuy                     ; /*Print("Sum Of Buy = ", SumOfBuy )*/ ; }
            else
         GetLastError() ;
        }
     }    
   if ( log_display_enable == true ) Print ("Total Lot Size For Buy = ", TotalLotSizeBuy ) ;
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
double CalculateAverageSellPrice()
   {
   double AveragePrice ;
   int TotalSell = OrdersTotalSell() ;
   double SumOfSell = 0 ;
   double LotSize = OrderLots() ;
   double Minimal_Lot_Size_Sell = 1 ;
   double TotalLotSizeSell = 0 ;
   int AverageMultiply ;
//   Print("Number Of Total Sell is ",TotalSell) ;
//   Print("Sum Of Sell is ",SumOfSell) ;
///////////////////////////////////////////////////////////////////// Find The Lowest Lot Value
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {   
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
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {   
         if( ( OrderType () == OP_SELL ) && ( OrderSymbol () == Symbol () ) ) { SumOfSell = SumOfSell +  ( OrderOpenPrice () * ( OrderLots () * AverageMultiply ) ) ; 
                                                                               /*Print("Sum Of Sell = ", SumOfSell )*/    ; TotalLotSizeSell = TotalLotSizeSell + OrderLots () ; }
         if( ( OrderType () == OP_SELL ) && ( OrderSymbol () != Symbol () ) ) { SumOfSell = SumOfSell                     ; /*Print("Sum Of Sell = ", SumOfSell )*/ ; }
         if( ( OrderType () == OP_BUY) )                                      { SumOfSell = SumOfSell                     ; /*Print("Sum Of Sell = ", SumOfSell )*/ ; }
            else
         GetLastError() ;
        }
     }    
   if ( log_display_enable == true ) Print ("Total Lot Size For Sell = ", TotalLotSizeSell ) ;
   if ( TotalLotSizeSell != 0 ) { AveragePrice =  ( SumOfSell / TotalLotSizeSell ) / AverageMultiply ; }
      else Print ( "Total Sell = 0 " );
/////////////////////////////////////////////////////////////////////
      Average_Sell_Price = NormalizeDouble(AveragePrice,_Digits);
      return Average_Sell_Price ;
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////                SET               //////////////////
/////////////////          COMMON BREAKEVEN        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void SetCommonBreakEven()
   {
      if ( Buy_Apply  == true )
         {
          double CommonSL_Buy_NotNormalized = CalculateAverageBuyPrice () + ( Average_Modification * _Point ) ;
          double CommonSL_Buy = NormalizeDouble ( CommonSL_Buy_NotNormalized, _Digits ) ;
          if ( log_display_enable == true ) { Print ( " New Common Stop Loss BreakEven Level For All Open BUY Positions, Symbol ",Symbol()," = ",CommonSL_Buy ) ; }
          if ( CommonSL_Buy >= Bid ) { Print ( "Cannot Modify SL as ",CommonSL_Buy,". Bid = ",Bid,". Stop Loss Value Should Be Less Than Current BID Price" ) ; }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          if ( CommonSL_Buy < Bid )
          {  
             for ( int i=0 ; i < OrdersTotal() ; i++ )
               {
                 if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_BUY ) && ( OrderSymbol() == Symbol() ) )
                    {   
                    if((OrderModify (OrderTicket(), OrderOpenPrice(),  CommonSL_Buy, OrderTakeProfit(), 0, clrNONE))==true)
            
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Completed.");
                                          else
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Failed ");
                    }
                  else Print ( "Order Not Selected. Error = ",GetLastError () ) ;
               }
          }
  }
      if ( Sell_Apply == true )
         {
          double CommonSL_Sell_NotNormalized = CalculateAverageSellPrice () - ( Average_Modification * _Point ) ; 
          double CommonSL_Sell = NormalizeDouble ( CommonSL_Sell_NotNormalized, _Digits ) ;
          if ( log_display_enable == true ) { Print ( " New Common Stop Loss BreakEven Level For All Open SELL Positions, Symbol ",Symbol()," = ",CommonSL_Sell ) ; }
          if ( CommonSL_Sell <= Ask ) { Print ( "Cannot Modify SL as ",CommonSL_Sell,". Ask = ",Ask,". Stop Loss Value Should Be Greater Than Current Ask Price" ) ; }
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          if ( CommonSL_Sell > Ask )
          {  
             for ( int i=0 ; i < OrdersTotal() ; i++ )
               {
                 if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_SELL ) && ( OrderSymbol() == Symbol() ) )
                    {   
                    if((OrderModify (OrderTicket(), OrderOpenPrice(),  CommonSL_Sell, OrderTakeProfit(), 0, clrNONE))==true)
            
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Completed.");
                                          else
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Failed ");
                    }     
                 else Print ( "Order Not Selected. Error = ",GetLastError () ) ;   
               }
            }   
         }
      if ( ( Buy_Apply == false ) && ( Sell_Apply == false ) )
         {
            if ( log_display_enable == true ) Print ( " Modification Not Allowed. At Least One Option: APPLY TO BUY, APPLY TO SELL Should Be Selected " ) ;
         }
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////              SET                 //////////////////
/////////////////        SEPARATE BREAKEVEN        //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void SetSeparateBreakEven()
   {
   if ( Buy_Apply == true )
      {
         Print ( "Checking, Are All Buy Positions Profitable. Result = ", Are_All_Buy_Positions_Profitable () ) ;
         if ( Are_All_Buy_Positions_Profitable () == false )   
            { Print ( "Cannot Set Separate BreakEven Stop Losses, Not All Positions Are Profitable. Try Later." ) ; }
         if ( Are_All_Buy_Positions_Profitable () == true  )
          {
           for ( int i = 0 ;  i < OrdersTotal () ;  i ++ )
            { 
             if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_BUY ) && ( OrderSymbol() == Symbol() ) )
                    {   
                    if ( (OrderModify (OrderTicket(), OrderOpenPrice(),  OrderOpenPrice() + ( Separate_Modification * _Point ), OrderTakeProfit(), 0, clrNONE))==true )
            
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Completed.");
                                          else
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Failed ");
                    }
                  else Print ( "Order Not Selected. Error = ",GetLastError () ) ;
               }
          }        
      }
   if ( Sell_Apply == true )
      {
         Print ( "Checking, Are All Sell Positions Profitable. Result = ", Are_All_Sell_Positions_Profitable () ) ;
         if ( Are_All_Sell_Positions_Profitable () == false )   
            { Print ( "Cannot Set Separate BreakEven Stop Losses, Not All Positions Are Profitable. Try Later." ) ; }
         if ( Are_All_Sell_Positions_Profitable () == true  )
          {
           for ( int i = 0 ;  i < OrdersTotal () ;  i ++ )
            { 
             if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_SELL ) && ( OrderSymbol() == Symbol() ) )
                    {   
                    if ( (OrderModify (OrderTicket(), OrderOpenPrice(),  OrderOpenPrice() - ( Separate_Modification * _Point ), OrderTakeProfit(), 0, clrNONE))==true)
            
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Completed.");
                                          else
                                          Print("Modification StopLoss for Ticket No ",OrderTicket()," Failed ");
                    }
                  else Print ( "Order Not Selected. Error = ",GetLastError () ) ;
               }
          }        
      }
   if ( ( Buy_Apply == false ) && ( Sell_Apply == false ) )
      {
         if ( log_display_enable == true ) Print ( " Modification Not Allowed. At Least One Option: APPLY TO BUY, APPLY TO SELL Should Be Selected " ) ;
      }
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////   SEARCH THE LEAST PROFITABLE    //////////////////
/////////////////       POSITION FOR BUY           //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double Search_The_Highest_Open_Price_For_Buy ()
   {
    double HighestOpenPrice = 0 ;
    for ( int i = 0 ;  i < OrdersTotal () ;  i ++ )
            { 
             if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_BUY ) && ( OrderSymbol() == Symbol() ) )
                {
                  if ( OrderOpenPrice () >  HighestOpenPrice ) HighestOpenPrice = OrderOpenPrice () ;
                  if ( OrderOpenPrice () <= HighestOpenPrice ) HighestOpenPrice = HighestOpenPrice  ;
                }
             else
                  Comment (" ") ;
             }     
    return ( HighestOpenPrice ) ;
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////   SEARCH THE LEAST PROFITABLE    //////////////////
/////////////////       POSITION FOR SELL          //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double Search_The_Lowest_Open_Price_For_Sell ()
   {
    double LowestOpenPrice = 0 ;
    for ( int i = 0 ;  i < OrdersTotal () ;  i ++ )
            { 
             if ( ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true) && ( OrderType () == OP_SELL ) && ( OrderSymbol() == Symbol() ) )
                {
                  if ( OrderOpenPrice () >  LowestOpenPrice ) LowestOpenPrice = OrderOpenPrice () ;
                  if ( OrderOpenPrice () <= LowestOpenPrice ) LowestOpenPrice = LowestOpenPrice  ;
                }
             else
                  Comment (" ") ;
             }     
    return ( LowestOpenPrice ) ;
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           MODE AUTO              //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void ModeAuto()
   {
    if ( Buy_Apply  == true )
     {
      if ( Are_All_Buy_Positions_Profitable () == false ) 
        { SetCommonBreakEven () ; if ( log_display_enable == true ) { Print ("Mode Auto, Common BE Switched.") ; } }
      if ( ( Are_All_Buy_Positions_Profitable () == true )  && ( Bid > ( Search_The_Highest_Open_Price_For_Buy () + ( BE_Mod_Level * _Point ) ) ) )
        { SetSeparateBreakEven () ; if (log_display_enable == true )  { Print ("Mode Auto, Separate BE Switched.") ;  } }
     }
    if ( Sell_Apply == true )
     {
      if ( Are_All_Sell_Positions_Profitable () == false ) 
        { SetCommonBreakEven () ; if ( log_display_enable == true ) { Print ("Mode Auto, Common BE Switched.") ; } }
      if ( ( Are_All_Sell_Positions_Profitable () == true  )  && ( Ask < ( Search_The_Lowest_Open_Price_For_Sell () - ( BE_Mod_Level * _Point ) ) )                                                                       )
        { SetSeparateBreakEven () ; if (log_display_enable == true ) { Print ("Mode Auto, Separate BE Switched.") ; } }
     }
    if ( ( Buy_Apply == false ) && ( Sell_Apply == false ) )
     {
      if ( log_display_enable == true ) Print ( " Modification Not Allowed. At Least One Option: APPLY TO BUY, APPLY TO SELL Should Be Selected " ) ;
     } 
   } 
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             ON TICK              //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }

//+------------------------------------------------------------------+
