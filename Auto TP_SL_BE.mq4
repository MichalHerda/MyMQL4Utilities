//+------------------------------------------------------------------+
//|                                     Simple Auto TP SL And BE.mq4 |
//|                                                     Michal Herda |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Michal Herda" 
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Program For Automatic Placement Of Stop Loss And Take Profit Orders. \nValues Are Calculated As Points Distance From Open Price."
#property description "BreakEven Option Is Also Included. \nAll Options Could Be Applied To BUY, SELL Separately Or Together. \nIf In Doubt, The Instruction Is Displayed In The Tooltip."
#property strict
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
#define INDENT_TOP                                     (10)
#define INDENT_LEFT                                    (12)
//for Button
#define BUTTON_HEIGHT                                  (30)
#define BUTTON_WIDTH                                   (105)
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
      CEdit                        m_edit4 ;
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
      bool                         CreateEdit4        (void) ;
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
   if (!CreateEdit4())
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
extern bool log_display_enable_ALL_SYMBOLS = false ;
extern bool tooltip_enable                 = true  ;
/////////////////////////////////////////////////////////////////////
bool        AutoSL_Enable      = false   ;
bool        AutoTP_Enable      = false   ;
bool        AutoBE_Enable      = false   ;
bool        Buy_Apply          = false   ;
bool        Sell_Apply         = false   ;
double      Close_Price_Buy    = 0 ;
double      Close_Price_Sell   = 0 ;
int         SL_Level           = 0 ;
int         TP_Level           = 0 ;
int         BE_Level           = 0 ;
int         BE_ModLevel        = 0 ;
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
   if(!MainWindow.Create(0,"               Simple Auto TP SL And BE ",0,40,40,330,285))
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
   SL_Level = StringToInteger(Value1) ;
  }
/////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit2" )
  {
   string Value2 = ObjectGetString(0, "Edit2", OBJPROP_TEXT, 0) ;
   TP_Level = StringToInteger (Value2) ;   
  }
/////////////////////////////////////////////////////////////////////
    if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit3" )
  {
   string Value3 = ObjectGetString(0, "Edit3", OBJPROP_TEXT, 0) ;
   BE_Level = StringToInteger (Value3) ;   
  }
/////////////////////////////////////////////////////////////////////
    if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit4" )
  {
   string Value4 = ObjectGetString(0, "Edit4", OBJPROP_TEXT, 0) ;
   BE_ModLevel= StringToInteger (Value4) ;   
  }
