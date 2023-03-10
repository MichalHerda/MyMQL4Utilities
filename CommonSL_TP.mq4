//+------------------------------------------------------------------+
//|                                                       COMMON.mq4 |
//|                                                     Michal Herda |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "author: Michal Herda"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Enter Stop Loss And / Or Take Profit Value And Set It As Common For All Positions In The Current chart"
#property strict
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <Controls\Dialog.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\CheckGroup.mqh>
#include <Controls\Label.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Button.mqh>
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASS             ////////////////////
/////////////////           DEFINES              ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//indent and gaps
#define INDENT_LEFT                         (17)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (12)      // indent from top (with allowance for border width)
//--- for group controls
#define CHECK_GROUP_WIDTH                   (150)     // size by X coordinate
#define CHECK_GROUP_HEIGHT                  (40)      // size by Y coordinate
//--- for group controls
#define RADIO_GROUP_WIDTH                   (150)     // size by X coordinate
#define RADIO_GROUP_HEIGHT                  (40)      // size by Y coordinate
//for Label
#define LABEL_HEIGHT                        (15)
#define LABEL_WIDTH                         (14)
//--- for buttons
#define BUTTON_WIDTH                        (150)     // size by X coordinate
#define BUTTON_HEIGHT                       (40)      // size by Y coordinate
//-----for check group 
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate
//--- for the indication area
#define EDIT_WIDTH                          (120)
#define EDIT_HEIGHT                         (20)      // size by Y coordinate
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASS             ////////////////////
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
class CMainMenu : public CAppDialog
  {
public:
      CRadioGroup       m_radio_group ;  
      CCheckGroup       m_check_group ;  
      CLabel            m_label1 ;
      CLabel            m_label2 ;
      CEdit             m_edit1 ;
      CEdit             m_edit2 ;
      CButton           m_button ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                     CMainMenu(void);
                                    ~CMainMenu(void);
//--- create
      virtual bool                   Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- chart event handler
      virtual bool                   OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create dependent controls
      bool                           CreateRadioGroup(void) ;
      bool                           CreateCheckGroup(void) ; 
      bool                           CreateLabel1(void) ;
      bool                           CreateLabel2(void) ;
      bool                           CreateEdit1(void) ;
      bool                           CreateEdit2(void) ;
      bool                           CreateButton(void) ;
//--- handlers of the dependent controls events
      void                           OnChangeRadioGroup(void) ;     
      void                           OnChangeCheckGroup(void) ;
      void                           OnClickButton(void) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
ON_EVENT(ON_CHANGE,m_radio_group,OnChangeRadioGroup)
ON_EVENT(ON_CHANGE,m_check_group,OnChangeCheckGroup)
ON_EVENT(ON_CLICK,m_button,OnClickButton)
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
   if(!CreateRadioGroup())
      return(false) ;
   if(!CreateCheckGroup())
      return(false) ;
   if(!CreateLabel1())
      return(false) ;
   if(!CreateLabel2())
      return(false) ;
   if(!CreateEdit1())
      return(false) ;
   if(!CreateEdit2())
      return(false) ;
   if(!CreateButton())
      return(false) ;
 //--- succeed
//////////////////////////////////////////////////////////////////////////////////////////////////////////////        
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
CMainMenu MainWindow;
bool BuyApply = false ;
bool SellApply = false ;
bool SetStopLoss = false ;
bool SetTakeProfit = false ;
double NewStoploss ;
double NewTakeProfit ;
//extern bool Logs_Display_Enable = true ;
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
//---
//---
//--- create application dialog
   if(!MainWindow.Create(0,"  Common SL And TP Set ",0,10,40,202,300))
      return(INIT_FAILED);
//--- run application
   MainWindow.Run();
//--- enable object create events
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_CREATE,true);
//--- enable object delete events
   ChartSetInteger(ChartID(),CHART_EVENT_OBJECT_DELETE,true);
//--- succeed
   return(INIT_SUCCEEDED);
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
   //---
   Comment("");
//--- destroy dialog
   MainWindow.Destroy(reason);
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
   MainWindow.ChartEvent(id,lparam,dparam,sparam);
//////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit1" )
  {
   string Value = ObjectGetString(0,"Edit1",OBJPROP_TEXT,0);
   //string Value = sparam;
   NewStoploss = StringToDouble(Value);
//////////////////////////////////////////////////////////////////////
  Print("Entered Stop Loss = ",NewStoploss);
  }