///////////////////////////////////////////////////////////////////// 
   Modification () ;
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
   double y1 = ( 2 * INDENT_TOP ) + BUTTON_HEIGHT  ;
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
/////////////////           BUTTON 3               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateButton3(void)
  {
///--- coordinates
   double x1 = ( 2 * INDENT_LEFT ) ;
   double y1 = ( 3 * INDENT_TOP ) + ( 2.75 * BUTTON_HEIGHT ) ;
   double x2 = x1 + EDIT_WIDTH ;
   double y2=  y1 + EDIT_HEIGHT ;
//--- create
   if(!m_button3.Create(m_chart_id,"Button3",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if ( tooltip_enable == true) { 
               if(!ObjectSetString(0,"Button3",OBJPROP_TOOLTIP,"Auto Breakeven Enable/Disable \nPressed: ON \nNot Pressed: OFF"))
                  return(false) ; }
   if(!Add(m_button3))
      return(false) ;
   m_button3.Locking(true) ;   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////    
   if ( AutoBE_Enable == false )  { ( m_button3.Pressed(false) ) ; ( m_button3.Text ("Auto BE / OFF ")  );  }
   if ( AutoBE_Enable == true  )  { ( m_button3.Pressed(true)  ) ; ( m_button3.Text ("Auto BE / ON " )  );  }
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
   int x1 = ( 4 * INDENT_LEFT ) + BUTTON_WIDTH  ;
   int y1 = INDENT_TOP  ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit1.Create(m_chart_id,"Edit1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if ( !m_edit1.Text ( DoubleToString ( SL_Level, 0 ) ) )
      return(false) ;
   if(!m_edit1.ReadOnly(false))
      return(true) ;
   if(!m_edit1.TextAlign(ALIGN_CENTER))
      return(true) ;
   if ( tooltip_enable == true ) {
               if(!ObjectSetString(0,"Edit1",OBJPROP_TOOLTIP,"Enter The SL Value In Points \nMeasured From The Open Price \nEnter An Integer Value"))
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
   int x1 = ( 4 * INDENT_LEFT ) + BUTTON_WIDTH  ;
   int y1 = ( 2 * INDENT_TOP )  + EDIT_HEIGHT ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit2.Create(m_chart_id,"Edit2",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_edit2.Text( DoubleToString ( TP_Level  , 0 ) ) ) 
      return(false);
   if(!m_edit2.ReadOnly(false))
      return(true); 
   if(!m_edit2.TextAlign(ALIGN_CENTER))
      return(true);
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit2",OBJPROP_TOOLTIP,"Enter The TP Value In Points \nMeasured From The Open Price \nEnter An Integer Value"))
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
   int x1 = ( 4 * INDENT_LEFT )  + BUTTON_WIDTH ;
   int y1 = ( 3 * INDENT_TOP ) + ( 2 * EDIT_HEIGHT ) ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT; 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit3.Create(m_chart_id,"Edit3",m_subwin,x1,y1,x2,y2))
      return(false);
   if ( !m_edit3.Text(DoubleToString ( BE_Level, 0) ) )
      return(false);
   if(!m_edit3.ReadOnly(false))
      return(true);
   if(!m_edit3.TextAlign(ALIGN_CENTER))
      return(true);   
   if ( tooltip_enable == true) {
               if(!ObjectSetString ( 0,"Edit3",OBJPROP_TOOLTIP,"Enter BreakEven Level In Points \nMessured As Distance Beetween Open Price And New Stop Loss Level\nEnter An Integer Value ") )
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
/////////////////            EDIT 4                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit4(void)
  {
//--- coordinates
   int x1 = ( 4 * INDENT_LEFT )  + BUTTON_WIDTH ;
   int y1 = ( 4 * INDENT_TOP ) + ( 3 * EDIT_HEIGHT ) ;
   int x2 = x1 + BUTTON_WIDTH ;
   int y2 = y1 + BUTTON_HEIGHT; 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit4.Create(m_chart_id,"Edit4",m_subwin,x1,y1,x2,y2))
      return(false);
   if (!m_edit4.Text ( DoubleToString (BE_ModLevel, 0 ) ) )
      return(false);
   if(!m_edit4.ReadOnly(false))
      return(true);
   if(!m_edit4.TextAlign(ALIGN_CENTER))
      return(true);   
   if ( tooltip_enable == true) {
               if(!ObjectSetString(0,"Edit4",OBJPROP_TOOLTIP,"Enter The Level That Has To Be Reached To Set The New Stop Loss On BreakEven Level Set Above\nEnter An Integer Value In Points "))
                  return(false) ; }
   if(!Add(m_edit4))
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
   int x1 = 5.5 * INDENT_LEFT ;
   int y1 = ( 5 * INDENT_TOP ) + ( 4 * BUTTON_HEIGHT ) ;
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
   if (Buy_Apply ==true  ) m_check_group.Check(0,1) ;
   if (Sell_Apply==true  ) m_check_group.Check(1,1) ;
   if (Buy_Apply==false  ) m_check_group.Check(0,0) ;
   if (Sell_Apply==false ) m_check_group.Check(1,0) ;
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
               else 
               { AutoSL_Enable = false ; m_button1.Text ( "Auto SL / OFF" ) ; 
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
               else 
               { AutoTP_Enable = false ; m_button2.Text("Auto TP / OFF") ; 
               if ( log_display_enable == true ) { Print ( "AutoTP_Enable = ", AutoTP_Enable ) ; }
               }
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
    if ( m_button3.Pressed() ) 
       { 
        AutoBE_Enable = true ; 
        m_button3.Text("Auto BE / ON") ; 
        if ( log_display_enable == true ) { Print ( "AutoBE_Enable = ", AutoTP_Enable ) ; }
       }
               else { AutoBE_Enable = false ; m_button3.Text("Auto BE / OFF") ; 
               if ( log_display_enable == true ) { Print ( "AutoBE_Enable = ", AutoTP_Enable ) ; }
               }
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           ON_CHANGE              //////////////////
/////////////////          CHECK_GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
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
/////////////////          MODIFICATION            //////////////////
/////////////////            FUNCTION              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void Modification ()
{//----------------------------------------------------------------loop for
for ( int i = 0 ; i < OrdersTotal () ; i ++ )
  {//--------------------------------------------------------------select
   if ( OrderSelect ( i, SELECT_BY_POS, MODE_TRADES ) == true ) 
     {//-----------------------------------------------------------check is it current symbol
      if ( ( OrderSymbol () != Symbol () ) && ( Buy_Apply == true || Sell_Apply == true ) && ( AutoBE_Enable == true || AutoSL_Enable == true || AutoTP_Enable == true ) )
         {   
            if ( log_display_enable_ALL_SYMBOLS == true )  
            Print ( " Selected Order, No ", OrderTicket (), " Cannot Be Modified , It is ",OrderSymbol ()," This Program Is Running On ",Symbol()," Chart ") ;
            else
            Comment(" ") ;
         } 
      if ( ( OrderSymbol () == Symbol () ) && ( Buy_Apply == true || Sell_Apply == true ) )
         {
          //------------------------------------------------------------------------------------
          //------------------------------Reset All Values--------------------------------------
          //------------------------------------------------------------------------------------
          double TP_Buy_Not_Normalized  = 0 ;
          double TP_Sell_Not_Normalized = 0 ;
          double SL_Buy_Not_Normalized  = 0 ;
          double SL_Sell_Not_Normalized = 0 ;
          double BE_Buy_Not_Normalized  = 0 ;
          double BE_Sell_Not_Normalized = 0 ;
          double M_Buy_Not_Normalized   = 0 ;
          double M_Sell_Not_Normalized  = 0 ;
          //////////////////////////////////////////////////////////////////////////////////////
          double TP_Buy                 = 0 ;
          double TP_Sell                = 0 ;
          double SL_Buy                 = 0 ;
          double SL_Sell                = 0 ;
          double BE_Buy                 = 0 ;
          double BE_Sell                = 0 ;
          double Mod_Buy                = 0 ;
          double Mod_Sell               = 0 ;
          //-----------------------------------------------------------check is it applied to BUY/SELL Positions
          //----------------------------Calculate Order Levels----------------------------------
          //------------------------------------------------------------------------------------          
          TP_Buy_Not_Normalized  = OrderOpenPrice () + ( TP_Level * _Point )    ;
          TP_Sell_Not_Normalized = OrderOpenPrice () - ( TP_Level * _Point )    ;
          SL_Buy_Not_Normalized  = OrderOpenPrice () - ( SL_Level * _Point )    ;
          SL_Sell_Not_Normalized = OrderOpenPrice () + ( SL_Level * _Point )    ;
          BE_Buy_Not_Normalized  = OrderOpenPrice () + ( BE_Level * _Point )    ;
          BE_Sell_Not_Normalized = OrderOpenPrice () - ( BE_Level * _Point )    ;
          M_Buy_Not_Normalized   = OrderOpenPrice () + ( BE_ModLevel * _Point ) ;
          M_Sell_Not_Normalized  = OrderOpenPrice () - ( BE_ModLevel * _Point ) ;
          //------------------------------------------------------------------------------------
          //---------------------------------Normalize------------------------------------------
          //------------------------------------------------------------------------------------
          TP_Buy                 = NormalizeDouble ( TP_Buy_Not_Normalized,  _Digits ) ; if ( log_display_enable == true ) { Print ( "TP_Buy "  ,OrderTicket(), " = ", TP_Buy  ) ; }
          TP_Sell                = NormalizeDouble ( TP_Sell_Not_Normalized, _Digits ) ; if ( log_display_enable == true ) { Print ( "TP_Sell " ,OrderTicket(), " = ", TP_Sell ) ; }
          SL_Buy                 = NormalizeDouble ( SL_Buy_Not_Normalized,  _Digits ) ; if ( log_display_enable == true ) { Print ( "SL_Buy  " ,OrderTicket(), " = ", SL_Buy  ) ; }
          SL_Sell                = NormalizeDouble ( SL_Sell_Not_Normalized, _Digits ) ; if ( log_display_enable == true ) { Print ( "SL_Sell " ,OrderTicket(), " = ", SL_Sell ) ; }
          BE_Buy                 = NormalizeDouble ( BE_Buy_Not_Normalized,  _Digits ) ; if ( log_display_enable == true ) { Print ( "BE_Buy  " ,OrderTicket(), " = ", BE_Buy  ) ; }
          BE_Sell                = NormalizeDouble ( BE_Sell_Not_Normalized, _Digits ) ; if ( log_display_enable == true ) { Print ( "BE_Sell " ,OrderTicket(), " = ", BE_Sell ) ; }
          Mod_Buy                = NormalizeDouble ( M_Buy_Not_Normalized,   _Digits ) ; if ( log_display_enable == true ) { Print ( "Mod_Buy " ,OrderTicket(), " = ", Mod_Buy ) ; }
          Mod_Sell               = NormalizeDouble ( M_Sell_Not_Normalized,  _Digits ) ; if ( log_display_enable == true ) { Print ( "Mod_Sell ",OrderTicket()," = ", Mod_Sell ) ; }
          //-------------------------------------------------------------------------          
          if ( ( OrderType () == OP_BUY ) && ( Buy_Apply == true ) )
            {
             if ( AutoTP_Enable == true  ) 
               {
                   if ( OrderTakeProfit () != TP_Buy )
                        {
                           if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic TP Will Be Set: ", TP_Buy ) ; }
                           if ( OrderModify ( OrderTicket (), OrderOpenPrice(), OrderStopLoss() , TP_Buy, 0, clrNONE ) == true)
                                  Print( " Modification Ticket No ",OrderTicket()," suceed " ) ;
                            else 
                                  Print( " Modification Ticket No ",OrderTicket()," failed. Error = ", GetLastError() ) ;
                         }
               }
             if ( ( AutoSL_Enable == true ) && ( AutoBE_Enable == false ) ) 
               {
                    if ( OrderStopLoss () != SL_Buy )
                        {
                           if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic SL Will Be Set : ", SL_Buy ) ; }
                           if ( OrderModify ( OrderTicket (), OrderOpenPrice(), SL_Buy , OrderTakeProfit(), 0, clrNONE ) == true)
                                  Print( " Modification Ticket No ",OrderTicket()," suceed " ) ;
                            else 
                                  Print( " Modification Ticket No ",OrderTicket()," failed. Error = ", GetLastError() ) ;
                         }       
               }
             if ( ( AutoSL_Enable == true  && AutoBE_Enable == true  ) || ( AutoSL_Enable == false && AutoBE_Enable == true  ) )
               {
                   if ( OrderStopLoss () == BE_Buy )                     
                        { if( log_display_enable == true ) 
                        {   Print ( " SL, Ticket No ",OrderTicket()," = BE " );}
                          else
                            Comment(" ")                          ; }
                   if ( ( OrderStopLoss () != BE_Buy ) && ( Bid <  Mod_Buy ) )   
                        { 
                           if ( OrderStopLoss () != SL_Buy )
                              {
                                 if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic SL Will Be Set : ", SL_Buy ) ; }
                                 if ( OrderModify ( OrderTicket (), OrderOpenPrice(), SL_Buy , OrderTakeProfit(), 0, clrNONE ) == true)
                                        Print( " Modification Ticket No ",OrderTicket()," suceed " ) ;
                                  else 
                                        Print( " Modification Ticket No ",OrderTicket()," failed. Error = ", GetLastError() ) ;
                               }       
                           else    
                                  if (log_display_enable == true ) { Print ( " BE Modification Level, Ticket No ",OrderTicket(), " Not Reached"  ) ; }
                        } 
                   if ( ( OrderStopLoss () != BE_Buy ) && ( Bid >= Mod_Buy ) )
                        {
                           if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic BE Will Be Set : ", BE_Buy ) ; }
                           if ( OrderModify ( OrderTicket (), OrderOpenPrice(), BE_Buy , OrderTakeProfit(), 0, clrNONE ) == true)
                                  Print( " Modification Ticket No ",OrderTicket()," suceed " ) ;
                            else 
                                  Print( " Modification Ticket No ",OrderTicket()," failed. Error = ", GetLastError() ) ;
                        }
               }
//             if ( AutoSL_Enable == false && AutoBE_Enable == true  ) 
//               {
//               
//              }
            }
          if ( OrderType () == OP_SELL && Sell_Apply == true )
            {
             if ( AutoTP_Enable == true  ) 
               {
                   if ( OrderTakeProfit () != TP_Sell )
                         {
                           if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic TP Will Be Set: ", TP_Sell ) ; }
                           if ( OrderModify ( OrderTicket (), OrderOpenPrice(), OrderStopLoss() , TP_Sell, 0, clrNONE ) == true)
                                  Print( " Modification Ticket No ",OrderTicket()," suceed " ) ;
                            else 
                                  Print( " Modification Ticket No ",OrderTicket()," failed. Error = ", GetLastError() ) ;
                         }
               }
             if ( AutoSL_Enable == true  && AutoBE_Enable == false ) 
               {
                    if ( OrderStopLoss () != SL_Sell )
                         {
                           if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic SL Will Be Set: ", SL_Sell ) ; }
                           if ( OrderModify ( OrderTicket (), OrderOpenPrice(), SL_Sell , OrderTakeProfit(), 0, clrNONE ) == true)
                                  Print( " Modification Ticket No ",OrderTicket()," suceed " ) ;
                            else 
                                  Print( " Modification Ticket No ",OrderTicket()," failed. Error = ", GetLastError() ) ;
                         }       
               }
             if ( ( AutoSL_Enable == true  && AutoBE_Enable == true  ) || ( AutoSL_Enable == false && AutoBE_Enable == true  ) )
               {
                   if ( OrderStopLoss () == BE_Sell )                     
                         { if( log_display_enable == true ) 
                         { Print ( " SL, Ticket No ",OrderTicket()," = BE " );}
                          else
                           Comment (" ")                          ; }
                   if ( OrderStopLoss () != BE_Sell && Ask >  Mod_Sell )   
                        { 
                           if ( OrderStopLoss () != SL_Sell )
                              {
                                 if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic SL Will Be Set : ", SL_Sell ) ; }
                                 if ( OrderModify ( OrderTicket (), OrderOpenPrice(), SL_Sell , OrderTakeProfit(), 0, clrNONE ) == true)
                                        Print( " Modification Ticket No ",OrderTicket()," Suceed " ) ;
                                 else 
                                        Print( " Modification Ticket No ",OrderTicket()," Failed. Error = ", GetLastError() ) ;
                               }       
                           else    
                                 if ( log_display_enable == true ) { Print ( " BE Modification Level, Ticket No ",OrderTicket(), " Not Reached"  ) ; }
                        } 
                   if ( OrderStopLoss () != BE_Sell && Ask <= Mod_Sell )
                        {
                           if ( log_display_enable == true ) { Print ( " Selected Position Is ", OrderTicket (), "Automatic BE Will Be Set : ", BE_Sell ) ; }
                           if ( OrderModify ( OrderTicket (), OrderOpenPrice(), BE_Sell , OrderTakeProfit(), 0, clrNONE ) == true)
                                  Print( " Modification Ticket No ",OrderTicket()," Suceed " ) ;
                            else 
                                  Print( " Modification Ticket No ",OrderTicket()," Failed. Error = ", GetLastError() ) ;
                        }
               }
//             if ( AutoSL_Enable == false && AutoBE_Enable == true  ) 
//               {
//               
//               }
            }
         }
      }//----------------------------------------------------------check is it current symbol
   }//-------------------------------------------------------------select
}//----------------------------------------------------------------loop for   
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
   if ( log_display_enable == true )
      {
       Print ( "SL Level Value, In Points From Open Price = ", SL_Level ) ;
       Print ( "TP Level Value, In Points From Open Price = ", TP_Level ) ;
       Print ( "BE Level Value, As Distance Beetween Open Price And New Stop Loss Value In Points = ", BE_Level ) ;
       Print ( "BE Modification Level, As Distance Beetween Open Price And Level At Which The New SL Is Set = ", BE_ModLevel ) ;
       Print ( "AutoSL Enable = ",AutoSL_Enable ) ;
       Print ( "AutoTP Enable = ",AutoTP_Enable ) ;
       Print ( "AutoBE Enable = ",AutoBE_Enable ) ;
      }
      Modification () ;
//    Modify () ;   
  
     }