//////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit2" )
  {
   string Value = ObjectGetString(0,"Edit2",OBJPROP_TEXT,0);
   //string Value = sparam;
   NewTakeProfit = StringToDouble(Value);
//////////////////////////////////////////////////////////////////////
  Print("Entered Take Profit = ", NewTakeProfit);}
  }
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////          RADIO GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateRadioGroup(void)
  {
//--- coordinates
   int x1= INDENT_LEFT;
   int y1= INDENT_TOP;
   int x2= x1 + RADIO_GROUP_WIDTH;
   int y2= y1 + RADIO_GROUP_HEIGHT;
//--- create
   if(!m_radio_group.Create(m_chart_id,"Radio Group",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_radio_group))
      return(false);
//--- fill out with strings for(int i=0;i<2;i++)
   if(!m_radio_group.AddItem("       Buy Apply",1))
      return(false);
   if(!m_radio_group.AddItem("       Sell Apply ",2))
      return(false);
   m_radio_group.Value(0);
//   Comment(__FUNCTION__+" : Value="+IntegerToString(m_radio_group.Value()));
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           ON_CHANGE              //////////////////
/////////////////          RADIO GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnChangeRadioGroup(void)
  {
//   Comment(__FUNCTION__+" : Value="+IntegerToString(m_radio_group.Value()));
   if(m_radio_group.Value() == 1)
     {
      BuyApply = true ; SellApply = false ;
      Print("All Buy Positions From Current Chart Access Allowed");
     }
   if(m_radio_group.Value() == 2)
     {
      SellApply = true ; BuyApply = false ;
      Print("All Sell Positions From Current Chart Access Allowed");
     }  
   if ( ( m_radio_group.Value() < 1 ) || ( m_radio_group.Value() > 2 ) )
     {
      SellApply = false ; BuyApply = false ;
      Print("No Access Allowed. Select Option BuyApply/SellApply from RadioGroup");
     }  
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////          CHECK GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////  
bool CMainMenu::CreateCheckGroup(void)
  {
//--- coordinates
   int x1 = INDENT_LEFT ;
   int y1 = ( 2 * INDENT_TOP ) + RADIO_GROUP_HEIGHT ;
   int x2 = x1 + CHECK_GROUP_WIDTH ;
   int y2 = y1 + CHECK_GROUP_HEIGHT ;
//--- create
   if(!m_check_group.Create(m_chart_id,"CheckGroup",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_check_group))
      return(false);
//--- fill out with strings
//   for(int i=0;i<2;i++)
      if(!m_check_group.AddItem("    Set Stop Loss ",1))
         return(false);
      if(!m_check_group.AddItem("   Set Take Profit ",2))
         return(false);
   m_check_group.Check(0,0);
   m_check_group.Check(1,0);
//   Comment(__FUNCTION__+" : Value="+IntegerToString(m_check_group.Value()));
//--- succeed
   return(true) ;  
  
  }
  
void CMainMenu::OnChangeCheckGroup(void)
  {
//   Comment(__FUNCTION__+" : Value="+IntegerToString(m_check_group.Value()));
      if ( m_check_group.Value() == 0 )
           { SetStopLoss = false ; SetTakeProfit = false ; Print ( " SL Modification Not Allowed, TP Modification Not Allowed " ) ; }
      if ( m_check_group.Value() == 1 )    
           { SetStopLoss = true ; SetTakeProfit = false ; Print ( " SL Modification Allowed, TP Modification Not Allowed " ) ;}
      if ( m_check_group.Value() == 2 )    
           { SetStopLoss = false ; SetTakeProfit = true ; Print ( " SL Modification Not Allowed, TP Modification  Allowed " ) ; }
      if ( m_check_group.Value() == 3 )    
           { SetStopLoss = true ; SetTakeProfit = true ; Print ( " SL Modification Allowed, TP Modification Allowed " ) ; }
      if ( m_check_group.Value() < 0 || m_check_group.Value() > 3 )
          { SetStopLoss = false ; SetTakeProfit = false ; Print ( " SL Modification Not Allowed, TP Modification Not Allowed " ) ; }
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            LABEL 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel1(void)
  {
//--- coordinates
   int x1 = INDENT_LEFT ;
   int y1 = ( 3 * INDENT_TOP ) + CHECK_GROUP_HEIGHT + RADIO_GROUP_HEIGHT ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = y1 + LABEL_HEIGHT ;
//--- create
   if(!m_label1.Create(m_chart_id,"Label1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label1.Text("SL :"))
      return(false) ;
   if(!ObjectSetString(0,"Label1",OBJPROP_TOOLTIP,"Modify Stop Loss Value. "))
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
/////////////////            LABEL 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel2(void)
  {
//--- coordinates
   int x1 = INDENT_LEFT ;
   int y1 = ( 4 * INDENT_TOP ) + CHECK_GROUP_HEIGHT + RADIO_GROUP_HEIGHT + LABEL_HEIGHT;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = y1 + LABEL_HEIGHT ;
//--- create
   if(!m_label2.Create(m_chart_id,"Label2",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label2.Text("TP :"))
      return(false) ;
   if(!ObjectSetString(0,"Label2",OBJPROP_TOOLTIP,"Modify Take Profit Value"))
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
bool CMainMenu::CreateEdit1(void)
  {
//--- coordinates
   double x1 = ( 2 * INDENT_LEFT ) + LABEL_WIDTH ;
   double y1 = ( 3 * INDENT_TOP  ) + RADIO_GROUP_HEIGHT + CHECK_GROUP_HEIGHT ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2 =  y1 + EDIT_HEIGHT ;
/////////////////////////////////////////////////////////////////////
//   double Average_Buy_Price = CalculateAverageBuyPrice () ;
//--- create
   if(!m_edit1.Create(m_chart_id,"Edit1",m_subwin,x1,y1,x2,y2))
      return(false);
//   if(!m_edit1.Text(DoubleToString(Average_Buy_Price, Digits)))
//      return(false);
   if(!m_edit1.ReadOnly(false))
      return(true);
   if(!ObjectSetString(0,"Edit1",OBJPROP_TOOLTIP,"Enter A New Stop Loss Value For All Positions. \nDefault Value = 0 "))
      return(false) ;
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
   double x1 = ( 2 * INDENT_LEFT ) + LABEL_WIDTH;
   double y1 = ( 4 * INDENT_TOP ) + RADIO_GROUP_HEIGHT + CHECK_GROUP_HEIGHT + EDIT_HEIGHT ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2=  y1 + EDIT_HEIGHT;
//////////////////////////////////////////////////////////////////////
//   double Average_Sell_Price = CalculateAverageSellPrice () ;
//--- create
   if(!m_edit2.Create(m_chart_id,"Edit2",m_subwin,x1,y1,x2,y2))
      return(false);
//   if(!m_edit2.Text(DoubleToString(Average_Sell_Price, Digits)))
//      return(false);
   if(!m_edit2.ReadOnly(false))
      return(true); 
   if(!ObjectSetString(0,"Edit2",OBJPROP_TOOLTIP,"Enter A New Take Profit Value For All Positions. \nDefault Value = 0"))
      return(false) ; 
   if(!Add(m_edit2))
      return(false);
   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton(void)
  {
///--- coordinates
   int x1 = INDENT_LEFT ;
   int y1 = ( 5 * INDENT_TOP ) + RADIO_GROUP_HEIGHT + CHECK_GROUP_HEIGHT + ( 2 * EDIT_HEIGHT ) ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;
//--- create
   if(!m_button.Create(m_chart_id,"Button",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button.Text("APPLY THE SETTINGS"))
      return(false);
   if(!ObjectSetString(0,"Button",OBJPROP_TOOLTIP,"Modify, Using The Settings Above."))
      return(false) ;
   if(!Add(m_button))
      return(false);
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////             BUTTON               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CMainMenu::OnClickButton(void)
  {
   Print("APPLY THE SETTINGS Button Has Been Pressed");
   if ( OrdersTotal () < 1 ) { Print ("Number Of Open Positions Is ", OrdersTotal() ) ; }
   if ( BuyApply == false && SellApply == false ) { Print ("Select Options") ;}
   if ( IsTradeAllowed ( Symbol(), TimeCurrent () ) == false ) { Print("Market Is Closed. The Above Settings Cannot Be Applied") ; }
      else
      {
      if ( ( SetStopLoss == true || SetTakeProfit == true ) && ( BuyApply == true || SellApply == true ) ) { Print (" Modification Process In Progress ") ; }
      for(int i = OrdersTotal() - 1; i >=0; i-- )
         {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
           {
            if ( ( SellApply == true ) && ( OrderType() == OP_SELL ) && ( OrderSymbol () == Symbol () ) ) { Modify(i, NewStoploss, NewTakeProfit) ; }
            if ( ( BuyApply  == true ) && ( OrderType() == OP_BUY  ) && ( OrderSymbol () == Symbol () ) ) { Modify(i, NewStoploss, NewTakeProfit) ; }  
            if ( ( OrderSymbol () != Symbol () ) && ( BuyApply == true || SellApply == true ) ) { Print ( "Cannot Modify Position No ", OrderTicket(), " This EA Works On Current Chart Only "); }
            if ( ( SellApply == true ) && ( OrderType() == OP_BUY  ) && ( OrderSymbol () == Symbol () ) ) 
               { if ( ( SetStopLoss == true || SetTakeProfit == true ) ) Print (" Mode Is SELL  APPLY. Cannot Modify Selected Position No ", OrderTicket() ," Please Select BUY APPLY If You Need To Modify Selected Position.");}
            if ( ( BuyApply == true  ) && ( OrderType() == OP_SELL ) && ( OrderSymbol () == Symbol () ) ) 
               { if ( ( SetStopLoss == true || SetTakeProfit == true ) ) Print (" Mode Is BUY APPLY. Cannot Modify Selected Position No ", OrderTicket() ," Please Select SELL APPLY If You Need To Modify Selected Position.");}
           }
          } 
      }     
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             MODIFY               //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void Modify(int i, double NewStoploss, double NewTakeProfit)
   {
      if ( ( SetStopLoss   == true  ) && ( SetTakeProfit == false ) )
         {
            if ( ( BuyApply == true ) && ( NewStoploss >= Bid ) ) { Print ( " For BUY, Stop Loss Value Has To Be Lower Than Current Price " ) ; }
            if ( ( SellApply == true) && ( NewStoploss <= Ask ) ) { Print ( " For SELL, Stop Loss Value Has To Be Higher Than Current Price " ) ; }
            if ( OrderModify (OrderTicket(), OrderOpenPrice(), NewStoploss, OrderTakeProfit(), 0, clrNONE ) == true)
               Print(" Stop Loss Modification, Position No ",OrderTicket()," Completed ");
            else
               Print(" Stop Loss Modification, Position No ",OrderTicket()," Failed");
         }
      if ( ( SetTakeProfit == true  ) && ( SetStopLoss == false ) )
         {
            if ( ( BuyApply == true ) && ( NewTakeProfit <= Bid ) )   { Print ( " For BUY, Take Profit Value Has To Be Higher Than Current Price " ) ; }
            if ( ( SellApply == true) && ( NewTakeProfit >= Ask ) )   { Print ( " For SELL, Take Profit Value Has To Be Lower Than Current Price " ) ; }
            if ( OrderModify (OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NewTakeProfit, 0, clrNONE ) == true)
               Print(" Stop Loss Modification, Position No ",OrderTicket()," Completed ");
            else
               Print(" Stop Loss Modification, Position No ",OrderTicket()," Failed");
         }
      if ( ( SetTakeProfit == true  ) && ( SetStopLoss == true ) )
         {
            if ( ( BuyApply == true ) && ( NewStoploss >= Bid ) ) { Print ( " For BUY, Stop Loss Value Has To Be Lower Than Current Price " ) ; }
            if ( ( SellApply == true) && ( NewStoploss <= Ask ) ) { Print ( " For SELL, Stop Loss Value Has To Be Higher Than Current Price " ) ; }
            if ( ( BuyApply == true ) && ( NewTakeProfit <= Bid ) )   { Print ( " For BUY, Take Profit Value Has To Be Higher Than Current Price " ) ; }
            if ( ( SellApply == true) && ( NewTakeProfit >= Ask ) )   { Print ( " For SELL, Take Profit Value Has To Be Lower Than Current Price " ) ; }
            if ( OrderModify (OrderTicket(), OrderOpenPrice(), NewStoploss, NewTakeProfit, 0, clrNONE ) == true)
               Print(" Stop Loss Modification, Position No ",OrderTicket()," Completed ");
            else
               Print(" Stop Loss Modification, Position No ",OrderTicket()," Failed");
         }  
      if ( ( SetStopLoss   == false ) && ( SetTakeProfit == false ) ) { Print (" Modification Is Not Allowed. Select At Last One Option : Set Stop Loss / Set Take Profit " ) ; }
   
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
void OnTick()
  {
//---
//   if(Logs_Display_Enable == true )
//      {
//      Print (" BuyApply = ", BuyApply ) ;
//      Print (" SellApply = ", SellApply ) ;
//      Print (" SetStopLoss = ", SetStopLoss ) ;
//      Print (" SetTakeProfit = ",SetTakeProfit ) ; 
//      }
  }